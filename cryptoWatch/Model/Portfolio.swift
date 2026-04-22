//
//  Portfolio.swift
//  cryptoWatch
//
//  Created by Chidubem Obinwanne on 22/04/2026.
//


import SwiftData


@Model
class PortfolioCoin {
    var coinId: String
    var  amount: Double
    
    init(coinId:String, amount:Double){
        self.coinId = coinId
        self.amount = amount
    }
}

struct PortfolioItem: Identifiable {
    var id: String
    
    let coin: Coin
    let amount: Double
    var value: Double {
        amount * coin.currentPrice
    }
}


