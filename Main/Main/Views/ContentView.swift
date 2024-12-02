//
//  ContentView.swift
//  Main
//
//  Created by Thomas Guo on 10/31/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showLoadingScreen = true
    @State private var books: [Book] = [
        Book(name: "The great gatsby", startDate: "2024-11-27", isCompleted: false, pages: 300, pagesPerDay: 10, days: 20),
        Book(name: "Magic Mountain", startDate: "2024-11-20", isCompleted: false, pages: 500, pagesPerDay: 10, days: 20)
    ]
    
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
                    ThirdPageView(books: $books)
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
