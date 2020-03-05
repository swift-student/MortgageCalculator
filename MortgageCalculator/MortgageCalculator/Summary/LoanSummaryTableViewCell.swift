//
//  LoanSummaryTableViewCell.swift
//  MortgageCalculator
//
//  Created by Shawn Gee on 3/3/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

class LoanSummaryTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var loanNameLabel: UILabel!
    
    @IBOutlet weak var purchasePriceLabel: UILabel!
    @IBOutlet weak var amountFinancedLabel: UILabel!
    @IBOutlet weak var monthlyPaymentLabel: UILabel!
    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var interestRateLabel: UILabel!
    @IBOutlet weak var totalInterestLabel: UILabel!
    @IBOutlet weak var totalPaymentsLabel: UILabel!
    
    
    //MARK: - Properties
    
    var loan: Loan? {
        didSet {
            updateLabels()
        }
    }
    
    var color: UIColor? {
        didSet {
            updateHeaderColor()
        }
    }
    
    
    //MARK: - Private
    
    private func updateLabels() {
        guard let loan = loan else { return }
        let purchasePrice = loan.purchasePrice ?? Calculator.purchasePrice(forLoan: loan)
        let monthlyPayment = loan.monthlyPayment ?? Calculator.monthlyPayment(forLoan: loan)
        let amountFinanced = purchasePrice - loan.downPayment
        let totalInterest = Calculator.totalInterest(forLoan: loan)
        
        purchasePriceLabel.text = purchasePrice.currencyString
        amountFinancedLabel.text = amountFinanced.currencyString
        monthlyPaymentLabel.text = monthlyPayment.currencyString
        termLabel.text = "\(loan.term) Year"
        interestRateLabel.text = "\(loan.interestRate)%"
        totalInterestLabel.text = totalInterest.currencyString
        totalPaymentsLabel.text = (totalInterest + amountFinanced).currencyString
    }
    
    private func updateHeaderColor() {
        guard let color = color else { return }
        headerView.backgroundColor = color
    }
}


