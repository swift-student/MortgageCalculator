//
//  ProgressRingGraphViewController.swift
//  MortgageCalculator
//
//  Created by Shawn Gee on 3/10/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import SwiftUI

class ProgressRingGraphViewController: UIHostingController<RingGraphView> {
    
    //MARK: - Properties
    
    var loanController: LoanController?
    var loanASchedule: AmortizationSchedule? { didSet { update() } }
    var loanBSchedule: AmortizationSchedule? { didSet { update() } }
    var yearIndex = 0 { didSet { updateYear(animated: true) } }
    
    
    //MARK: - Init
    
    init() {
        super.init(rootView: RingGraphView(viewModel: viewModel))
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: RingGraphView(viewModel: viewModel))
        setup()
    }
    
    
    //MARK: - Private
    
    private let viewModel = RingGraphViewModel()
    
    private func setup() {
        view.backgroundColor = .clear
    }
    
    private func update() {
        guard let loanController = loanController else { return }

        viewModel.shouldAnimate = false
        
        var loanAAmountFinanced = 0.1
        var loanBAmountFinanced = 0.1
        
        if let loanASchedule = loanASchedule {
            loanAAmountFinanced = loanASchedule.map{ $0.principle }.reduce(0, { $0 + $1 })
        }
        
        if let loanBSchedule = loanBSchedule {
            loanBAmountFinanced = loanBSchedule.map{ $0.principle }.reduce(0, { $0 + $1 })
        }
        
        viewModel.firstRingName = loanController.loans.first?.name ?? ""
        viewModel.firstRingMaxValue = loanAAmountFinanced
        
        viewModel.secondRingName = loanController.loans.element(atIndex: 1)?.name ?? ""
        viewModel.secondRingMaxValue = loanBAmountFinanced
        
        updateYear(animated: false)
    }
    
    private func updateYear(animated: Bool) {
        viewModel.shouldAnimate = animated
        
        var loanAPrinciplePaid = 0.0
        var loanBPrinciplePaid = 0.0
        
        if let loanASchedule = loanASchedule {
            let year = min(yearIndex, loanASchedule.count - 1)
            let scheduleToYear = loanASchedule[0...year]
            loanAPrinciplePaid = scheduleToYear.map{ $0.principle }.reduce(0, { $0 + $1 })
        }
        
        if let loanBSchedule = loanBSchedule {
            let year = min(yearIndex, loanBSchedule.count - 1)
            let scheduleToYear = loanBSchedule[0...year]
            loanBPrinciplePaid = scheduleToYear.map{ $0.principle }.reduce(0, { $0 + $1 })
        }
        
        viewModel.firstRingValue = loanAPrinciplePaid
        viewModel.secondRingValue = loanBPrinciplePaid
    }
}


