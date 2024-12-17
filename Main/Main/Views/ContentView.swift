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
		journal(title: "First Journal", date: "12/3/24", note: "This is the first journal entry")
	]
	@State private var selectedTab = 0
    var body: some View {
        ZStack {
            if showLoadingScreen {
                LoadingScreenView()
                    .transition(.opacity)
                    .animation(.easeIn, value: 1)
            } else {
                TabView(selection: $selectedTab){
                    MainPageView()
                        .tabItem() {
							if(selectedTab == 0) {
								Image(systemName: "checkmark.circle.fill")
								Text("Tasks")
							}
							else {
								Image(systemName: "checkmark")
								Text("Tasks")
							}
                        }
						.tag(0)
                    SecondPageView()
                        .tabItem() {
							if(selectedTab == 1) {
								Image(systemName: "dumbbell.fill")
								Text("Fitness")
							}
							else {
								Image(systemName: "dumbbell")
								Text("Fitness")
							}
                        }
						.tag(1)
					
					ThirdPageView(books: $books, Journals: $Journals)
                        .tabItem() {
							if(selectedTab == 2) {
								Image(systemName: "book.circle.fill")
								Text("Intel")
							}
							else {
								Image(systemName: "book")
								Text("Intel")
							}
                        }
						.tag(2)
                    FourthPageView()
                        .tabItem() {
							if(selectedTab == 3) {
								Image(systemName: "star.circle.fill")
								Text("Daily Goals")
							}
							else {
								Image(systemName: "star")
								Text("Daily Goals")
							}
                        }
						.tag(3)
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
