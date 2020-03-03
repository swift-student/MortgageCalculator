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
        let monthltyPayment = principle * magicNumber(monthlyRate: loan.monthlyRate, months: loan.months)
        
        return monthltyPayment.roundedToCent(.up)
    }
    
    static func purchasePrice(forLoan loan: Loan) -> Double {
        guard let monthlyPayment = loan.monthlyPayment else { return loan.purchasePrice ?? 0 }
        
        var purchasePrice = monthlyPayment / magicNumber(monthlyRate: loan.monthlyRate, months: loan.months)
        purchasePrice += loan.downPayment
        
        return purchasePrice.roundedToCent(.down)  
    }
    
    static func totalInterest(forLoan loan: Loan) -> Double {
        let schedule = Calculator.monthlyAmortizationSchedule(forLoan: loan)
        let totalInterest = schedule.map { $0.interest }.reduce(0, { $0 + $1})
        return totalInterest.roundedToCent(.toNearestOrAwayFromZero)
    }
   
    
    static func monthlyAmortizationSchedule(forLoan loan: Loan) -> AmortizationSchedule {
        var balance = loan.purchasePrice ?? Calculator.purchasePrice(forLoan: loan)
        let monthlyPayment = loan.monthlyPayment ?? Calculator.monthlyPayment(forLoan: loan)
        
        balance -= loan.downPayment
        
        var schedule = AmortizationSchedule()
        
        for _ in 1...Int(loan.months) {
            let interest = (loan.monthlyRate * balance).roundedToCent(.toNearestOrAwayFromZero)
            
            let payment: Double
            let principle: Double
            
            if balance < monthlyPayment {
                principle = balance
                payment = interest + principle
            } else {
                payment = monthlyPayment
                principle = (payment - interest).roundedToCent(.toNearestOrAwayFromZero)
            }
                        
            balance -= principle
            balance = balance.roundedToCent(.toNearestOrAwayFromZero)
            schedule.append(AmortizationData(interest: interest, principle: principle, balance: balance))
        }
        
        return schedule
    }
    
    static func yearlyAmortizationSchedule(forLoan loan: Loan) -> AmortizationSchedule {
        let monthlySchedule = monthlyAmortizationSchedule(forLoan: loan)
        
        var yearlySchedule = AmortizationSchedule()
        
        var yearlyInterest: Double = 0
        var yearlyPrinciple: Double = 0
        
        for month in 1...loan.months {
            yearlyInterest += monthlySchedule[month - 1].interest
            yearlyPrinciple += monthlySchedule[month - 1].principle
            
            if month % 12 == 0 {
                let interest = yearlyInterest.roundedToCent(.toNearestOrAwayFromZero)
                let principle = yearlyPrinciple.roundedToCent(.toNearestOrAwayFromZero)
                let balance = monthlySchedule[month - 1].balance
            
                yearlySchedule.append(AmortizationData(interest: interest, principle: principle, balance: balance))
                yearlyInterest = 0
                yearlyPrinciple = 0
            }
        }
        
        return yearlySchedule
    }
    
    
    //MARK: - Private
    
    private static func magicNumber(monthlyRate: Double, months: Int) -> Double {
        let dividend = monthlyRate * pow(1 + monthlyRate, Double(months))
        let divisor = pow(1 + monthlyRate, Double(months)) - 1
        
        return dividend / divisor
    }
}

extension Double {
    func roundedToCent(_ roundingRule: FloatingPointRoundingRule) -> Double {
        (self * 100).rounded(roundingRule) / 100
    }
}
