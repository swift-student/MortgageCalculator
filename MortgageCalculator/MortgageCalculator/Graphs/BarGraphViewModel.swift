//
//  BarGraphViewModel.swift
//  MortgageCalculator
//
//  Created by Shawn Gee on 3/4/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation

class BarGraphViewModel: ObservableObject {
    @Published var numSections = 1
    
    @Published var shouldAnimate = false
    
    @Published var sectionOneTitle: String = "Interest"
    @Published var sectionOneFirstValue: Double = 300
    @Published var sectionOneSecondValue: Double?
    
    @Published var sectionTwoTitle: String = "Principle"
    @Published var sectionTwoFirstValue: Double = 300
    @Published var sectionTwoSecondValue: Double?
    
    @Published var sectionThreeTitle: String = "Total"
    @Published var sectionThreeFirstValue: Double = 300
    @Published var sectionThreeSecondValue: Double?
    
    @Published var maxValue: Double = 1000
    
    @Published var firstKeyName = "Loan A"
    @Published var secondKeyName = "Loan B"
}
