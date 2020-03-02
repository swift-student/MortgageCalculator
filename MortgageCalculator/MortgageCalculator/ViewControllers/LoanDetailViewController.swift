//
//  LoanDetailViewController.swift
//  MortgageCalculator
//
//  Created by Shawn Gee on 3/2/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

class LoanDetailViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var priceOrPaymentSelector: UISegmentedControl!
    @IBOutlet weak var priceOrPaymentTextField: UITextField!
    @IBOutlet weak var downPaymentTextField: UITextField!
    @IBOutlet weak var interestRateTextField: UITextField!
    @IBOutlet weak var termSelector: UISegmentedControl!
    
    
    //MARK: - IBActions
    @IBAction func priceOrPaymentSelected(_ sender: UISegmentedControl) {
    }
    
    @IBAction func termSelected(_ sender: UISegmentedControl) {
    }
    
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
