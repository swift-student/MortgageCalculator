//
//  TimelineViewController.swift
//  MortgageCalculator
//
//  Created by Shawn Gee on 3/4/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {
    
    @IBOutlet weak var timelineView: UICollectionView!
    
    
    let years: [String] = {
        var years = [String]()
        for year in 2020...2050 {
            years.append(String(year))
        }
        return years
    }()
    
    private var horizontalSectionInset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let flowLayout = timelineView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        timelineView.dataSource = self
        timelineView.delegate = self
        
        horizontalSectionInset = timelineView.frame.width / 2 - flowLayout.itemSize.width / 2
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: horizontalSectionInset, bottom: 0, right: horizontalSectionInset)
    }
    
}

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

extension TimelineViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var point = scrollView.contentOffset
        point.x += horizontalSectionInset + 50
        
        if let currentYear = timelineView.indexPathForItem(at: point) {
            print(years[currentYear.item])
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let idealHorizontalOffset = (targetContentOffset.pointee.x / 100).rounded() * 100
        targetContentOffset.pointee = CGPoint(x: idealHorizontalOffset, y: 0)
    }
}
