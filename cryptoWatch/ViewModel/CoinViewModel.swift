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
    @Published var allCoins: [Coin] = []
    @Published var errorMessage: String?
    @Published var portfolioItems: [PortfolioItem] = []
    @Published var totalPortfolioValue: Double = 0
    @Published var selectedCoin: Coin? = nil
    @Published var chartData: [CoinChart] = []
    @Published var currentPage = 1
    @Published var isLoading = false
    
    private let coinService = CoinAPIService()
    private var wm: WatchListManager  // ← new
    private var portfolioManager: PortfolioManager
    private let chartService = ChartAPIService()
//    private var currentPage = 1
//    private var hasMorePages = true
    
    
    init(context: ModelContext) {  // ← now accepts SwiftData context
        self.wm = WatchListManager(context: context)
        self.portfolioManager = PortfolioManager(context: context)
        
        let savedCoins = loadFromDevice(key: "savedCoins")
        if !savedCoins.isEmpty {
            self.coins = savedCoins
            self.allCoins = savedCoins
            self.updateWatchlist()
            self.updatePortfolio()
        }
        
        //watchlist cache
        let cachedWatchlist = loadFromDevice(key: "cachedWatchlist")
        if !cachedWatchlist.isEmpty {
            self.watchlistCoins = cachedWatchlist
        }
        
        //portfolio cache
        let cachedPortfolioCoins = loadFromDevice(key: "cachedPortfolioCoins")
        if !cachedPortfolioCoins.isEmpty {
            let savedPortfolio = portfolioManager.loadPortfolio()
            self.portfolioItems = savedPortfolio.compactMap { item in
                if let coin = cachedPortfolioCoins.first(where: { $0.id == item.coinId }) {
                    return PortfolioItem(id: coin.id, coin: coin, amount: item.amount)
                }
                return nil
            }
            self.totalPortfolioValue = portfolioItems.reduce(0) { $0 + $1.value }
        }
        Task {
            await getCoins()
        }
    }
    
    func getCoins(page: Int = 1) async {
        guard !isLoading else {return}
        isLoading = true
        self.currentPage = page
        do {
            let coinData = try await coinService.fetchCoins(page: page)
            self.coins = coinData
            self.errorMessage = nil
            mergeIntoAllCoins(coinData)
            saveToDevice(coinData, key: "savedCoins")
            updateWatchlist()  // ← after coins load, build watchlist immediately
            updatePortfolio()
        } catch {
            let savedData = loadFromDevice(key: "savedCoins")
            if !savedData.isEmpty {
                self.coins = savedData
                self.errorMessage = nil
                updateWatchlist()
                updatePortfolio()
            }else{
                handleError(error)
            }
            
        }
        isLoading = false
    }
    
    // ← new: matches saved IDs against live coins
    func updateWatchlist() {
        let savedIDs = wm.load()
        //filtering the required watchlist happens here called on the UI using
        //coinViewModel.watchlistCoins i.e having coinViewModel as the object from CoinViewModel
        watchlistCoins = allCoins.filter { savedIDs.contains($0.id) }
        saveToDevice(watchlistCoins, key: "cachedWatchlist")
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
            if let coin = allCoins.first(where: { $0.id == item.coinId }) {
                return PortfolioItem(
                    id: coin.id,
                    coin: coin,
                    amount: item.amount,
                )
            }
            return nil
        }

        totalPortfolioValue = portfolioItems.reduce(0) { $0 + $1.value }
        saveToDevice(portfolioItems.map { $0.coin }, key: "cachedPortfolioCoins")
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
    
//    private func savePortfolioToDevice(_ items: [PortfolioItem]) {
//        do {
//            let coins = items.map { $0.coin}
//            let encoded = try JSONEncoder().encode(coins)
//            UserDefaults.standard.set(encoded, forKey: "cachedPortolio")
//            
//        }catch {
//            
//            print ("failed to save portfolio: \(error)")
//        }
//    }
    
//    private func loadPortfolioFromDevice() -> [Coin] {
//        guard let data = UserDefaults.standard.data(forKey: "cachedPortfolio") else {return []}
//        do {
//            return try JSONDecoder().decode([Coin].self, from: data)
//        }catch {return []}
//    }
    
    func fetchChartData (for coinId: String, filter: String) async {
        let days: String
        switch filter {
            case "1W": days = "7"
            case "1M": days = "30"
//            case "1Y": days = "365"
            default: days = "1"
        }
        
        do {
            chartData = try await chartService.fetchChartData(coinId: coinId, days: days)
            print("Chart points loaded: \( chartData.count)")  // ← add this
            print("First price: \( chartData.first?.price ?? 0)")  // ← add this
            print("Last price: \( chartData.last?.price ?? 0)")   // ← add this
//            chartData = data
        } catch{
            handleError(error)
            print("Chart error: \(error)")
        }
    }
    
    private func mergeIntoAllCoins(_ newCoins: [Coin]) {
        for coin in newCoins {
            if let index = allCoins.firstIndex(where: { $0.id == coin.id }) {
                allCoins[index] = coin  // ← update existing with fresh price
            } else {
                allCoins.append(coin)  // ← add new coin
            }
        }
    }
    
//    private func saveCoinsToDevice (_ coins: [Coin]) {
//        do {
//            let encoded = try JSONEncoder().encode(coins)
//            UserDefaults.standard.set(encoded, forKey: "savedCoins")
//        } catch {
//            handleError(error)
//        }
//    }
    
//    private func loadCoinsFromDevice() -> [Coin] {
//        guard let data = UserDefaults.standard.data(forKey: "savedCoins") else {
//            return []
//        }
//        do {
//            return try JSONDecoder().decode([Coin].self, from: data)
//        }catch{
//            handleError(error)
//            return []
//        }
//    }
    func fetchPortfolioChart(days: String = "7") async -> [PortfolioPoint] {
        let items = portfolioItems
        guard !items.isEmpty else { return [] }

        var allData: [[CoinChart]] = []

        await withTaskGroup(of: [CoinChart]?.self) { group in
            
            for item in items {
                group.addTask {
                    do {
                        let data = try await self.chartService.fetchChartData(
                            coinId: item.coin.id,
                            days: days
                        )
                        
                        // adjust for amount owned
                        return data.map {
                            CoinChart(
                                timestamp: $0.timestamp,
                                price: $0.price * item.amount
                            )
                        }
                        
                    } catch {
                        print("Error fetching \(item.coin.id):", error)
                        return nil
                    }
                }
            }
            
            for await result in group {
                if let result {
                    allData.append(result)
                }
            }
        }

        return combinePortfolioData(allData)
    }
    
    
    func combinePortfolioData(_ data: [[CoinChart]]) -> [PortfolioPoint] {
        guard let first = data.first else { return [] }
        
        var result: [PortfolioPoint] = []
        
        for i in 0..<first.count {
            let time = first[i].timestamp
            let totalValue = data.reduce(0) { sum, coinData in
                if i < coinData.count {
                    return sum + coinData[i].price
                }
                return sum
            }
            
            result.append(PortfolioPoint(time: time, value: totalValue))
        }
        
        return result
    }
    
    
//    private func loadCachedData(){
//        //watchlist saved
//        let cachedWatchList = loadWatchlistFromDevice
//    }
    
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
