//
//  GraphsViewController.swift
//  MortgageCalculator
//
//  Created by Shawn Gee on 3/3/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

class GraphsViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var graphScrollView: UIScrollView!
    @IBOutlet weak var graphStackView: UIStackView!

    
    @IBOutlet weak var noLoansLabel: UILabel!
    @IBOutlet weak var graphSelector: UISegmentedControl!

    
    //MARK: - IBActions
    @IBAction func selectedGraph(_ sender: UISegmentedControl) {
        scrollTo(sender.selectedSegmentIndex)
    }
    
    
    //MARK: - Properties
    
    var loanController: LoanController!
    
    
    //MARK: - Private
    
    private var timelineVC: TimelineViewController {
        guard let timelineVC = children.first as? TimelineViewController else  {
          fatalError("Check storyboard for missing TimelineViewController")
        }
        return timelineVC
    }
    
    private var loanASchedule: AmortizationSchedule?
    private var loanBSchedule: AmortizationSchedule?
    
    private var yearIndex = 0
    
    private var totalsBarGraph = BarGraphContainerView()
    private var yearlyBarGraph = BarGraphContainerView()
    private var progressRingGraph = RingGraphContainerView()
    
    private func scrollTo(_ index: Int) {
        let xOffset = CGFloat(index) * graphScrollView.frame.width
        graphScrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
    }
    
    
    //MARK: - Updates
    
    private func updateGraphs(animated: Bool) {
        updateTotalsGraph(animated: animated)
        updateYearlyGraph(animated: animated)
        updateProgressRingGraph(animated: animated)
    }
    
    private func updateTotalsGraph(animated: Bool) {
        var loanAInterestPaid = 0.0
        var loanBInterestPaid = 0.0
        
        var loanAPrinciplePaid = 0.0
        var loanBPrinciplePaid = 0.0
        
        var loanABalance = 0.0
        var loanBBalance = 0.0
        
        var loanAMax = 0.01
        var loanBMax = 0.01
        
        if let loanASchedule = loanASchedule {
            // Calculate max for scale
            let loanATotalInterest = loanASchedule.map{ $0.interest }.reduce(0, { $0 + $1 })
            let loanATotalPrinciple = loanASchedule.map{ $0.principle }.reduce(0, { $0 + $1 })
            loanAMax = max(loanATotalInterest, loanATotalPrinciple)
            
            // Get loan schedule up to current year
            let year = min(yearIndex, loanASchedule.count - 1)
            let scheduleToYear = loanASchedule[0...year]
            
            // Add up principle and interest paid
            loanAInterestPaid = scheduleToYear.map{ $0.interest }.reduce(0, { $0 + $1 })
            loanAPrinciplePaid = scheduleToYear.map{ $0.principle }.reduce(0, { $0 + $1 })
            loanABalance = scheduleToYear[year].balance
        }
        
        if let loanBSchedule = loanBSchedule {
            let loanBTotalInterest = loanBSchedule.map{ $0.interest }.reduce(0, { $0 + $1 })
            let loanBTotatlPrinciple = loanBSchedule.map{ $0.principle }.reduce(0, { $0 + $1 })
            loanBMax = max(loanBTotalInterest, loanBTotatlPrinciple)
            
            let year = min(yearIndex, loanBSchedule.count - 1)
            let scheduleToYear = loanBSchedule[0...year]
            
            loanBInterestPaid = scheduleToYear.map{ $0.interest }.reduce(0, { $0 + $1 })
            loanBPrinciplePaid = scheduleToYear.map{ $0.principle }.reduce(0, { $0 + $1 })
            loanBBalance = scheduleToYear[year].balance
        }
        
        let vm = totalsBarGraph.viewModel
        
        vm.shouldAnimate = animated
        
        vm.maxValue = max(loanAMax, loanBMax)
        
        vm.numValues = loanController.loans.count
        
        vm.sectionOneTitle = "Interest"
        vm.sectionOneFirstValue = loanAInterestPaid
        vm.sectionOneSecondValue = loanBInterestPaid
        
        vm.sectionTwoTitle = "Principle"
        vm.sectionTwoFirstValue = loanAPrinciplePaid
        vm.sectionTwoSecondValue = loanBPrinciplePaid
        
        vm.sectionThreeTitle = "Balance"
        vm.sectionThreeFirstValue = loanABalance
        vm.sectionThreeSecondValue = loanBBalance
        
        vm.firstKeyName = loanController.loans.first?.name ?? ""
        vm.secondKeyName = loanController.loans.element(atIndex: 1)?.name ?? ""
    }
    
    private func updateYearlyGraph(animated: Bool) {
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
        
        let vm = yearlyBarGraph.viewModel
        
        vm.shouldAnimate = animated
        
        vm.maxValue = loanController.loans
            .map{ Calculator.monthlyPayment(forLoan: $0 ) * 12 }
            .reduce( 0.01 , { max($0, $1) })
        
        vm.numValues = loanController.loans.count
        
        vm.sectionOneTitle = "Interest"
        vm.sectionOneFirstValue = loanAData.interest
        vm.sectionOneSecondValue = loanBData.interest
        
        vm.sectionTwoTitle = "Principle"
        vm.sectionTwoFirstValue = loanAData.principle
        vm.sectionTwoSecondValue = loanBData.principle
        
        vm.firstKeyName = loanController.loans.first?.name ?? ""
        vm.secondKeyName = loanController.loans.element(atIndex: 1)?.name ?? ""
    }
    
    func updateProgressRingGraph(animated: Bool) {
        var loanAAmountFinanced = 0.1
        var loanBAmountFinanced = 0.1
        
        var loanAPrinciplePaid = 0.0
        var loanBPrinciplePaid = 0.0
        
        if let loanASchedule = loanASchedule {
            loanAAmountFinanced = loanASchedule.map{ $0.principle }.reduce(0, { $0 + $1 })
            
            let year = min(yearIndex, loanASchedule.count - 1)
            let scheduleToYear = loanASchedule[0...year]
            loanAPrinciplePaid = scheduleToYear.map{ $0.principle }.reduce(0, { $0 + $1 })
        }
        
        if let loanBSchedule = loanBSchedule {
            loanBAmountFinanced = loanBSchedule.map{ $0.principle }.reduce(0, { $0 + $1 })
            
            let year = min(yearIndex, loanBSchedule.count - 1)
            let scheduleToYear = loanBSchedule[0...year]
            loanBPrinciplePaid = scheduleToYear.map{ $0.principle }.reduce(0, { $0 + $1 })
        }
        
        let vm = progressRingGraph.viewModel
        
        vm.shouldAnimate = animated
        
        vm.firstRingName = loanController.loans.first?.name ?? ""
        vm.firstRingValue = loanAPrinciplePaid
        vm.firstRingMaxValue = loanAAmountFinanced
        
        vm.secondRingName = loanController.loans.element(atIndex: 1)?.name ?? ""
        vm.secondRingValue = loanBPrinciplePaid
        vm.secondRingMaxValue = loanBAmountFinanced
    }
    
    func updateLoanSchedules() {
        if let loanA = loanController.loans.first {
            loanASchedule = Calculator.yearlyAmortizationSchedule(forLoan: loanA)
            noLoansLabel.isHidden = true
            graphScrollView.isHidden = false
        } else {
            loanASchedule = nil
            noLoansLabel.isHidden = false
            graphScrollView.isHidden = true
        }
        if let loanB = loanController.loans.element(atIndex: 1) {
            loanBSchedule = Calculator.yearlyAmortizationSchedule(forLoan: loanB)
        } else {
            loanBSchedule = nil
        }
        
        updateGraphs(animated: false)
    }
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timelineVC.delegate = self
        
        setupGraphScrollView()
        setupGraphSelector()
    }
    
    func setupGraphScrollView() {
        graphScrollView.delegate = self
        
        graphStackView.addArrangedSubview(totalsBarGraph)
        graphStackView.addArrangedSubview(yearlyBarGraph)
        graphStackView.addArrangedSubview(progressRingGraph)
    }
    
    func setupGraphSelector() {
        graphSelector.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)
        graphSelector.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        timelineVC.numYears = loanController.loans.map{ $0.term }.reduce(1, { max($0, $1) })
        updateLoanSchedules()
    }
}


//MARK: - Scroll View Delegate

extension GraphsViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        graphSelector.selectedSegmentIndex = Int(targetContentOffset.pointee.x / graphScrollView.frame.width)
    }
}


//MARK: - Timeline Delegate

extension GraphsViewController: TimelineDelegate {
    func timelineDidSelectYear(atIndex index: Int) {
        yearIndex = index
        updateGraphs(animated: true)
    }
}
