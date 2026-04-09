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
            Text("testing pull!!")
            
            if coinViewModel.coins.isEmpty {
                Text("Loading coins...")
            } else {
                List(coinViewModel.coins, id: \.id) { coin in
                    Text(coin.name)
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
            let wm = WatchListViewModel(context: context)
            wm.add("bitcoin")
            wm.add("ethereum")
            print("After adding:", wm.load())      // ["bitcoin", "ethereum"]
            wm.remove("bitcoin")
            print("After removing:", wm.load())    // ["ethereum"]
        }
    }
}

#Preview {
    TestContentView()
        .environmentObject(CoinViewModel(context: try! ModelContainer(for: WatchList.self).mainContext))
}
