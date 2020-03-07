//
//  LoanDetailViewController.swift
//  MortgageCalculator
//
//  Created by Shawn Gee on 3/2/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

protocol LoanDetailDelegate {
    func didFinishEditing()
}

class LoanDetailViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var priceOrPaymentSelector: UISegmentedControl!
    @IBOutlet weak var priceOrPaymentTextField: UITextField!
    @IBOutlet weak var priceOrPaymentLabel: UILabel!
    @IBOutlet weak var downPaymentTextField: UITextField!
    @IBOutlet weak var downPaymentTypeSelector: UISegmentedControl!
    @IBOutlet weak var interestRateTextField: UITextField!
    @IBOutlet weak var termSelector: UISegmentedControl!
    
    
    //MARK: - IBActions
    
    @IBAction func priceOrPaymentSelected(_ sender: UISegmentedControl) {
        updatePriceOrPayment()
    }
    
    @IBAction func downPaymentTypeSelected(_ sender: UISegmentedControl) {
        updateDownPayment()
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        dismiss(animated: true)
        shouldSave = false
    }
    
    @IBAction func calculateTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    //MARK: - Properties
    
    var defaultLoanName: String?
    var loan: Loan?
    var loanController: LoanController?
    var delegate: LoanDetailDelegate?
    
    
    //MARK: - Private
    
    private var shouldSave = true
    
    private let loanTerms = [15, 20, 25, 30]
    
    private func updateViews() {
        if let defaultLoanName = defaultLoanName {
            titleTextField.text = defaultLoanName
        }
        
        guard let loan = loan else { return }
        
        titleTextField.text = loan.name
        priceOrPaymentSelector.selectedSegmentIndex = loan.purchasePrice != nil ? 0 : 1
        updatePriceOrPayment()
        updateDownPayment()
        interestRateTextField.text = String(loan.interestRate)
        termSelector.selectedSegmentIndex = loanTerms.firstIndex(of: loan.term) ?? 0
    }
    
    private func updatePriceOrPayment() {
        if priceOrPaymentSelector.selectedSegmentIndex == 0 {
            priceOrPaymentLabel.text = "Purchase Price:"
            priceOrPaymentTextField.placeholder = "200000"
        
            if let purchasePrice = loan?.purchasePrice {
                priceOrPaymentTextField.text = String(format: "%.0f", purchasePrice)
            } else {
                priceOrPaymentTextField.text = ""
            }
        } else {
            priceOrPaymentLabel.text = "Monthly Payment:"
            priceOrPaymentTextField.placeholder = "1200"
            
            if let monthlyPayment = loan?.monthlyPayment {
                priceOrPaymentTextField.text = String(format: "%.0f", monthlyPayment)
            } else {
                priceOrPaymentTextField.text = ""
            }
        }
    }
    
    private func updateDownPayment() {
        if downPaymentTypeSelector.selectedSegmentIndex == 0 {
            downPaymentTextField.placeholder = "40000"
            downPaymentTextField.text = String(format: "%.0f", loan?.downPayment ?? 0)
            if downPaymentTextField.text == "0" { downPaymentTextField.text = ""}
        } else {
            downPaymentTextField.placeholder = "20"
            if let loan = loan {
                let purchasePrice = loan.purchasePrice ?? Calculator.purchasePrice(forLoan: loan)
                let downPayment = loan.downPayment
                downPaymentTextField.text = String(format: "%.0f", downPayment / purchasePrice * 100)
                if downPaymentTextField.text == "0" { downPaymentTextField.text = ""}
            }
        }
    }
    
    private func save() {
        guard let loanName = titleTextField.text else { return }
        
        guard let priceOrPaymentText = priceOrPaymentTextField.text,
              let downPaymentText = downPaymentTextField.text,
              let interestRateText = interestRateTextField.text else { return }
        
        var purchasePrice: Double? = nil
        var monthlyPayment: Double? = nil
        
        if priceOrPaymentSelector.selectedSegmentIndex == 0 {
            purchasePrice = Double(priceOrPaymentText)
        } else {
            monthlyPayment = Double(priceOrPaymentText)
        }
        
        var downPayment = Double(downPaymentText) ?? 0
        guard let interestRate = Double(interestRateText) else { return }
        
        let term = loanTerms[termSelector.selectedSegmentIndex]
        
        if downPaymentTypeSelector.selectedSegmentIndex == 1 {
            // Down payment entered as percentage
            let percentage = downPayment / 100
            
            if let purchasePrice = purchasePrice {
                downPayment = purchasePrice * percentage
                
            } else if let monthlyPayment = monthlyPayment {
                let tempLoan = Loan(name: "", purchasePrice: nil, monthlyPayment: monthlyPayment, downPayment: 0, interestRate: interestRate, term: term)
                let tempPurchasePrice = Calculator.purchasePrice(forLoan: tempLoan)
                
                downPayment = tempPurchasePrice * percentage
            }
        }
        
        if var loan = loan {
            loan.name = loanName
            loan.purchasePrice = purchasePrice
            loan.monthlyPayment = monthlyPayment
            loan.downPayment = downPayment
            loan.interestRate = interestRate
            loan.term = term
            loanController?.update(loan: loan)
        } else {
            let newLoan = Loan(name: loanName, purchasePrice: purchasePrice, monthlyPayment: monthlyPayment, downPayment: downPayment, interestRate: interestRate, term: term)
            loanController?.add(loan: newLoan)
        }
        
        delegate?.didFinishEditing()
    }
    
    func downPaymentAmount(withPercentage percentage: Double) {
        
    }
    
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if shouldSave { save() }
    }
    
}
