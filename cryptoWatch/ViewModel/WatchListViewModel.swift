//
//  WatchListViewModel.swift
//  cryptoWatch
//
//  Created by Dennis Okafor on 08/04/2026.
//

import SwiftData
import Foundation

class WatchListViewModel {
    private var context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    // Fetch all saved IDs
    func load() -> [String] {
        let items = (try? context.fetch(FetchDescriptor<WatchList>())) ?? []
        return items.map { $0.coinId }
    }
    
    func add(_ coinId: String) {
        if !contains(coinId) {
            context.insert(WatchList(coinId: coinId))
            try? context.save()
        }
    }
    
    func remove(_ coinId: String) {
        let items = (try? context.fetch(FetchDescriptor<WatchList>())) ?? []
        if let match = items.first(where: { $0.coinId == coinId }) {
            context.delete(match)
            try? context.save()
        }
    }
    
    func contains(_ coinId: String) -> Bool {
        return load().contains(coinId)
    }

}


