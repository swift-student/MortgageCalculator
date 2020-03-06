//
//  TimelineViewController.swift
//  MortgageCalculator
//
//  Created by Shawn Gee on 3/4/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

protocol TimelineDelegate {
    func timelineDidSelectYear(atIndex index: Int)
}

class TimelineViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var timelineView: UICollectionView!
    
    
    //MARK: - Properties
    var delegate: TimelineDelegate?
    var startDate = Date() {
        didSet {
            updateYears()
        }
    }
    var numYears = 30 {
        didSet {
            updateYears()
        }
    }
    
    
    //MARK: - Private
    
    private var selectedIndex = 0
    
    private var horizontalSectionInset: CGFloat = 0
    private var cellSize = CGSize()
    
    private var years = [String]()
    
    private func updateYears() {
        years = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        
        let startYearString = dateFormatter.string(from: startDate)
        
        if let startYear = Int(startYearString) {
            for i in 0..<numYears {
                years.append(String(startYear + i))
            }
        }
        
        timelineView.reloadData()
    }
    
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateYears()
        
        timelineView.dataSource = self
        timelineView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let flowLayout = timelineView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        cellSize = flowLayout.itemSize
        horizontalSectionInset = timelineView.frame.width / 2 - cellSize.width / 2
        
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: horizontalSectionInset, bottom: 0, right: horizontalSectionInset)
    }
    
}


//MARK: - Collection View Data Source

extension TimelineViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        years.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YearCell", for: indexPath) as? YearCell else {
            fatalError("Unable to cast collection view cell as type \(YearCell.self)")
        }
        cell.yearLabel.text = years[indexPath.item]
        return cell
    }
}


//MARK: - Collection View Delegate

extension TimelineViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var point = scrollView.contentOffset
        point.x += horizontalSectionInset + cellSize.width / 2
        point.y += cellSize.height / 2
        
        if let indexPath = timelineView.indexPathForItem(at: point) {
            if indexPath.item != selectedIndex {
                selectedIndex = indexPath.item
                delegate?.timelineDidSelectYear(atIndex: selectedIndex)
            }
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let idealHorizontalOffset = (targetContentOffset.pointee.x / 100).rounded() * 100
        targetContentOffset.pointee = CGPoint(x: idealHorizontalOffset, y: 0)
    }
}
