//
//  SummaryViewController.swift
//  MortgageCalculator
//
//  Created by Shawn Gee on 3/2/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noLoansLabel: UILabel!
    @IBOutlet weak var addLoanButton: UIButton!
    @IBOutlet weak var addLoanLabel: UILabel!
    let loanController = LoanController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        let testLoan = Loan(purchasePrice: 200000, downPayment: 20000, interestRate: 5.0, term: 30)
        print(Calculator.monthlyAmortizationSchedule(forLoan: testLoan))
    }
    
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddLoan",
           let loanDetailVC = segue.destination as? LoanDetailViewController {
            loanDetailVC.loanController = loanController
            loanDetailVC.delegate = self
        }
    }
}


//MARK: - Table View Data Source

extension SummaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numRows =  loanController.loans.count
        
        noLoansLabel.isHidden = numRows > 0
        addLoanButton.isHidden = numRows > 1
        addLoanLabel.isHidden = numRows > 1
    
        return numRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LoanSummaryCell", for: indexPath) as? LoanSummaryTableViewCell else {
            fatalError("Unable to cast cell to type \(LoanSummaryTableViewCell.self)")
        }
        
        cell.loan = loanController.loans[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            loanController.delete(loan: loanController.loans[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .left)
        default:
            break
        }
    }
    
}


//MARK: - Table View Delegate

extension SummaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.frame.height / 2
    }
}

//MARK: - Loan Detail Delegate

extension SummaryViewController: LoanDetailDelegate {
    func didFinishEditing() {
        tableView.reloadData()
    }
}
