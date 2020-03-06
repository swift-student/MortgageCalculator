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
        if sender.selectedSegmentIndex == 0 {
            priceOrPaymentTextField.placeholder = "200000"
            priceOrPaymentLabel.text = "Purchase Price:"
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
    
    @IBAction func downPaymentTypeSelected(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
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
    
    private func updateViews() {
        if let defaultLoanName = defaultLoanName {
            titleTextField.text = defaultLoanName
        }
        
        guard let loan = loan else { return }
        
        titleTextField.text = loan.name
        
        if let purchasePrice = loan.purchasePrice {
            priceOrPaymentTextField.text = String(format: "%.0f", purchasePrice)
        }
        
        if loan.monthlyPayment != nil {
            priceOrPaymentSelector.selectedSegmentIndex = 1
            priceOrPaymentSelected(priceOrPaymentSelector)
        }
        
        downPaymentTextField.text = String(format: "%.0f", loan.downPayment)
        if downPaymentTextField.text == "0" { downPaymentTextField.text = ""}
        
        interestRateTextField.text = String(loan.interestRate)
        
        switch loan.term {
        case 15:
            termSelector.selectedSegmentIndex = 0
        case 20:
            termSelector.selectedSegmentIndex = 1
        case 25:
            termSelector.selectedSegmentIndex = 2
        default:
            termSelector.selectedSegmentIndex = 3
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
        
        let term: Int
        
        switch termSelector.selectedSegmentIndex {
        case 0:
            term = 15
        case 1:
            term = 20
        case 2:
            term = 25
        default:
            term = 30
        }
        
        if downPaymentTypeSelector.selectedSegmentIndex == 1 {
            // Down payment entered as percentage
            if let purchasePrice = purchasePrice {
                downPayment = purchasePrice * (downPayment / 100)
            } else if let monthlyPayment = monthlyPayment {
                let tempLoan = Loan(name: "", purchasePrice: nil, monthlyPayment: monthlyPayment, downPayment: 0, interestRate: interestRate, term: term)
                let tempPurchasePrice = Calculator.purchasePrice(forLoan: tempLoan)
                downPayment = tempPurchasePrice * (downPayment / 100)
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
