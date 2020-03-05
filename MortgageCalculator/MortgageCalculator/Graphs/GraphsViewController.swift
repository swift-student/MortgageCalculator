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
    @IBOutlet weak var graphScrollContentView: UIView!
    @IBOutlet weak var graphScrollContentWidth: NSLayoutConstraint!
    
    @IBOutlet weak var graphSelector: UISegmentedControl!

    
    //MARK: - IBActions
    @IBAction func selectedGraph(_ sender: UISegmentedControl) {
        scrollTo(sender.selectedSegmentIndex)
    }
    
    
    //MARK: - Properties
    
    var loanController: LoanController!
    
    
    //MARK: - Private
    
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
    
    private func updateGraphs(animated: Bool) {
        updateTotalsGraph(animated: animated)
        updateYearlyGraph(animated: animated)
    }
    
    private func updateTotalsGraph(animated: Bool) {
        var loanATotalInterest = 0.0
        var loanBTotalInterest = 0.0
        
        var loanATotalPrinciple = 0.0
        var loanBTotalPrinciple = 0.0
        
        var loanABalance = 0.0
        var loanBBalance = 0.0
        
        // Get maxValue for scale
        // This should be calculated by taking the max of the total interest, and amount financed from each loan
        var loanAMax = 0.01
        var loanBMax = 0.01
        
        if let loanASchedule = loanASchedule {
            let loanAInterestMax = loanASchedule.map{ $0.interest }.reduce(0, { $0 + $1 })
            let loanAPrincipleMax = loanASchedule.map{ $0.principle }.reduce(0, { $0 + $1 })
            loanAMax = max(loanAInterestMax, loanAPrincipleMax)
            
            let year = min(yearIndex, loanASchedule.count - 1)
            let scheduleToYear = loanASchedule[0...year]
            
            loanATotalInterest = scheduleToYear.map{ $0.interest }.reduce(0, { $0 + $1 })
            loanATotalPrinciple = scheduleToYear.map{ $0.principle }.reduce(0, { $0 + $1 })
            loanABalance = scheduleToYear[year].balance
        }
        
        if let loanBSchedule = loanBSchedule {
            let loanBInterestMax = loanBSchedule.map{ $0.interest }.reduce(0, { $0 + $1 })
            let loanBPrincipleMax = loanBSchedule.map{ $0.principle }.reduce(0, { $0 + $1 })
            loanBMax = max(loanBInterestMax, loanBPrincipleMax)
            
            let year = min(yearIndex, loanBSchedule.count - 1)
            let scheduleToYear = loanBSchedule[0...year]
            
            loanBTotalInterest = scheduleToYear.map{ $0.interest }.reduce(0, { $0 + $1 })
            loanBTotalPrinciple = scheduleToYear.map{ $0.principle }.reduce(0, { $0 + $1 })
            loanBBalance = scheduleToYear[year].balance
        }
        
        let vm = totalsBarGraph.viewModel
        
        vm.shouldAnimate = animated
        
        vm.maxValue = max(loanAMax, loanBMax)
        
        vm.numValues = loanController.loans.count
        
        vm.sectionOneTitle = "Interest"
        vm.sectionOneFirstValue = loanATotalInterest
        vm.sectionOneSecondValue = loanBTotalInterest
        
        vm.sectionTwoTitle = "Principle"
        vm.sectionTwoFirstValue = loanATotalPrinciple
        vm.sectionTwoSecondValue = loanBTotalPrinciple
        
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
    
    func updateSchedules() {
        if let loanA = loanController.loans.first {
            loanASchedule = Calculator.yearlyAmortizationSchedule(forLoan: loanA)
        } else {
            loanASchedule = nil
            /// We don't have any loans to display
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
        
        guard let timelineVC = children.first as? TimelineViewController else  {
          fatalError("Check storyboard for missing TimelineViewController")
        }
        
        timelineVC.delegate = self
        
        graphScrollView.delegate = self
        
        graphScrollContentView.addSubview(totalsBarGraph)
        graphScrollContentView.addSubview(yearlyBarGraph)
        graphScrollContentView.addSubview(progressRingGraph)
        graphSelector.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)
        graphSelector.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        
//        updateSchedules()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let timelineVC = children.first as? TimelineViewController else  {
          fatalError("Check storyboard for missing TimelineViewController")
        }
        
        timelineVC.numYears = loanController.loans.map{ $0.term }.reduce(1, { max($0, $1) })
        
        yearlyBarGraph.viewModel.shouldAnimate = false
        updateSchedules()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        graphScrollContentWidth.constant = graphScrollView.frame.width * 3
        totalsBarGraph.frame = CGRect(origin: graphScrollContentView.bounds.origin, size: graphScrollView.frame.size)
        yearlyBarGraph.frame = CGRect(origin: CGPoint(x: totalsBarGraph.frame.maxX, y: totalsBarGraph.frame.minY), size: graphScrollView.frame.size)
        progressRingGraph.frame = CGRect(origin: CGPoint(x: yearlyBarGraph.frame.maxX, y: totalsBarGraph.frame.minY), size: graphScrollView.frame.size)
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


extension Array {
    func element(atIndex index: Int) -> Element? {
        return count > index ? self[index] : nil
    }
}
