//
//  BarGraphCollectionViewCell.swift
//  MortgageCalculator
//
//  Created by Shawn Gee on 3/3/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit
import SwiftUI

class BarGraphContainerView: UIView {
    
    let viewModel = BarGraphViewModel()
    
    private lazy var barGraphView = BarGraphView(viewModel: viewModel)
    
    var hostingController: UIHostingController<BarGraphView>?
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        
        backgroundColor = .clear
        hostingController = UIHostingController(rootView: barGraphView)
        
        guard let hostingController = hostingController else { return }
        addSubview(hostingController.view)
        hostingController.view.backgroundColor = .clear
        hostingController.view.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
