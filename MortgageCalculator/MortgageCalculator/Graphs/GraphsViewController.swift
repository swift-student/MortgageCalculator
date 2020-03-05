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
        
        
        vm.maxValue = loanController.loans
            .map{ Calculator.monthlyPayment(forLoan: $0 ) * 12 }
            .reduce( 0.01 , { max($0, $1) })
        
        vm.numSections = 2
        
        vm.sectionOneTitle = "Interest"
        vm.sectionOneFirstValue = loanAData.interest
        vm.sectionOneSecondValue = loanBData.interest
        
        vm.sectionTwoTitle = "Principle"
        vm.sectionTwoFirstValue = loanAData.principle
        vm.sectionTwoSecondValue = loanBData.principle
    }
    
    func updateViews() {
        if let loanA = loanController.loans.first {
            loanASchedule = Calculator.yearlyAmortizationSchedule(forLoan: loanA)
        } else {
            /// We don't have any loans to display
        }
        if loanController.loans.count > 1, let loanB = loanController.loans.last {
            loanBSchedule = Calculator.yearlyAmortizationSchedule(forLoan: loanB)
        } else {
            loanBSchedule = nil
        }
        
        updateYearlyGraph()
        updateTotalsGraph()
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
        
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        yearlyBarGraph.viewModel.shouldAnimate = false
        updateViews()
    }
}


//MARK: - Timeline Delegate

extension GraphsViewController: TimelineDelegate {
    func timelineDidSelectYear(atIndex index: Int) {
        yearIndex = index
        yearlyBarGraph.viewModel.shouldAnimate = true
    }
}
