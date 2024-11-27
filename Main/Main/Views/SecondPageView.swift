//
//  SecondPageView.swift
//  Main
//
//  Created by David Huang on 11/27/24.
//

import SwiftUI

struct SecondPageView: View {
    var body: some View {
        ZStack {
            //2nd page functions
            Color.black
            
            Image(systemName: "star.fill")
                .foregroundColor(Color.white)
                .font(.title)
            
            Text("Page 2")
                .foregroundStyle(Color.red)
                .font(.title)
        }
    }
}

#Preview {
    SecondPageView()
}
