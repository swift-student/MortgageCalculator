//
//  LoanController.swift
//  MortgageCalculator
//
//  Created by Shawn Gee on 3/2/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation

class LoanController {
    
    init() {
        loadFromPersistentStore()
    }
    
    
    //MARK: - CRUD

    private(set) var loans = [Loan]()
    
    func add(loan: Loan) {
        loans.append(loan)
        saveToPersistentStore()
    }
    
    func update(loan: Loan) {
        guard let index = loans.firstIndex(of: loan) else { return }
        loans[index] = loan
        saveToPersistentStore()
    }
    
    
    //MARK: - Persistence
    
    private let fileName = "Loans.plist"
    
    private var loansURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsDirectory.appendingPathComponent(fileName)
    }
    
    private func saveToPersistentStore() {
        let encoder = PropertyListEncoder()
        
        do {
            let loansPlist = try encoder.encode(loans)
            try loansPlist.write(to: loansURL)
        } catch {
            print("Couldn't save loans to persistent store, error: \(error)")
        }
    }
    
    private func loadFromPersistentStore() {
        let decoder = PropertyListDecoder()
        
        do {
            let loansData = try Data(contentsOf: loansURL)
            loans = try decoder.decode([Loan].self, from: loansData)
        } catch {
            print("Couldn't load loans from persistent store, error: \(error)")
        }
    }
}

