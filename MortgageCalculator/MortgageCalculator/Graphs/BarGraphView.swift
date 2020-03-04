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
                BarGraphSection(
                    title: viewModel.sections[0].title,
                    firstValue: viewModel.sections[0].firstValue,
                    secondValue: viewModel.sections[0].secondValue,
                    maxValue: viewModel.sections[0].maxValue)
                if viewModel.sections.count > 1 {
                    BarGraphSection(
                        title: viewModel.sections[1].title,
                        firstValue: viewModel.sections[1].firstValue,
                        secondValue: viewModel.sections[1].secondValue,
                        maxValue: viewModel.sections[0].maxValue)
                }
                if viewModel.sections.count > 2 {
                    BarGraphSection(
                        title: viewModel.sections[2].title,
                        firstValue: viewModel.sections[2].firstValue,
                        secondValue: viewModel.sections[2].secondValue,
                        maxValue: viewModel.sections[0].maxValue)
                }
            }.font(.system(size: 20, weight: .semibold))
            
            // Legend
            HStack {
                Spacer()
                Circle()
                    .frame(width: 20, height: 20, alignment: .leading)
                    .foregroundColor(.firstColor)
                Text(viewModel.firstKeyName)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.firstColor)
                Spacer()
                Circle()
                    .frame(width: 20, height: 20, alignment: .leading)
                    .foregroundColor(.secondColor)
                Text(viewModel.secondKeyName)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.secondColor)
                Spacer()
            }.padding(.top, 12)
                .padding(.leading, 12)
            
        }.padding()
            .foregroundColor(.white)
    }
}

struct BarGraphSection: View {
    
    @State var title: String
    @State var firstValue: Double
    @State var secondValue: Double?
    @State var maxValue: Double
    
    var body: some View {
        VStack {
            // Title
            Text(title)
            .font(.system(size: 24, weight: .bold))
            
            // Bars
            HStack {
                Rectangle()
                    .scale(x: 1, y: CGFloat(firstValue / maxValue), anchor: .bottom)
                    .padding(8)
                    .foregroundColor(.firstColor)
                if secondValue != nil {
                    Rectangle()
                    .scale(x: 1, y: CGFloat(secondValue! / maxValue), anchor: .bottom)
                    .padding(8)
                    .foregroundColor(.secondColor)
                }
                
            }.padding(.horizontal, 8)
            
            // Labels
            Text(firstValue.currencyString ?? "")
                .fixedSize()
                .foregroundColor(.firstColor)
            if secondValue != nil {
                Text(secondValue!.currencyString ?? "")
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
