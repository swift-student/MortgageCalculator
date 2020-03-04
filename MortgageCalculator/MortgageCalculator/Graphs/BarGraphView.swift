//
//  BarGraphView.swift
//  MortgageCalculator
//
//  Created by Shawn Gee on 3/4/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import SwiftUI

class BarGraphViewModel: ObservableObject {
    
}

struct BarGraphView: View {
    @ObservedObject var viewModel: BarGraphViewModel
    @State var numSections = 2
    
    var body: some View {
        VStack {
            HStack {
                BarGraphSection(title: "Interest")
                BarGraphSection(title: "Principle")
                if numSections > 2 {
                    BarGraphSection(title: "Total")
                }
            }.font(.system(size: 20, weight: .semibold))
            
            HStack {
                Spacer()
                Circle()
                    .frame(width: 20, height: 20, alignment: .leading)
                    .foregroundColor(.firstColor)
                Text("Loan A")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.firstColor)
                Spacer()
                Circle()
                    .frame(width: 20, height: 20, alignment: .leading)
                    .foregroundColor(.secondColor)
                Text("Loan B")
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
    
    var body: some View {
        VStack {
            Text("Interest")
            .font(.system(size: 24, weight: .bold))
            HStack {
                Rectangle()
                    .scale(x: 1, y: 0.3, anchor: .bottom)
                    .padding(8)
                    .foregroundColor(.firstColor)
                Rectangle()
                    .scale(x: 1, y: 0.37, anchor: .bottom)
                    .padding(8)
                    .foregroundColor(.secondColor)
            }.padding(.horizontal, 8)
            Text("$20,000")
                .fixedSize()
                .foregroundColor(.firstColor)
            Text("$30,000")
                .fixedSize()
                .foregroundColor(.secondColor).padding(.top, 4)
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
