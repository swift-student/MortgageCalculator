//
//  RingGraphView.swift
//  MortgageCalculator
//
//  Created by Shawn Gee on 3/5/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import SwiftUI



struct RingGraphView: View {
    @ObservedObject var viewModel: RingGraphViewModel
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            Text("Principle")
                .font(.system(size: 32, weight: .bold))
                .padding(.bottom, 60)
            
            HStack {
                
                Spacer()
                
                if viewModel.firstRingName != "" {
                    VStack {
                        Text(viewModel.firstRingName)
                            .foregroundColor(.pink)
                            .font(.system(size: 24, weight: .bold))
                            .frame(maxWidth: .infinity)
                        Ring(startColor: Color(#colorLiteral(red: 0.8684985017, green: 0.6158105232, blue: 1, alpha: 1)),
                             endColor: .firstColor,
                             progress: $viewModel.firstRingProgress,
                             shouldAnimate: $viewModel.shouldAnimate)
                            .padding()
                        Text("\(viewModel.firstRingValue.currencyString ?? "") / \(viewModel.firstRingMaxValue.currencyString ?? "")")
                            .font(.system(size: 14, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.top, 10)
                    }.frame(maxWidth: .infinity)
                }
                
                if viewModel.secondRingName != "" {
                    VStack {
                        Text(viewModel.secondRingName)
                            .foregroundColor(.blue)
                            .font(.system(size: 24, weight: .bold))
                            .frame(maxWidth: .infinity)
                        Ring(startColor: Color(#colorLiteral(red: 0.7489833048, green: 1, blue: 1, alpha: 1)),
                             endColor: .secondColor,
                             progress: $viewModel.secondRingProgress,
                             shouldAnimate: $viewModel.shouldAnimate)
                            .padding()
                        Text("\(viewModel.secondRingValue.currencyString ?? "") / \(viewModel.secondRingMaxValue.currencyString ?? "")")
                            .font(.system(size: 14, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.top, 10)
                    }.frame(maxWidth: .infinity)
                }
            
                Spacer()
            }
            
            Spacer()
        }.foregroundColor(.white)
    }
}



