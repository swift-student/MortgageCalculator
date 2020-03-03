//
//  CurrencyExtensions.swift
//  MortgageCalculator
//
//  Created by Shawn Gee on 3/3/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation

extension NumberFormatter {
    static var currencyFormatter: NumberFormatter {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.maximumFractionDigits = 0
        return currencyFormatter
    }
}

extension Double {
    var currencyString: String? {
        NumberFormatter.currencyFormatter.string(from: NSNumber(value: self))
    }
}
