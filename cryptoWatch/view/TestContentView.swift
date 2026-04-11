import SwiftUI
import SwiftData

struct TestContentView: View {
    @EnvironmentObject var coinViewModel: CoinViewModel
    @Environment(\.modelContext) var context

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            
            if coinViewModel.coins.isEmpty {
                Text("Loading coins...")
            } else {
                List(coinViewModel.coins, id: \.id) { coin in
                    Text(coin.id)
                }
            }
            
            if let error = coinViewModel.errorMessage {
                Text("Error: \(error)")
                    .foregroundStyle(.red)
            }
        }
        .padding()
        .onAppear {
            // ← watchlist test
            let wm = WatchListManager(context: context)
            wm.add("bitcoin")
            wm.add("ethereum")
            print("After adding:", wm.load())      // ["bitcoin", "ethereum"]
            wm.remove("bitcoin")
            print("After removing:", wm.load())    // ["ethereum"]
        }
    }
}

#Preview {
    let container = {try! ModelContainer(for: WatchList.self)}()
    return TestContentView()
        .environmentObject(CoinViewModel(context: container.mainContext))
        .modelContainer(container)
//        .environmentObject(CoinViewModel(context: try! ModelContainer(for: WatchList.self).mainContext))
}
