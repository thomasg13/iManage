//
//  ContentView.swift
//  Main
//
//  Created by Thomas Guo on 10/31/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showLoadingScreen = true
	@State var books: [Book] = [
		Book(name: "The Great Gatsby", startDate: "2024-11-27", pages: 300, pagesRead:100),
		Book(name: "Magic Mountain", startDate: "2024-11-28", pages: 300, pagesRead:100)
	]
	@State var Journals : [journal] = [
		journal(title: "First Journal", date: "", note: "This is the first journal entry")
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
                            Text("Tasks")
                        }
                    SecondPageView()
                        .tabItem() {
                            Image(systemName: "star.fill")
                            Text("Calendar")
                        }
					ThirdPageView(books: $books, Journals: $Journals)
                        .tabItem() {
                            Image(systemName: "star.fill")
                            Text("Reading")
                        }
                    FourthPageView()
                        .tabItem() {
                            Image(systemName: "star.fill")
                            Text("Daily Goals")
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
