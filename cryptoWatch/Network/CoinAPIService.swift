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
    
    func fetchCoins() async throws -> [Coin] {
        guard var urlComponentsForCoin = URLComponents(string: baseURL) else {
            throw NetworkError.invalidURL
        }
        
        urlComponentsForCoin.queryItems = [
            URLQueryItem(name: "vs_currency", value: "gbp"),
            URLQueryItem(name: "order", value: "market_cap_desc"),
            URLQueryItem(name: "per_page", value: "20"),
            URLQueryItem(name: "sparkline", value: "false"),
            URLQueryItem(name: "price_change_percentage", value: "24h")
        ]
        
        guard let url = urlComponentsForCoin.url else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try  await URLSession.shared.data( from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidURL
        }
        
        if httpResponse.statusCode == 429 {
            print("DEBUG: Rate limit reached (429)")
            throw NetworkError.rateLimited
        }
        
        guard httpResponse.statusCode == 200 else {
            print("DEBUG: Server error with status code: \(httpResponse.statusCode)")
            throw NetworkError.invalidResponse
        }
        
        do{
            return try JSONDecoder().decode([Coin].self, from: data)
        }catch{
            print("DEBUG: Decoding error: \(error)")
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
    case rateLimited
}
