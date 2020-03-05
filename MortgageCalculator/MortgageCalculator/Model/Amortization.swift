//
//  Amortization.swift
//  MortgageCalculator
//
//  Created by Shawn Gee on 3/2/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation

typealias AmortizationSchedule = [AmortizationData]

struct AmortizationData {
    let interest: Double
    let principle: Double
    let balance: Double
    
    static var empty = AmortizationData(interest: 0, principle: 0, balance: 0)
}
