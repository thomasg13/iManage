//
//  ThirdPageView.swift
//  Main
//
//  Created by David Huang on 11/27/24.
//

import SwiftUI

struct ThirdPageView: View {
    var body: some View {
        ZStack {
            //3rd page functions
            Color.black
            
            Image(systemName: "star.fill")
                .foregroundColor(Color.white)
                .font(.title)
            
            Text("Page 3")
                .foregroundStyle(Color.red)
                .font(.title)
        }
    }
}

#Preview {
    ThirdPageView()
}
