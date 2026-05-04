//
//  cryptoWatchApp.swift
//  cryptoWatch
//
//  Created by Dennis Okafor on 22/03/2026.
//

import SwiftUI
import SwiftData

@main
struct cryptoWatchApp: App {
    
    @StateObject private var coinViewModel: CoinViewModel
    @StateObject private var portfolioViewModel: PortfolioViewModel
    @StateObject private var watchlistViewModel: WatchlistViewModel
    private let container: ModelContainer  // ← keep reference
    
    init() {
        do {
            let container = try ModelContainer(for: WatchList.self, PortfolioCoin.self)
            self.container = container
            
            let coinVM = CoinViewModel(context: container.mainContext)
            let portfolioVM = PortfolioViewModel(context: container.mainContext, allCoins: coinVM.allCoins)
            let watchlistVM = WatchlistViewModel(context: container.mainContext, allCoins: coinVM.allCoins)
            
            _coinViewModel = StateObject(wrappedValue: coinVM)
            _portfolioViewModel = StateObject(wrappedValue: portfolioVM)
            _watchlistViewModel = StateObject(wrappedValue: watchlistVM)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
                
            ContentView()
                .environmentObject(coinViewModel)
                .environmentObject(portfolioViewModel)
                .environmentObject(watchlistViewModel)
                .modelContainer(container)
        }
    }
}
