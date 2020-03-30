//
//  Ring.swift
//  MortgageCalculator
//
//  Created by Shawn Gee on 3/7/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import SwiftUI

struct Ring: View {
    var startColor: Color
    var endColor: Color
    var progress: CGFloat
    var shouldAnimate: Bool
    
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
