//
//  YearlyBarGraphViewController.swift
//  MortgageCalculator
//
//  Created by Shawn Gee on 3/8/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import SwiftUI

class YearlyBarGraphViewController: UIHostingController<BarGraphView> {
    
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
        
        viewModel.maxValue = loanController.loans
            .map{ Calculator.monthlyPayment(forLoan: $0 ) * 12 }
            .reduce( 0.01 , { max($0, $1) })
        
        viewModel.sectionOneTitle = "Interest"
        
        viewModel.sectionTwoTitle = "Principle"
        
        viewModel.firstKeyName = loanController.loans.first?.name ?? ""
        viewModel.secondKeyName = loanController.loans.element(atIndex: 1)?.name ?? ""
        
        updateYear(animated: false)
    }
    
    private func updateYear(animated: Bool) {
        viewModel.shouldAnimate = animated
        
        var loanAData = AmortizationData.empty
        var loanBData = AmortizationData.empty
        
        if let loanASchedule = loanASchedule,
            yearIndex < loanASchedule.count {
            loanAData = loanASchedule[yearIndex]
        }
        
        if let loanBSchedule = loanBSchedule,
            yearIndex < loanBSchedule.count {
            loanBData = loanBSchedule[min(yearIndex, loanBSchedule.count - 1)]
        }
        
        viewModel.sectionOneFirstValue = loanAData.interest
        viewModel.sectionOneSecondValue = loanBData.interest
        
        viewModel.sectionTwoFirstValue = loanAData.principle
        viewModel.sectionTwoSecondValue = loanBData.principle
    }
}
