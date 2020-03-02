//
//  Loan.swift
//  MortgageCalculator
//
//  Created by Shawn Gee on 3/2/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation

struct Loan {
    var purchasePrice: Double?
    var monthlyPayment: Double?
    var downPayment: Double
    var term: Double
    var interestRate: Double // 4.5% == 4.5
    
    // Calculated variables for convenience
    
    var monthlyRate: Double {
        interestRate / 100 / 12 // 4.5% annual == .00375 monthly
    }
    
    var months: Double {
        term * 12
    }
}
