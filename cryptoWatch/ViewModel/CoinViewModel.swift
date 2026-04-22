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
    @Published var portfolioItems: [PortfolioItem] = []
    @Published var totalPortfolioValue: Double = 0
    @Published var selectedCoin: Coin? = nil
    
    private let coinService = CoinAPIService()
    private var wm: WatchListManager  // ← new
    private var portfolioManager: PortfolioManager
    
    init(context: ModelContext) {  // ← now accepts SwiftData context
        self.wm = WatchListManager(context: context)
        self.portfolioManager = PortfolioManager(context: context)
        Task {
            await getCoins()
        }
    }
    
    func getCoins() async {
        do {
            
            let coinData = try await coinService.fetchCoins()
            self.coins = coinData
            updateWatchlist()  // ← after coins load, build watchlist immediately
            updatePortfolio()
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
    
    
    func updatePortfolio() {
        let portfolioCoins = portfolioManager.loadPortfolio()

        portfolioItems = portfolioCoins.compactMap { item in
            if let coin = coins.first(where: { $0.id == item.coinId }) {
                return PortfolioItem(
                    id: coin.id,
                    coin: coin,
                    amount: item.amount,
                )
            }
            return nil
        }

        totalPortfolioValue = portfolioItems.reduce(0) { $0 + $1.value }
    }
    
    func addToPortfolio(coinId: String, amount: Double) {
        portfolioManager.addOrUpdate(coinId, amount: amount)

        updatePortfolio()
    }
    
    func removeFromPortfolio(coinId: String) {
        portfolioManager.remove(coinId)

        updatePortfolio()
    }
    
    func isInPortfolio(_ coin: Coin) -> Bool {
        portfolioManager.contains(coin.id)
    }
    func selectCoin(_ coin: Coin){
        selectedCoin = coin
    }
    
    
    
    private func handleError(_ error: Error) {
        switch error {
        case NetworkError.coinNotFound:
            errorMessage = "Coin not found, Please check the spelling"
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
