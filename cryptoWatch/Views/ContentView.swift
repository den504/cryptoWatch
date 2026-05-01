//
//  ContentView.swift
//  cryptoWatch
//
//  Created by Dennis Okafor on 22/03/2026.
//

import SwiftUI
struct ContentView: View {
    @State private var selectedTab = 2  // ← owns the number

    var body: some View {
        TabView(selection: $selectedTab) {  // ← watches the number
            
            MarketsView(selectedTab: $selectedTab)
                .tabItem { Label("Markets", systemImage: "chart.bar.xaxis") }
                .tag(0)  // ← show when number is 1
            
            WatchlistView(selectedTab: $selectedTab)
                .tabItem { Label("Watchlist", systemImage: "bookmark") }
                .tag(1)  // ← show when number is 2
            
            PortfolioView(selectedTab: $selectedTab)
                .tabItem { Label("Portfolio", systemImage: "dollarsign.circle") }
                .tag(2)  // ← show when number is 0
            

        }
    }
}

//#Preview {
////    ContentView().preferredColorScheme(.dark)
//}
