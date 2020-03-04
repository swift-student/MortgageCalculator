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
    @IBOutlet weak var graphCollectionView: UICollectionView!
    @IBOutlet weak var graphSelector: UISegmentedControl!
    
    
    //MARK: - IBActions
    @IBAction func selectedGraph(_ sender: UISegmentedControl) {
        scrollTo(sender.selectedSegmentIndex)
    }
    
    
    //MARK: Private
    
    private func scrollTo(_ index: Int) {
        graphCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        graphCollectionView.dataSource = self
        graphCollectionView.delegate = self
        graphCollectionView.register(BarGraphCollectionViewCell.self, forCellWithReuseIdentifier: "BarGraphCell")
        
        guard let timelineController = children.first as? TimelineViewController else  {
          fatalError("Check storyboard for missing TimelineViewController")
        }
        
        timelineController.delegate = self
    }
}


//MARK: - Collection View Data Source

extension GraphsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(collectionView.frame.size)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BarGraphCell", for: indexPath)
        return cell
    }
    
    
}

//MARK: - Flow Layout Delegate

extension GraphsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return graphCollectionView.frame.size
    }
}


//MARK: - Timeline Delegate

extension GraphsViewController: TimelineDelegate {
    func timelineDidSelectYear(atIndex index: Int) {
        // Update each graph with data for selected year
        print("Timeline selected year at index: \(index)")
    }
}
