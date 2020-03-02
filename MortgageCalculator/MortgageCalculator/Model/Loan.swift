//
//  Loan.swift
//  MortgageCalculator
//
//  Created by Shawn Gee on 3/2/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation

struct Loan: Codable {
    var purchasePrice: Double?
    var monthlyPayment: Double?
    var downPayment: Double
    var interestRate: Double // 4.5% == 4.5
    var term: Double
    
    // Calculated variables for convenience
    
    var monthlyRate: Double {
        interestRate / 100 / 12 // 4.5% annual == .00375 monthly
    }
    
    var months: Double {
        term * 12
    }
    
    init(purchasePrice: Double, downPayment: Double, interestRate: Double, term: Double) {
        self.purchasePrice = purchasePrice
        self.monthlyPayment = nil
        self.downPayment = downPayment
        self.interestRate = interestRate
        self.term = term
    }
    
    init(monthlyPayment: Double, downPayment: Double, interestRate: Double, term: Double) {
        self.purchasePrice = nil
        self.monthlyPayment = monthlyPayment
        self.downPayment = downPayment
        self.interestRate = interestRate
        self.term = term
    }
}
