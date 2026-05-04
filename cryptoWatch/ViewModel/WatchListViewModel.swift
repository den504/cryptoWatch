//
//  WatchlistViewModel.swift
//  cryptoWatch
//
//  Created by Dennis Okafor on 06/05/2026.
//

import Foundation
import Combine
import SwiftData

class WatchlistViewModel: ObservableObject {
    @Published var watchlistCoins: [Coin] = []
    @Published var allCoins: [Coin] = []
    @Published var errorMessage: String?
    
    private let wm: WatchListManager
    
    init(context: ModelContext, allCoins: [Coin] = []) {
        self.wm = WatchListManager(context: context)
        self.allCoins = allCoins
        
        // Load saved watchlist
        let cachedWatchlist = loadFromDevice(key: "cachedWatchlist")
        if !cachedWatchlist.isEmpty {
            self.watchlistCoins = cachedWatchlist
        }
    }
    
    // matches saved IDs against live coins
    func updateWatchlist() {
        let savedIDs = wm.load()
        watchlistCoins = allCoins.filter { savedIDs.contains($0.id) }
        saveToDevice(watchlistCoins, key: "cachedWatchlist")
    }
    
    func addToWatchlist(_ coin: Coin) {
        wm.add(coin.id)
        updateWatchlist()
    }
    
    // called when user taps remove
    func removeFromWatchlist(_ coin: Coin) {
        wm.remove(coin.id)
        updateWatchlist()
    }
    
    // used to toggle button state on detail screen
    func isInWatchlist(_ coin: Coin) -> Bool {
        return wm.contains(coin.id)
    }
    
    // Update all coins data (called when fresh coins are fetched)
    func updateCoinsData(_ coins: [Coin]) {
        self.allCoins = coins
        updateWatchlist()
    }
    
    private func saveToDevice(_ coins: [Coin], key: String) {
        do {
            let encoded = try JSONEncoder().encode(coins)
            UserDefaults.standard.set(encoded, forKey: key)
        } catch {
            print("Failed to save \(key): \(error)")
        }
    }
    
    private func loadFromDevice(key: String) -> [Coin] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        do {
            return try JSONDecoder().decode([Coin].self, from: data)
        } catch { return [] }
    }
}
