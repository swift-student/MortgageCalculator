//
//  BarGraphView.swift
//  MortgageCalculator
//
//  Created by Shawn Gee on 3/4/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import SwiftUI

struct BarGraphView: View {
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("Interest")
                    .font(.system(size: 24, weight: .bold))
                    HStack {
                        Rectangle()
                            .scale(x: 1, y: 0.3, anchor: .bottom)
                            .padding(8)
                            .foregroundColor(Color.pink)
                        Rectangle()
                            .scale(x: 1, y: 0.37, anchor: .bottom)
                            .padding(8)
                            .foregroundColor(Color.blue)
                    }.padding(.horizontal, 8)
                    Text("$20,000").foregroundColor(.pink)
                    Text("$30,000").foregroundColor(.blue).padding(.top, 4)
                }
                VStack {
                    Text("Principle")
                    .font(.system(size: 24, weight: .bold))
                    HStack {
                        Rectangle().padding(8)
                        Rectangle().padding(8)
                    }.padding(.horizontal, 8)
                    Text("$20,000")
                    Text("$30,000")
                }
                VStack {
                    Text("Total")
                    .font(.system(size: 24, weight: .bold))
                    HStack {
                        Rectangle().padding(8)
                        Rectangle().padding(8)
                    }.padding(.horizontal, 8)
                    Text("$20,000")
                    Text("$30,000")
                }
            }.font(.system(size: 20, weight: .semibold))
            
            HStack {
                Circle()
                    .frame(width: 20, height: 20, alignment: .leading)
                Text("Loan A")
                    .font(.system(size: 20, weight: .semibold))
                Spacer()
            }.padding(.top, 12)
                .padding(.leading, 12)
                .foregroundColor(.pink)
            
            HStack {
                Circle()
                    .frame(width: 20, height: 20, alignment: .leading)
                Text("Loan B")
                    .font(.system(size: 20, weight: .semibold))
                Spacer()
            }.padding(.top, -8)
                .padding(.leading, 12)
                .foregroundColor(.blue)

        }.padding()
            .foregroundColor(.white)
    }
}

struct BarGraphView_Previews: PreviewProvider {
    
    static var previews: some View {
        BarGraphView()
            .previewLayout(.fixed(width: 400, height: 500))
    }
}
