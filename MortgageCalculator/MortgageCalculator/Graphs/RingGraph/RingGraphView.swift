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
                        Ring(startColor: Color(#colorLiteral(red: 0.8684985017, green: 0.6158105232, blue: 1, alpha: 1)),
                             endColor: Color(.systemPink),
                             progress: $viewModel.firstRingProgress,
                             shouldAnimate: $viewModel.shouldAnimate)
                            .padding()
                        Text("\(viewModel.firstRingValue.currencyString ?? "") / \(viewModel.firstRingMaxValue.currencyString ?? "")")
                            .font(.system(size: 14, weight: .bold))
                            .fixedSize()
                            .padding(.top, 10)
                    }
                }
                
                if viewModel.secondRingName != "" {
                    Spacer()
                    
                    VStack {
                        Text(viewModel.secondRingName)
                            .foregroundColor(.blue)
                            .font(.system(size: 24, weight: .bold))
                        Ring(startColor: Color(#colorLiteral(red: 0.7489833048, green: 1, blue: 1, alpha: 1)),
                             endColor: Color(.systemBlue),
                             progress: $viewModel.secondRingProgress,
                             shouldAnimate: $viewModel.shouldAnimate)
                            .padding()
                        Text("\(viewModel.secondRingValue.currencyString ?? "") / \(viewModel.secondRingMaxValue.currencyString ?? "")")
                            .font(.system(size: 14, weight: .bold))
                            .fixedSize()
                            .padding(.top, 10)
                    }
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
    @Binding var progress: CGFloat
    @Binding var shouldAnimate: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.black.opacity(0.3), style: .init(lineWidth: 18))
            Circle()
                .trim(from: 0, to: progress < 1 ? progress * 0.95 : progress)
                .stroke(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            startColor,
                            endColor,
                        ]),
                        center: .center,
                        startRadius: 30,
                        endRadius: 55),
                    style: .init(lineWidth: 18, lineCap: .round)
                )
                .rotationEffect(Angle(degrees: -85))
                .shadow(color: endColor.opacity(0.3), radius: 3, x: -3, y: 3)
                .animation( shouldAnimate ? .easeOut(duration: 0.8) : .none)
                
            Text(String(format: "%.0f", Double(progress * 100).rounded(.down)) + "%")
                .font(.system(size: 18, weight: .heavy))
        }.frame(width: 120, height: 120)
    }
}

struct RingGraphView_Previews: PreviewProvider {
    static var previews: some View {
        RingGraphView(viewModel: RingGraphViewModel())
            .previewLayout(.fixed(width: 400, height: 500))
            .background(Color(white: 0.1))
    }
}
