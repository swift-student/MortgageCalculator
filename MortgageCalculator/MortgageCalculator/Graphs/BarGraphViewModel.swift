//
//  BarGraphViewModel.swift
//  MortgageCalculator
//
//  Created by Shawn Gee on 3/4/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation

class BarGraphViewModel: ObservableObject {
    
    struct Section {
        var title: String
        var firstValue: Double
        var secondValue: Double?
        var maxValue: Double
    }
    
    @Published var sections = [
        Section(title: "Interest", firstValue: 300, secondValue: 350, maxValue: 1000),
        Section(title: "Principle", firstValue: 500, secondValue: 600, maxValue: 1000),
        Section(title: "Total", firstValue: 800, secondValue: 920, maxValue: 1000)
    ]
    
    @Published var firstKeyName = "Loan A"
    @Published var secondKeyName = "Loan B"
}
