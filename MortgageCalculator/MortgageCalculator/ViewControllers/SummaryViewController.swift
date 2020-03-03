//
//  SummaryViewController.swift
//  MortgageCalculator
//
//  Created by Shawn Gee on 3/2/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let testLoan = Loan(purchasePrice: 200000, downPayment: 20000, interestRate: 5.0, term: 30)
        print(Calculator.monthlyAmortizationSchedule(forLoan: testLoan))
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
