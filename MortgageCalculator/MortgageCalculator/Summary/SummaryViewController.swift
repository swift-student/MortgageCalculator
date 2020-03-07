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
    @IBOutlet weak var copyLoanButtonContainer: UIView!
    @IBOutlet weak var addLoanButtonContainer: UIView!
    @IBOutlet weak var separatorView: UIView!
    
    
    //MARK: - IBActions
    
    @IBAction func copyLoanTapped(_ sender: UIButton) {
        copyLoan()
    }
    
    
    //MARK: - Properties
    
    var loanController: LoanController!
    
    
    //MARK: - Private
    
    func copyLoan() {
        guard let loan = loanController.loans.first else { return }
        
        let copyName = loan.name != "Loan B" ? "Loan B" : "Loan A"
        let loanCopy = Loan(name: copyName, purchasePrice: loan.purchasePrice, monthlyPayment: loan.monthlyPayment, downPayment: loan.downPayment, interestRate: loan.interestRate, term: loan.term)
        loanController.add(loan: loanCopy)
        tableView.insertRows(at: [IndexPath(row: loanController.loans.count - 1, section: 0)], with: .top)
    }
    
    
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
        copyLoanButtonContainer.isHidden = numRows != 1
        addLoanButtonContainer.isHidden = numRows > 1
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
            tableView.performBatchUpdates({
                self.loanController.delete(loan: loanController.loans[indexPath.row])
                self.tableView.deleteRows(at: [indexPath], with: .left)
            }, completion: { _ in
                self.tableView.reloadData()
            })
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
