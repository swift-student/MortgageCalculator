//
//  SummaryViewController.swift
//  MortgageCalculator
//
//  Created by Shawn Gee on 3/2/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noLoansLabel: UILabel!
    @IBOutlet weak var addLoanButton: UIButton!
    @IBOutlet weak var addLoanLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    
    //MARK: - Properties
    
    var loanController: LoanController!
    
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let loanDetailVC = segue.destination as? LoanDetailViewController {
            loanDetailVC.loanController = loanController
            loanDetailVC.delegate = self
            
            if segue.identifier == "EditLoan" {
                guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
                loanDetailVC.loan = loanController.loans[selectedIndexPath.row]
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
            
            if segue.identifier == "AddLoan" {
                if loanController.loans.count == 1 {
                    let firstLoanName = loanController.loans[0].name
                    loanDetailVC.defaultLoanName = firstLoanName != "Loan B" ? "Loan B" : "Loan A"
                }
            }
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
        separatorView.isHidden = numRows < 2
        
        return numRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LoanSummaryCell", for: indexPath) as? LoanSummaryTableViewCell else {
            fatalError("Unable to cast cell to type \(LoanSummaryTableViewCell.self)")
        }
        
        cell.loan = loanController.loans[indexPath.row]
        cell.color = indexPath.row == 0 ? .systemPink : .systemBlue
        
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
