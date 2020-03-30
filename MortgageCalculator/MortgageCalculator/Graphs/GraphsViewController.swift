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
    
    private var loanASchedule: AmortizationSchedule? {
        didSet {
            yearlyBarGraphVC.loanASchedule = loanASchedule
            totalsBarGraphVC.loanASchedule = loanASchedule
            progressRingGraphVC.loanASchedule = loanASchedule
        }
    }
    
    private var loanBSchedule: AmortizationSchedule? {
        didSet {
            yearlyBarGraphVC.loanBSchedule = loanBSchedule
            totalsBarGraphVC.loanBSchedule = loanBSchedule
            progressRingGraphVC.loanBSchedule = loanBSchedule
        }
    }
    
    private var yearIndex = 0 {
        didSet {
            yearlyBarGraphVC.yearIndex = yearIndex
            totalsBarGraphVC.yearIndex = yearIndex
            progressRingGraphVC.yearIndex = yearIndex
        }
    }
    
    private var yearlyBarGraphVC = YearlyBarGraphViewController()
    private var totalsBarGraphVC = TotalsBarGraphViewController()
    private var progressRingGraphVC = ProgressRingGraphViewController()
    
    private func scrollTo(_ index: Int) {
        let xOffset = CGFloat(index) * graphScrollView.frame.width
        graphScrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
    }
    
    
    //MARK: - Updates
    
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
        
        totalsBarGraphVC.loanController = loanController
        yearlyBarGraphVC.loanController = loanController
        progressRingGraphVC.loanController = loanController
        
        addChild(totalsBarGraphVC)
        graphStackView.addArrangedSubview(totalsBarGraphVC.view)
        totalsBarGraphVC.didMove(toParent: self)
        
        addChild(yearlyBarGraphVC)
        graphStackView.addArrangedSubview(yearlyBarGraphVC.view)
        yearlyBarGraphVC.didMove(toParent: self)
        
        addChild(progressRingGraphVC)
        graphStackView.addArrangedSubview(progressRingGraphVC.view)
        progressRingGraphVC.didMove(toParent: self)
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
    }
}
