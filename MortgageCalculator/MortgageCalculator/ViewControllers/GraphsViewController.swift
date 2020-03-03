//
//  GraphsViewController.swift
//  MortgageCalculator
//
//  Created by Shawn Gee on 3/3/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

class GraphsViewController: UIViewController {
    @IBOutlet weak var timelineView: UICollectionView!
    
    private var horizontalSectionInset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timelineView.dataSource = self
        timelineView.delegate = self
        
        if let flowLayout = timelineView.collectionViewLayout as? UICollectionViewFlowLayout {
            horizontalSectionInset = timelineView.frame.width / 2 - flowLayout.itemSize.width / 2
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: horizontalSectionInset, bottom: 0, right: horizontalSectionInset)
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    let years: [String] = {
        var years = [String]()
        for year in 2020...2050 {
            years.append(String(year))
        }
        return years
    }()
}

extension GraphsViewController: UICollectionViewDataSource {
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

extension GraphsViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var point = scrollView.contentOffset
        point.x += horizontalSectionInset + 50
        
        if let currentYear = timelineView.indexPathForItem(at: point) {
            print(years[currentYear.item])
        }
    }
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset)
//        let idealHorizontalOffset = (scrollView.contentOffset.x / 100).rounded() * 100
//        let idealOffset = CGPoint(x: idealHorizontalOffset, y: 0)
//        print(idealOffset)
//        scrollView.setContentOffset(idealOffset, animated: true)
//    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let idealHorizontalOffset = (targetContentOffset.pointee.x / 100).rounded() * 100
        targetContentOffset.pointee = CGPoint(x: idealHorizontalOffset, y: 0)
    }
}
