//
//  WatchListManager.swift
//  cryptoWatch
//
//  Created by Dennis Okafor on 08/04/2026.
//

//saves and removes data to swiftdata

import SwiftData
import Foundation

class WatchListManager {
    private var context: ModelContext
    
    
    init(context: ModelContext) {
        self.context = context
    }
    // Fetch all saved IDs
    func load() -> [String] {
        do {
            let items = (try context.fetch(FetchDescriptor<WatchList>()))
            return items.map { $0.coinId }
        } catch {
            print("load() failed: /(error)")
            return []
        }
    }
    
    func add(_ coinId: String) {
        if !contains(coinId) {
            context.insert(WatchList(coinId: coinId))
            do{ try context.save()
                print("coin added \(coinId)")
            } catch {
                print("add() failed for \(coinId): \(error)")
            }
        }
    }
    
    func remove(_ coinId: String) {
        do {
            let items = (try context.fetch(FetchDescriptor<WatchList>()))
            if let match = items.first(where: { $0.coinId == coinId }) {
                context.delete(match)
                try context.save()
                print("removed \(coinId)")
            }
        }catch{
            print("remove() failed for \(coinId)")
        }

    }
    
    func contains(_ coinId: String) -> Bool {
        return load().contains(coinId)
    }

}


