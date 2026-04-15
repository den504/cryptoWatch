//
//  Coin.swift
//  cryptoWatch
//
//  Created by Dennis Okafor on 04/04/2026.
//

//{
//  "id": "bitcoin",                              // unique identifier for API calls
//  "symbol": "btc",                              // "BTC" label
//  "name": "Bitcoin",                            // "Bitcoin" label
//  "image": "https://coin-images.coingecko...",  // coin logo
//  "current_price": 67441,                       // "$63,241"
//  "price_change_percentage_24h": 0.61445,       // "+3.21%"
//  "market_cap_rank": 1                          // for sorting the list
//  "price_change_24h": -1.39
//  "market_cap": 72100000000
//  "total_volume": 380000000
//   "high_24h": 162.80
//   "low_24h": 155.20
//   "circulating_supply":45600000
//    "ath": 260.05
//}

import Foundation

struct Coin: Codable, Sendable, Identifiable {
    let id, symbol, name, image: String
    let currentPrice, priceChangePercentage24h, high24h, low24h, circulatingSupply, ath : Double
    let totalVolume,marketCap : Double
    let marketCapRank: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case symbol
        case name
        case image
        case ath
        case currentPrice = "current_price"
        case priceChangePercentage24h = "price_change_percentage_24h"
        case high24h = "high_24h"
        case low24h = "low_24h"
        case circulatingSupply = "circulating_supply"
        case marketCapRank = "market_cap_rank"
        case totalVolume = "total_volume"
        case marketCap = "market_cap"
    }
}
