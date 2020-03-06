//
//  Array+.swift
//  MortgageCalculator
//
//  Created by Shawn Gee on 3/5/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation

extension Array {
    func element(atIndex index: Int) -> Element? {
        return count > index ? self[index] : nil
    }
}
