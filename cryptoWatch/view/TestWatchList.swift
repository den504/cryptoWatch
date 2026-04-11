//
//  TestWatchList.swift
//  cryptoWatch
//
//  Created by Dennis Okafor on 11/04/2026.
//

import SwiftUI
import SwiftData

struct TestWatchList: View {
    @EnvironmentObject var coinViewModel: CoinViewModel
    @Environment(\.modelContext) var context
    
    var body: some View {
        VStack {
            Text("Watchlist")
                .font(.title)
            //Displays watched list
            //watched list data is saved on TestContentView
            // using wm.add("ethereum")
            // Improvement - if api fails display last saved data
            // Improvement - display data based on last coin saved
            if coinViewModel.watchlistCoins.isEmpty {
                Text("No coins in your watchlist")
                    .foregroundStyle(.gray)
            } else {
                List(coinViewModel.watchlistCoins, id: \.id) { coin in
                    HStack {
                        Text("\(coin.name)")
                        Text("\(coin.currentPrice)")
                    }
                }
            }
        }
    }
}

#Preview {
    let container = {try! ModelContainer(for: WatchList.self)}()
    return TestWatchList()
        .environmentObject(CoinViewModel(context: container.mainContext))
        .modelContainer(container)
}
