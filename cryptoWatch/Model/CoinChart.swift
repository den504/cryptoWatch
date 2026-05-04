//
//  CoinChart.swift
//  cryptoWatch
//
//  Created by Dennis Okafor on 01/05/2026.
//

import Foundation

struct CoinChart: Identifiable, Hashable, Sendable {
    let id = UUID()
    let timestamp: Date
    let price: Double
}

struct ChartReponse: Codable, Sendable {
    let prices: [[Double]]
}


