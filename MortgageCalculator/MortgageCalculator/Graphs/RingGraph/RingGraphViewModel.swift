//
//  RingGraphViewModel.swift
//  MortgageCalculator
//
//  Created by Shawn Gee on 3/5/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import SwiftUI

class RingGraphViewModel: ObservableObject {
    
    @Published var shouldAnimate = false
    
    @Published var title = "Principle"
    
    @Published var firstRingName = "Loan A"
    @Published var firstRingValue: Double = 100 { didSet { updateFirstRingProgress() } }
    @Published var firstRingMaxValue: Double = 1000 { didSet { updateFirstRingProgress() } }
    @Published var firstRingProgress: CGFloat = 0.0
    
    
    @Published var secondRingName = "Loan B"
    @Published var secondRingValue: Double = 100 { didSet { updateSecondRingProgress() } }
    @Published var secondRingMaxValue: Double = 1000 { didSet { updateSecondRingProgress() } }
    @Published var secondRingProgress: CGFloat = 0.0
    
    
    func updateFirstRingProgress() {
        firstRingProgress = CGFloat(firstRingValue / firstRingMaxValue)
    }
    
    func updateSecondRingProgress() {
        secondRingProgress = CGFloat(secondRingValue / secondRingMaxValue)
    }
}
