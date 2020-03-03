//
//  Loan.swift
//  MortgageCalculator
//
//  Created by Shawn Gee on 3/2/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation

struct Loan: Codable, Identifiable, Equatable {
    let id = UUID()
    
    var purchasePrice: Double?
    var monthlyPayment: Double?
    var downPayment: Double
    var interestRate: Double // 4.5% == 4.5
    var term: Int
    
    // Calculated variables for convenience
    
    var monthlyRate: Double {
        interestRate / 100 / 12 // 4.5% annual == .00375 monthly
    }
    
    var months: Int {
        term * 12
    }
    
    static func == (lhs: Loan, rhs: Loan) -> Bool {
        lhs.id == rhs.id
    }
}
