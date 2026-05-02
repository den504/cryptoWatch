//
//  ChartAPIService.swift
//  cryptoWatch
//
//  Created by Dennis Okafor on 01/05/2026.
//

import Foundation

@MainActor

class ChartAPIService {
    private let baseURL = "https://api.coingecko.com/api/v3/coins"
    
    func fetchChartData(coinId: String, days: String) async throws -> [CoinChart]{
        guard var urlComponents = URLComponents(string: "\(baseURL)/\(coinId)/market_chart") else {
            throw NetworkError.invalidURL
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "vs_currency", value: "gbp"),
            URLQueryItem(name: "days", value: days)
        ]
        
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        let(data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        let decoded = try JSONDecoder().decode(ChartReponse.self, from: data)
        
        return decoded.prices.map { pair in
            CoinChart(timestamp: Date(timeIntervalSince1970: pair[0] / 1000),
        price: pair[1])
            
        }
        
    }
    
}

