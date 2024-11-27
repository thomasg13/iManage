//
//  ContentView.swift
//  Main
//
//  Created by Thomas Guo on 10/31/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showLoadingScreen = true
    
    var body: some View {
        ZStack {
            if showLoadingScreen {
                LoadingScreenView()
                    .transition(.opacity)
                    .animation(.easeIn, value: 1)
            } else {
                TabView{
                    MainPageView()
                        .tabItem() {
                            Image(systemName: "star.fill")
                            Text("Page 1")
                        }
                    SecondPageView()
                        .tabItem() {
                            Image(systemName: "star.fill")
                            Text("Page 2")
                        }
                    ThirdPageView()
                        .tabItem() {
                            Image(systemName: "star.fill")
                            Text("Page 3")
                        }
                }
            }
        }
        .onAppear {
            DispatchQueue.main
                .asyncAfter(deadline: .now() + 3)
                {
                    withAnimation{
                        self.showLoadingScreen = false
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
