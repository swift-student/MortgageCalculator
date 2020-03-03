//
//  SummaryViewController.swift
//  MortgageCalculator
//
//  Created by Shawn Gee on 3/2/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController {
    
    let loanController = LoanController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let testLoan = Loan(purchasePrice: 200000, downPayment: 20000, interestRate: 5.0, term: 30)
        print(Calculator.monthlyAmortizationSchedule(forLoan: testLoan))
    }
    
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddLoan",
           let loanDetailVC = segue.destination as? LoanDetailViewController {
            loanDetailVC.loanController = loanController
            if loanController.loans.count > 0 {
                loanDetailVC.loan = loanController.loans[0]
            }
        }
    }
    
}
