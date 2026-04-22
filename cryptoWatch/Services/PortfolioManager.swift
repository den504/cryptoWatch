//
//  PortfolioManager.swift
//  cryptoWatch
//
//  Created by Chidubem Obinwanne on 22/04/2026.
//

import SwiftData

class PortfolioManager{
    private var context: ModelContext
    
    init (context:ModelContext){
        self.context = context
    }
    
    //Load all portfolio
    func loadPortfolio() -> [PortfolioCoin]{
        let descriptor = FetchDescriptor<PortfolioCoin>()
        return (try? context.fetch(descriptor)) ?? []
    }
    
    // Add or update coin amount
        func addOrUpdate(_ coinId: String, amount: Double) {
            let items = loadPortfolio()

            if let existing = items.first(where: { $0.coinId == coinId }) {
                existing.amount = amount
            } else {
                let newItem = PortfolioCoin(coinId: coinId, amount: amount)
                context.insert(newItem)
            }

            try? context.save()
        }

        func remove(_ coinId: String) {
            let items = loadPortfolio()

            if let item = items.first(where: { $0.coinId == coinId }) {
                context.delete(item)
                try? context.save()
            }
        }

        func contains(_ coinId: String) -> Bool {
            return loadPortfolio().contains { $0.coinId == coinId }
        }
}
