//
//  MortgageTabBarController.swift
//  MortgageCalculator
//
//  Created by Shawn Gee on 3/3/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

class MortgageTabBarController: UITabBarController {
    let loanController = LoanController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let summaryVC = children[0] as? SummaryViewController else  {
            fatalError("Check storyboard for missing SummaryViewController")
        }
        guard let graphsVC = children[1] as? GraphsViewController else  {
            fatalError("Check storyboard for missing GraphsViewController")
        }
        
        summaryVC.loanController = loanController
        graphsVC.loanController = loanController
    }
}
