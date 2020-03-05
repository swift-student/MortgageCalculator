//
//  RingGraphView.swift
//  MortgageCalculator
//
//  Created by Shawn Gee on 3/5/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import SwiftUI

class RingGraphViewModel: ObservableObject {
    
}

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
                
                VStack {
                    Text("Loan A")
                        .foregroundColor(.pink)
                        .font(.system(size: 24, weight: .bold))
                    Ring(startColor: Color(#colorLiteral(red: 0.8684985017, green: 0.6158105232, blue: 1, alpha: 1)), endColor: Color(.systemPink), progress: 1)
                        .padding()
                    Text("$100,000 / $100,000")
                        .font(.system(size: 12, weight: .bold))
                        .padding(.top, 10)
                }
                
                Spacer()
                
                VStack {
                    Text("Loan B")
                    .foregroundColor(.blue)
                    .font(.system(size: 24, weight: .bold))
                    Ring(startColor: Color(#colorLiteral(red: 0.7489833048, green: 1, blue: 1, alpha: 1)), endColor: Color(.systemBlue), progress: 0.87)
                        .padding()
                    Text("$87,000 / $100,000")
                    .font(.system(size: 12, weight: .bold))
                    .padding(.top, 10)
                }
            
                Spacer()
            }
            
            Spacer()
        }.foregroundColor(.white)
    }
}


//MARK: - Ring

struct Ring: View {
    @State var startColor: Color
    @State var endColor: Color
    @State var progress: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(.black), style: .init(lineWidth: 15))
            Circle()
                .trim(from: 0, to: progress < 1 ? progress * 0.95 : progress)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [
                            progress < 1 ? startColor : endColor,
                            endColor,
                        ]),
                        center: .center,
                        angle: Angle(degrees: -8)),
                    style: .init(lineWidth: 15, lineCap: .round)
                )
                
                .rotationEffect(Angle(degrees: -85))
                .shadow(color: endColor.opacity(0.3), radius: 3, x: -3, y: 3)
                
            Text(String(format: "%.0f", Double(progress * 100).rounded(.down)) + "%")
                .font(.system(size: 18, weight: .heavy))
        }.frame(width: 100, height: 100)
    }
}

struct RingGraphView_Previews: PreviewProvider {
    static var previews: some View {
        RingGraphView(viewModel: RingGraphViewModel())
            .previewLayout(.fixed(width: 400, height: 500))
            .background(Color(white: 0.1))
    }
}
