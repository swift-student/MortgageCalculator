//
//  BarGraphCollectionViewCell.swift
//  MortgageCalculator
//
//  Created by Shawn Gee on 3/3/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit
import SwiftUI

class BarGraphCollectionViewCell: UICollectionViewCell {
    
    lazy var barGraphView = BarGraphView()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        
        backgroundColor = .clear
        let hostingController = UIHostingController(rootView: barGraphView)
        addSubview(hostingController.view)
        hostingController.view.backgroundColor = .clear
        hostingController.view.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
