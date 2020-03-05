//
//  RingGraphView.swift
//  MortgageCalculator
//
//  Created by Shawn Gee on 3/5/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import SwiftUI

class RingGraphViewModel: ObservableObject {
    @Published var title = "Principle"
    
    @Published var firstRingName = "Loan A"
    @Published var firstRingValue: Double = 100 {
        didSet {
            firstRingProgress = CGFloat(firstRingValue / firstRingMaxValue)
        }
    }
    @Published var firstRingMaxValue: Double = 1000 {
        didSet {
            firstRingProgress = CGFloat(firstRingValue / firstRingMaxValue)
        }
    }
    
    @Published var firstRingProgress: CGFloat = 0.0
    
    
    @Published var secondRingName = "Loan B"
    @Published var secondRingValue: Double = 100 {
        didSet {
            secondRingProgress = CGFloat(secondRingValue / secondRingMaxValue)
        }
    }
    @Published var secondRingMaxValue: Double = 1000 {
        didSet {
            secondRingProgress = CGFloat(secondRingValue / secondRingMaxValue)
        }
    }
    
    @Published var secondRingProgress: CGFloat = 0.0

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
                
                if viewModel.firstRingName != "" {
                    VStack {
                        Text(viewModel.firstRingName)
                            .foregroundColor(.pink)
                            .font(.system(size: 24, weight: .bold))
                        Ring(startColor: Color(#colorLiteral(red: 0.8684985017, green: 0.6158105232, blue: 1, alpha: 1)),
                             endColor: Color(.systemPink),
                             progress: $viewModel.firstRingProgress)
                            .padding()
                        Text("\(viewModel.firstRingValue.currencyString ?? "") / \(viewModel.firstRingMaxValue.currencyString ?? "")")
                            .font(.system(size: 12, weight: .bold))
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
                             progress: $viewModel.secondRingProgress)
                            .padding()
                        Text("\(viewModel.secondRingValue.currencyString ?? "") / \(viewModel.secondRingMaxValue.currencyString ?? "")")
                            .font(.system(size: 12, weight: .bold))
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
                            endColor,
                        ]),
                        center: .center,
                        angle: Angle(degrees: -8)),
                    style: .init(lineWidth: 15, lineCap: .round)
                )
                .rotationEffect(Angle(degrees: -85))
                .shadow(color: endColor.opacity(0.3), radius: 3, x: -3, y: 3)
                .animation(.easeOut(duration: 0.8))
                
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
