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
    @Published var watchlistCoins: [Coin] = []  // ← placed to get filtered coin array for watchList selected
    @Published var errorMessage: String?
    
    private let coinService = CoinAPIService()
    private var wm: WatchListManager  // ← new
    
    init(context: ModelContext) {  // ← now accepts SwiftData context
        self.wm = WatchListManager(context: context)
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
        //filtering the required watchlist happens here called on the UI using
        //coinViewModel.watchlistCoins i.e having coinViewModel as the object from CoinViewModel
        watchlistCoins = coins.filter { savedIDs.contains($0.id) }
    }
    
    // ← new: called when user taps "Add to watchlist"
    // presents a list of updated coin data which have being saved previously
    // the only property added to the db is the coin id, we then use the coinid
    // to get the latest data on the watch list- therefore watch list is always updated
    //Note: Just as Markets gets live updates,  watchlist needs to get updated
    func addToWatchlist(_ coin: Coin) { //takes all coin object
        wm.add(coin.id) //just adds the coin id to an db
        updateWatchlist() // loads db , with new coin in it as updated from above, then uses
        //
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
