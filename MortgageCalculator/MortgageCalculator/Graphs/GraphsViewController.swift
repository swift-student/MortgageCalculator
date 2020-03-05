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
    
    private var yearIndex = 0 {
        didSet {
            updateTotalsGraph()
            updateYearlyGraph()
        }
    }
    
    private var totalsBarGraph = BarGraphContainerView()
    
    private var yearlyBarGraph = BarGraphContainerView()
    
    private func scrollTo(_ index: Int) {
//        graphCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    private func updateTotalsGraph() {
        
    }
    
    private func updateYearlyGraph() {
        guard let loanASchedule = loanASchedule else { return }
        let loanAData = loanASchedule[min(yearIndex, loanASchedule.count - 1)]
        var loanBData: AmortizationData?
        if let loanBSchedule = loanBSchedule {
            loanBData = loanBSchedule[min(yearIndex, loanBSchedule.count - 1)]
        }
        
        var maxValue = loanAData.interest + loanAData.principle
        if let loanBData = loanBData {
            maxValue = max(maxValue, loanBData.interest + loanBData.principle)
        }
        
        let vm = yearlyBarGraph.viewModel
        
        vm.maxValue = maxValue
        vm.numSections = 2
        
        vm.sectionOneTitle = "Interest"
        vm.sectionOneFirstValue = loanAData.interest
        vm.sectionOneSecondValue = loanBData?.interest ?? 400
        
        vm.sectionTwoTitle = "Principle"
        vm.sectionTwoFirstValue = loanAData.principle
        vm.sectionTwoSecondValue = loanBData?.principle
    }
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let timelineVC = children.first as? TimelineViewController else  {
          fatalError("Check storyboard for missing TimelineViewController")
        }
        
        timelineVC.delegate = self
        
        graphScrollContentView.addSubview(yearlyBarGraph)
        yearlyBarGraph.fillSuperview()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let loanA = loanController.loans.first {
            loanASchedule = Calculator.yearlyAmortizationSchedule(forLoan: loanA)
        } else {
            /// We don't have any loans to display
        }
        if loanController.loans.count > 1, let loanB = loanController.loans.last {
            loanBSchedule = Calculator.yearlyAmortizationSchedule(forLoan: loanB)
        }
        
        updateYearlyGraph()
        updateTotalsGraph()
    }
}


//MARK: - Timeline Delegate

extension GraphsViewController: TimelineDelegate {
    func timelineDidSelectYear(atIndex index: Int) {
        yearIndex = index
    }
}
