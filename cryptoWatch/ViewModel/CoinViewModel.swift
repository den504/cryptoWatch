//
//  CoinViewModel.swift
//  cryptoWatch
//
//  Created by Dennis Okafor on 06/04/2026.
//

import Foundation
import Combine
import SwiftData

class CoinViewModel: ObservableObject {
    @Published var coins: [Coin] = []
    @Published var watchlistCoins: [Coin] = []  // ← new
    @Published var errorMessage: String?
    
    private let coinService = CoinAPIService()
    private var wm: WatchListViewModel  // ← new
    
    init(context: ModelContext) {  // ← now accepts SwiftData context
        self.wm = WatchListViewModel(context: context)
        Task {
            await getCoins()
        }
    }
    
    func getCoins() async {
        do {
            let coinData = try await coinService.fetchCoins()
            self.coins = coinData
            updateWatchlist()  // ← after coins load, build watchlist immediately
        } catch {
            handleError(error)
        }
    }
    
    // ← new: matches saved IDs against live coins
    func updateWatchlist() {
        let savedIDs = wm.load()
        watchlistCoins = coins.filter { savedIDs.contains($0.id) }
    }
    
    // ← new: called when user taps "Add to watchlist"
    func addToWatchlist(_ coin: Coin) {
        wm.add(coin.id)
        updateWatchlist()
    }
    
    // ← new: called when user taps remove
    func removeFromWatchlist(_ coin: Coin) {
        wm.remove(coin.id)
        updateWatchlist()
    }
    
    // ← new: used to toggle button state on detail screen
    func isInWatchlist(_ coin: Coin) -> Bool {
        return wm.contains(coin.id)
    }
    
    private func handleError(_ error: Error) {
        switch error {
        case NetworkError.coinNotFound:
            errorMessage = "City not found, Please check the spelling"
        case NetworkError.decodingError:
            errorMessage = "Failed to process coin data"
        case NetworkError.invalidResponse:
            errorMessage = "Server error. Please try again later"
        case NetworkError.invalidURL:
            errorMessage = "Invalid request"
        default:
            errorMessage = "Failed to load coin: \(error.localizedDescription)"
        }
        coins = []
    }
}
