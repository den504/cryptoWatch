//
//  ContentView.swift
//  cryptoWatch
//
//  Created by Dennis Okafor on 22/03/2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        TabView{
            MarketsView().tabItem {
                Label("Markets", systemImage: "chart.bar.xaxis")
            }
            WatchlistView().tabItem {
                Label("Watchlist", systemImage: "bookmark")
            }
        }
        
        
    }
}

#Preview {
    ContentView().preferredColorScheme(.dark)
}
