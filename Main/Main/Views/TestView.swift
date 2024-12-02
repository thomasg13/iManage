//
//  TestView.swift
//  Main
//
//  Created by Thomas Guo on 12/1/24.
//

import SwiftUI

struct TestView: View {
    @State private var progress: Double = 0.7

    var body: some View {
        VStack {
            CircularProgressBar(progress: progress, lineWidth: 15, barColor: .blue)
                .frame(width: 150, height: 150)
            
            Slider(value: $progress, in: 0...1)
                .padding()
        }
    }
}

struct CircularProgressBar: View {
    var progress: Double
    var lineWidth: CGFloat = 20
    var barColor: Color = .blue
    var backgroundColor: Color = .gray.opacity(0.2)
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .foregroundColor(backgroundColor)
            
            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .foregroundColor(barColor)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: progress)
            
            VStack {
                Text("Test")
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("\(Int(progress * 100))%")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(barColor)
            }
        }
        .padding(lineWidth / 2)
    }
}



#Preview {
    TestView()
}
