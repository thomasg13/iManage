//
//  MainPageView.swift
//  Main
//
//  Created by David Huang on 11/27/24.
//

import SwiftUI

struct MainPageView: View {
    var body: some View {
        ZStack {
            //Main page functions
            Color.black
            
            Image(systemName: "star.fill")
                .foregroundColor(Color.white)
                .font(.title)
            
            Text("Page 1")
                .foregroundStyle(Color.red)
                .font(.title)
        }
    }
}

#Preview {
    MainPageView()
}
