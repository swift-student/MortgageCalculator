//
//  TotalsBarGraphViewController.swift
//  MortgageCalculator
//
//  Created by Shawn Gee on 3/9/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import SwiftUI

class TotalsBarGraphViewController: UIHostingController<BarGraphView> {
    
    //MARK: - Properties
    
    var loanController: LoanController?
    var loanASchedule: AmortizationSchedule? { didSet { update() } }
    var loanBSchedule: AmortizationSchedule? { didSet { update() } }
    var yearIndex = 0 { didSet { updateYear(animated: true) } }
    
    
    //MARK: - Init
    
    init() {
        super.init(rootView: BarGraphView(viewModel: viewModel))
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: BarGraphView(viewModel: viewModel))
        setup()
    }
    
    
    //MARK: - Private
    
    private let viewModel = BarGraphViewModel()
    
    private func setup() {
        view.backgroundColor = .clear
    }
    
    private func update() {
        guard let loanController = loanController else { return }
        
        viewModel.shouldAnimate = false
        
        var loanAMax = 0.01
        var loanBMax = 0.01
        
        if let loanASchedule = loanASchedule {
            // Calculate max for scale
            let loanATotalInterest = loanASchedule.map{ $0.interest }.reduce(0, { $0 + $1 })
            let loanATotalPrinciple = loanASchedule.map{ $0.principle }.reduce(0, { $0 + $1 })
            loanAMax = max(loanATotalInterest, loanATotalPrinciple)
        }
        
        if let loanBSchedule = loanBSchedule {
            let loanBTotalInterest = loanBSchedule.map{ $0.interest }.reduce(0, { $0 + $1 })
            let loanBTotalPrinciple = loanBSchedule.map{ $0.principle }.reduce(0, { $0 + $1 })
            loanBMax = max(loanBTotalInterest, loanBTotalPrinciple)
        }
        
        viewModel.maxValue = max(loanAMax, loanBMax)
        
        viewModel.sectionOneTitle = "Interest"
        viewModel.sectionTwoTitle = "Principle"
        viewModel.sectionThreeTitle = "Balance"
        
        viewModel.firstKeyName = loanController.loans.first?.name ?? ""
        viewModel.secondKeyName = loanController.loans.element(atIndex: 1)?.name ?? ""
        
        updateYear(animated: false)
    }
    
    private func updateYear(animated: Bool) {
        viewModel.shouldAnimate = animated
        
        var loanAInterestPaid = 0.0
        var loanBInterestPaid = 0.0
        
        var loanAPrinciplePaid = 0.0
        var loanBPrinciplePaid = 0.0
        
        var loanABalance = 0.0
        var loanBBalance = 0.0
        
        if let loanASchedule = loanASchedule {
            let year = min(yearIndex, loanASchedule.count - 1)
            let scheduleToYear = loanASchedule[0...year]
            
            loanAInterestPaid = scheduleToYear.map{ $0.interest }.reduce(0, { $0 + $1 })
            loanAPrinciplePaid = scheduleToYear.map{ $0.principle }.reduce(0, { $0 + $1 })
            loanABalance = scheduleToYear[year].balance
        }
        
        if let loanBSchedule = loanBSchedule {
            let year = min(yearIndex, loanBSchedule.count - 1)
            let scheduleToYear = loanBSchedule[0...year]
            
            loanBInterestPaid = scheduleToYear.map{ $0.interest }.reduce(0, { $0 + $1 })
            loanBPrinciplePaid = scheduleToYear.map{ $0.principle }.reduce(0, { $0 + $1 })
            loanBBalance = scheduleToYear[year].balance
        }
        
        viewModel.sectionOneFirstValue = loanAInterestPaid
        viewModel.sectionOneSecondValue = loanBInterestPaid
        
        viewModel.sectionTwoFirstValue = loanAPrinciplePaid
        viewModel.sectionTwoSecondValue = loanBPrinciplePaid
        
        viewModel.sectionThreeFirstValue = loanABalance
        viewModel.sectionThreeSecondValue = loanBBalance
    }
    
}
