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
    @Published var allCoins: [Coin] = []
    @Published var errorMessage: String?
    @Published var selectedCoin: Coin? = nil
    @Published var chartData: [CoinChart] = []
    @Published var currentPage = 1
    @Published var isLoading = false
    
    private let coinService = CoinAPIService()
    private let chartService = ChartAPIService()
    
    init(context: ModelContext) {
        let savedCoins = loadFromDevice(key: "savedCoins")
        if !savedCoins.isEmpty {
            self.coins = savedCoins
            self.allCoins = savedCoins
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
        } catch {
            let savedData = loadFromDevice(key: "savedCoins")
            if !savedData.isEmpty {
                self.coins = savedData
                self.errorMessage = nil
            }else{
                handleError(error)
            }
            
        }
        isLoading = false
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

    
    func fetchChartData (for coinId: String, filter: String) async {
        let days: String
        switch filter {
            case "1W": days = "7"
            case "1M": days = "30"
            default: days = "1"
        }
        
        do {
            chartData = try await chartService.fetchChartData(coinId: coinId, days: days)
            print("Chart points loaded: \( chartData.count)")
            print("First price: \( chartData.first?.price ?? 0)")
            print("Last price: \( chartData.last?.price ?? 0)")
//            chartData = data
        } catch{
            handleError(error)
            print("Chart error: \(error)")
        }
    }
    
    private func mergeIntoAllCoins(_ newCoins: [Coin]) {
        for coin in newCoins {
            if let index = allCoins.firstIndex(where: { $0.id == coin.id }) {
                allCoins[index] = coin
            } else {
                allCoins.append(coin)
            }
        }
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
