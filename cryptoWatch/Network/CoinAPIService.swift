//
//  CoinAPIService.swift
//  cryptoWatch
//
//  Created by Dennis Okafor on 04/04/2026.
//


//Coindecko url - https://api.coingecko.com/api/v3/coins/markets?vs_currency=gbp&order=market_cap_desc&per_page=20&page=1&sparkline=false&price_change_percentage=24h


import Foundation

@MainActor
class CoinAPIService{
    private let baseURL = "https://api.coingecko.com/api/v3/coins/markets"
    
    func fetchCoins(page: Int) async throws -> [Coin] {
        guard var urlComponentsForCoin = URLComponents(string: baseURL) else {
            throw NetworkError.invalidURL
        }
        
        urlComponentsForCoin.queryItems = [
            URLQueryItem(name: "vs_currency", value: "gbp"),
            URLQueryItem(name: "order", value: "market_cap_desc"),
            URLQueryItem(name: "per_page", value: "20"),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "sparkline", value: "false"),
            URLQueryItem(name: "price_change_percentage", value: "24h"),
            URLQueryItem(name: "x_cg_demo_api_key", value: "CG-o1A5HnWNaNaCmQ5fPcRtm8j5")
        ]
        
        guard let url = urlComponentsForCoin.url else {
            throw NetworkError.invalidURL
        }
        
        print("🌐 Fetching from: \(url.absoluteString)")
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidURL
        }
        
        guard httpResponse.statusCode == 200 else {
            print("❌ HTTP Error: \(httpResponse.statusCode)")
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response: \(jsonString)")
            }
            throw NetworkError.invalidResponse
        }
        
        do{
            let coins = try JSONDecoder().decode([Coin].self, from: data)
            print("✅ Successfully decoded \(coins.count) coins")
            return coins
        } catch {
            print("❌ Decoding error: \(error)")
            throw NetworkError.decodingError
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case decodingError
    case coinNotFound
}
