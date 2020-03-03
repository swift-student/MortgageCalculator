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
    @IBOutlet weak var priceOrPaymentSelector: UISegmentedControl!
    @IBOutlet weak var priceOrPaymentTextField: UITextField!
    @IBOutlet weak var priceOrPaymentLabel: UILabel!
    @IBOutlet weak var downPaymentTextField: UITextField!
    @IBOutlet weak var interestRateTextField: UITextField!
    @IBOutlet weak var termSelector: UISegmentedControl!
    
    
    //MARK: - IBActions
    
    @IBAction func priceOrPaymentSelected(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            priceOrPaymentLabel.text = "Purchase Price:"
            priceOrPaymentTextField.text = String(loan?.purchasePrice ?? 0)
        } else {
            priceOrPaymentLabel.text = "Monthly Payment:"
             priceOrPaymentTextField.text = String(loan?.monthlyPayment ?? 0)
        }
    }
    
    @IBAction func termSelected(_ sender: UISegmentedControl) {
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        dismiss(animated: true)
        shouldSave = false
    }
    
    @IBAction func calculateTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    var loan: Loan?
    var loanController: LoanController?
    var delegate: LoanDetailDelegate?
    
    
    //MARK: - Private
    
    private var shouldSave = true
    
    private func updateViews() {
        guard let loan = loan else { return }
        
        if let purchasePrice = loan.purchasePrice {
            priceOrPaymentTextField.text = String(purchasePrice)
        }
        
        if let monthlyPayment = loan.monthlyPayment {
            priceOrPaymentSelector.selectedSegmentIndex = 1
            priceOrPaymentTextField.text = String(monthlyPayment)
        }
        
        downPaymentTextField.text = String(loan.downPayment)
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
        guard let priceOrPaymentText = priceOrPaymentTextField.text,
              let downPaymentText = downPaymentTextField.text,
              let interestRateText = interestRateTextField.text else { return }
        
        guard let downPayment = Double(downPaymentText),
              let interestRate = Double(interestRateText) else { return }
        
        var purchasePrice: Double? = nil
        var monthlyPayment: Double? = nil
        
        if priceOrPaymentSelector.selectedSegmentIndex == 0 {
            purchasePrice = Double(priceOrPaymentText)
        } else {
            monthlyPayment = Double(priceOrPaymentText)
        }
        
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
        
        if var loan = loan {
            loan.purchasePrice = purchasePrice
            loan.monthlyPayment = monthlyPayment
            loan.downPayment = downPayment
            loan.interestRate = interestRate
            loan.term = term
            loanController?.update(loan: loan)
        } else {
            let newLoan = Loan(purchasePrice: purchasePrice, monthlyPayment: monthlyPayment, downPayment: downPayment, interestRate: interestRate, term: term)
            loanController?.add(loan: newLoan)
        }
        
        delegate?.didFinishEditing()
    }
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if shouldSave { save() }
    }
    
}
