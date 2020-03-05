//
//  BarGraphView.swift
//  MortgageCalculator
//
//  Created by Shawn Gee on 3/4/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import SwiftUI

struct BarGraphView: View {
    @ObservedObject var viewModel: BarGraphViewModel
    
    var body: some View {
        VStack {
            
            // Sections
            HStack {
                Spacer()
                
                if viewModel.sectionOneTitle != "" {
                    BarGraphSection(
                        title: $viewModel.sectionOneTitle,
                        firstValue: $viewModel.sectionOneFirstValue,
                        secondValue: $viewModel.sectionOneSecondValue ,
                        maxValue: $viewModel.maxValue,
                        numValues: $viewModel.numValues,
                        shouldAnimate: $viewModel.shouldAnimate)
                }
                
                if viewModel.sectionTwoTitle != "" {
                    Spacer()
                    
                    BarGraphSection(
                        title: $viewModel.sectionTwoTitle,
                        firstValue: $viewModel.sectionTwoFirstValue,
                        secondValue: $viewModel.sectionTwoSecondValue,
                        maxValue: $viewModel.maxValue,
                        numValues: $viewModel.numValues,
                        shouldAnimate: $viewModel.shouldAnimate)
                }
                
                if viewModel.sectionThreeTitle != "" {
                    Spacer()
                    
                    BarGraphSection(
                        title: $viewModel.sectionThreeTitle,
                        firstValue: $viewModel.sectionThreeFirstValue,
                        secondValue: $viewModel.sectionThreeSecondValue,
                        maxValue: $viewModel.maxValue,
                        numValues: $viewModel.numValues,
                        shouldAnimate: $viewModel.shouldAnimate)
                }
                
                Spacer()
            }.font(.system(size: 20, weight: .semibold))
            
            // Legend
            HStack {
                Spacer()
                
                if viewModel.firstKeyName != "" {
                    Circle()
                        .frame(width: 20, height: 20, alignment: .leading)
                        .foregroundColor(.firstColor)
                    Text(viewModel.firstKeyName)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.firstColor)
                    
                }
                
                if viewModel.secondKeyName != "" {
                    Spacer()
                    
                    Circle()
                        .frame(width: 20, height: 20, alignment: .leading)
                        .foregroundColor(.secondColor)
                    Text(viewModel.secondKeyName)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.secondColor)
                }
                
                Spacer()
            }.padding(.top, 12)
                .padding(.leading, 12)
            
        }.padding()
            .foregroundColor(.white)
    }
}


//MARK: - Section

struct BarGraphSection: View {
    
    @Binding var title: String
    @Binding var firstValue: Double
    @Binding var secondValue: Double
    @Binding var maxValue: Double
    @Binding var numValues: Int
    
    @Binding var shouldAnimate: Bool
    
    var body: some View {
        VStack {
            // Title
            Text(title)
                .font(.system(size: 24, weight: .bold))
            
            // Bars
            HStack {
                Rectangle()
                    .scale(x: 1, y: CGFloat(firstValue / maxValue), anchor: .bottom)
                    .animation(shouldAnimate ? .easeInOut : .none)
                    .frame(maxWidth: 40)
                    .padding(8)
                    .foregroundColor(.firstColor)
                    
                    
                if numValues > 1 {
                    Rectangle()
                        .scale(x: 1, y: CGFloat(secondValue / maxValue), anchor: .bottom)
                        .animation(shouldAnimate ? .easeInOut : .none)
                        .frame(maxWidth: 40)
                        .padding(8)
                        .foregroundColor(.secondColor)
                }
                
            }.padding(.horizontal, 8)
            
            // Labels
            if numValues > 0 {
                Text(firstValue.currencyString ?? "")
                .fixedSize()
                .foregroundColor(.firstColor)
            }
            
            
            if numValues > 1 {
                Text(secondValue.currencyString ?? "")
                    .fixedSize()
                    .foregroundColor(.secondColor).padding(.top, 4)
            }
        }
    }
}

struct BarGraphView_Previews: PreviewProvider {
    
    static var previews: some View {
        BarGraphView(viewModel: BarGraphViewModel())
            .previewLayout(.fixed(width: 400, height: 500))
            .background(Color(white: 0.1))
    }
}


extension Color {
    static let firstColor = Color(UIColor.systemPink)
    static let secondColor = Color(UIColor.systemBlue)
}
