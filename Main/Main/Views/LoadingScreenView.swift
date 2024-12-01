//
//  LoadingScreenView.swift
//  Main
//
//  Created by David Huang on 11/27/24.
//

import SwiftUI

struct LoadingScreenView: View {
	@State private var textOpacity: Double = 0.0
	private let text = "iManage"
	var body: some View {
		
		ZStack{
			Color.gray.opacity(0.2)
				.edgesIgnoringSafeArea(.all)
			
			HStack(spacing: 0) {
				ForEach(0..<text.count, id: \.self) { index in
					Text(String(text[text.index(text.startIndex, offsetBy: index)]))
						.font(.title)
						.bold()
						.foregroundStyle(.secondary)
						.background(.ultraThinMaterial)
						.background(Color(red: 0.1+Double(index) * 0.2, green: 0.2+Double(index) * 0.2, blue: 0.5+Double(index) * 0.2).gradient)
						.opacity(self.textOpacity==0 ? 1 : 0)
						.animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true).delay(Double(index) * 0.2))
						.onAppear {
							self.textOpacity = 1.0
						}
				}
			}
		}
	}
}

#Preview {
	LoadingScreenView()
}
