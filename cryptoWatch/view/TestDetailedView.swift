//
//  TestDetailedView.swift
//  cryptoWatch
//
//  Created by Dennis Okafor on 15/04/2026.
//

import SwiftUI
import SwiftData

struct TestDetailedView: View {
    @EnvironmentObject var coinViewModel: CoinViewModel

    var body: some View {
        VStack {
            Text("Coin Detail")
            List(coinViewModel.coins) { coin in
                Button {
                    coinViewModel.selectCoin(coin)
                } label: {
                    Text(coin.name)
                }
            }

            if let coin = coinViewModel.selectedCoin {
                VStack(alignment: .leading, spacing: 8) {
                    Text(coin.name).bold()
                    Text("Price: £\(coin.currentPrice ?? 0, specifier: "%.2f")")
                    Text("High: £\(coin.high24h ?? 0, specifier: "%.2f")")
                    Text("Low: £\(coin.low24h ?? 0, specifier: "%.2f")")
                    Text("ATH: £\(coin.ath ?? 0, specifier: "%.2f")")
                    Text("Market Cap: £\(coin.marketCap ?? 0, specifier: "%.0f")")
                    Text("Volume: £\(coin.totalVolume ?? 0, specifier: "%.0f")")
                    Text("Rank: #\(coin.marketCapRank)")
                }
                .padding()
            }
        }
        .task {
            await coinViewModel.getCoins()
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: WatchList.self)
    let viewModel = CoinViewModel(context: container.mainContext)
    TestDetailedView()
        .environmentObject(viewModel)
        .modelContainer(container)
}
