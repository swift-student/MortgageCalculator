//
//  Calculator.swift
//  MortgageCalculator
//
//  Created by Shawn Gee on 3/2/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation

struct Calculator {
    
    static func monthlyPayment(forLoan loan: Loan) -> Double {
        guard var principle = loan.purchasePrice else { return loan.monthlyPayment ?? 0 }
        principle -= loan.downPayment
        
        let dividend = loan.monthlyRate * pow(1 + loan.monthlyRate, loan.months)
        let divisor = pow(1 + loan.monthlyRate, loan.months) - 1
        
        return principle * (dividend/divisor)
    }
    
    static func purchasePrice(forLoan loan: Loan) -> Double {
        //TODO: Implement
        return 1000000
    }
    
    static func amortizationTable(forLoan loan: Loan) -> AmortizationSchedule {
        var balance = loan.purchasePrice ?? Calculator.purchasePrice(forLoan: loan)
        let monthlyPayment = loan.monthlyPayment ?? Calculator.monthlyPayment(forLoan: loan)
        
        balance -= loan.downPayment
        
        var table = AmortizationTable()
        
        for _ in 1...Int(loan.months) {
            let payment = monthlyPayment < balance ? monthlyPayment : balance
            let interest = loan.monthlyRate * balance
            let principle = payment - interest
            balance -= principle
            table.append(AmortizationData(interest: interest, principle: principle, balance: balance))
        }
        
        return table
    }
}
