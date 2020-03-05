//
//  RingGraphContainerView.swift
//  MortgageCalculator
//
//  Created by Shawn Gee on 3/5/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation

import UIKit
import SwiftUI

class RingGraphContainerView: UIView {
    
    let viewModel = RingGraphViewModel()
    
    private lazy var ringGraphView = RingGraphView(viewModel: viewModel)
    
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        
        backgroundColor = .clear
        
        let hostingController = UIHostingController(rootView: ringGraphView)
        
        addSubview(hostingController.view)
        hostingController.view.backgroundColor = .clear
        hostingController.view.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
