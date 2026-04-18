//
//  cryptoWatchApp.swift
//  cryptoWatch
//
//  Created by Dennis Okafor on 22/03/2026.
//

import SwiftUI
import SwiftData

@main
struct cryptoWatchApp: App {
    
    @StateObject private var vm: CoinViewModel
    private let container: ModelContainer  // ← keep reference
    
    init() {
        do {
            let container = try ModelContainer(for: WatchList.self)
            self.container = container
            _vm = StateObject(wrappedValue: CoinViewModel(context: container.mainContext))
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
                
            ContentView()
                .environmentObject(vm)
                .modelContainer(container)
        }
    }
}
