//
//  BarGraphSection.swift
//  MortgageCalculator
//
//  Created by Shawn Gee on 3/7/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import SwiftUI

struct BarGraphSection: View {
    
    @Binding var title: String
    @Binding var firstValue: Double
    @Binding var secondValue: Double
    @Binding var maxValue: Double
    @Binding var numValues: Int
    
    @Binding var shouldAnimate: Bool
    
    var body: some View {
        VStack {
            
            
            //MARK: - Title
            
            Text(title)
                .font(.system(size: 24, weight: .bold))
                .frame(maxWidth: .infinity)
            
            
            //MARK: - Bars
            
            HStack {
                if numValues > 0 {
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color.black.opacity(0.3))
                            .cornerRadius(4.0)
                        
                        Rectangle()
                        .cornerRadius(4.0)
                        .scaleEffect(x: 1, y: CGFloat(firstValue / maxValue), anchor: .bottom)
                        .cornerRadius(4.0)
                        .foregroundColor(.firstColor)
                            .animation(shouldAnimate ? .easeInOut(duration: 0.8) : .none)
                            .shadow(color: Color.firstColor.opacity(0.3), radius: 3, x: -3, y: 3)
                        
                    }.frame(maxWidth: 40)
                        .padding(8)
                }
                
                if numValues > 1 {
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color.black.opacity(0.3))
                            .cornerRadius(4.0)
                        Rectangle()
                            .cornerRadius(4.0)
                            .scaleEffect(x: 1, y: CGFloat(secondValue / maxValue), anchor: .bottom)
                            .cornerRadius(4.0)
                            .foregroundColor(.secondColor)
                            .animation(shouldAnimate ? .easeInOut(duration: 0.8) : .none)
                            .shadow(color: Color.secondColor.opacity(0.3), radius: 3, x: -3, y: 3)
                        
                    }.frame(maxWidth: 40)
                        .padding(8)
                }
                
            }.padding(.horizontal, 8)
            
            
            //MARK: - Labels
            
            if numValues > 0 {
                Text(firstValue.currencyString ?? "")
                .frame(maxWidth: .infinity)
                .foregroundColor(.firstColor)
            }
            
            
            if numValues > 1 {
                Text(secondValue.currencyString ?? "")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.secondColor).padding(.top, 4)
            }
        }
    }
}
