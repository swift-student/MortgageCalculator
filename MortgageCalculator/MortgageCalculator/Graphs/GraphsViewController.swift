//
//  GraphsViewController.swift
//  MortgageCalculator
//
//  Created by Shawn Gee on 3/3/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

class GraphsViewController: UIViewController {
    @IBOutlet weak var graphCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        graphCollectionView.dataSource = self
        graphCollectionView.delegate = self
        graphCollectionView.register(BarGraphCollectionViewCell.self, forCellWithReuseIdentifier: "BarGraphCell")
    }
}

extension GraphsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(collectionView.frame.size)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BarGraphCell", for: indexPath)
        return cell
    }
    
    
}

extension GraphsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return graphCollectionView.frame.size
    }
}
