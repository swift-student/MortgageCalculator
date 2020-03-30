//
//  BarGraphViewModel.swift
//  MortgageCalculator
//
//  Created by Shawn Gee on 3/4/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation

class BarGraphViewModel: ObservableObject {
    @Published var numValues = 0
    
    @Published var shouldAnimate = false
    
    @Published var sectionOneTitle: String = ""
    @Published var sectionOneFirstValue: Double = 100
    @Published var sectionOneSecondValue: Double = 100
    
    @Published var sectionTwoTitle: String = ""
    @Published var sectionTwoFirstValue: Double = 100
    @Published var sectionTwoSecondValue: Double = 100
    
    @Published var sectionThreeTitle: String = ""
    @Published var sectionThreeFirstValue: Double = 100
    @Published var sectionThreeSecondValue: Double = 100
    
    @Published var maxValue: Double = 1000
    
    @Published var firstKeyName = "" { didSet { updateNumValues() } }
    @Published var secondKeyName = "" { didSet { updateNumValues() } }
    
    
    private func updateNumValues() {
        var count = 0
        if firstKeyName != "" { count += 1 }
        if secondKeyName != "" { count += 1 }
        numValues = count
    }
}
