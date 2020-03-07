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
            
            //MARK: - Sections
            
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
                        .frame(maxWidth: .infinity)
                }
                
                if viewModel.sectionTwoTitle != "" {
                    BarGraphSection(
                        title: $viewModel.sectionTwoTitle,
                        firstValue: $viewModel.sectionTwoFirstValue,
                        secondValue: $viewModel.sectionTwoSecondValue,
                        maxValue: $viewModel.maxValue,
                        numValues: $viewModel.numValues,
                        shouldAnimate: $viewModel.shouldAnimate)
                        .frame(maxWidth: .infinity)
                }
                
                if viewModel.sectionThreeTitle != "" {
                    BarGraphSection(
                        title: $viewModel.sectionThreeTitle,
                        firstValue: $viewModel.sectionThreeFirstValue,
                        secondValue: $viewModel.sectionThreeSecondValue,
                        maxValue: $viewModel.maxValue,
                        numValues: $viewModel.numValues,
                        shouldAnimate: $viewModel.shouldAnimate)
                        .frame(maxWidth: .infinity)
                }
                
                Spacer()
            }.font(.system(size: 20, weight: .semibold))
            
            
            //MARK: - Divider
            
            Divider()
                .background(LinearGradient(
                    gradient: Gradient(stops: [
                        Gradient.Stop.init(color: .clear, location: 0.0),
                        Gradient.Stop.init(color: .white, location: 0.1),
                        Gradient.Stop.init(color: .white, location: 0.9),
                        Gradient.Stop.init(color: .clear, location: 1.0),
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing))
            
            
            //MARK: - Legend
            
            HStack {
                Spacer()
                
                if viewModel.firstKeyName != "" {
                    Rectangle()
                        .frame(width: 20, height: 20, alignment: .leading)
                        .cornerRadius(4.0)
                        .foregroundColor(.firstColor)
                    Text(viewModel.firstKeyName)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.firstColor)
                    
                }
                
                if viewModel.secondKeyName != "" {
                    Spacer()
                    
                    Rectangle()
                        .frame(width: 20, height: 20, alignment: .leading)
                        .cornerRadius(4.0)
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


struct BarGraphView_Previews: PreviewProvider {
    
    static var previews: some View {
        BarGraphView(viewModel: BarGraphViewModel())
            .previewLayout(.fixed(width: 400, height: 500))
            .background(Color(white: 0.1))
    }
}
