//
//  PortfolioViewModel.swift
//  cryptoWatch
//
//  Created by Dennis Okafor on 06/05/2026.
//

import Foundation
import Combine
import SwiftData

class PortfolioViewModel: ObservableObject {
    @Published var portfolioItems: [PortfolioItem] = []
    @Published var totalPortfolioValue: Double = 0
    @Published var allCoins: [Coin] = []
    @Published var errorMessage: String?
    
    private var portfolioManager: PortfolioManager
    private let chartService = ChartAPIService()
    
    init(context: ModelContext, allCoins: [Coin] = []) {
        self.portfolioManager = PortfolioManager(context: context)
        self.allCoins = allCoins
        
        // Load cached portfolio coins
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
    
    // Update all coins data (called when fresh coins are fetched)
    func updateCoinsData(_ coins: [Coin]) {
        self.allCoins = coins
        updatePortfolio()
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
