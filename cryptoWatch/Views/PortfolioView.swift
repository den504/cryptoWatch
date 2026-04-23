import SwiftUI
import SwiftData

struct PortfolioView: View {
    @EnvironmentObject var coinViewModel: CoinViewModel

    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // MARK: Header
                    VStack(spacing: 4) {
                        Text("TOTAL VALUE")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(coinViewModel.totalPortfolioValue.formatted(.currency(code: "GBP")))
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.black)
                    }
                    .padding(.top)
                    
                    // MARK: Holdings list
                    if coinViewModel.portfolioItems.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "wallet.pass")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                            Text("No holdings yet")
                                .foregroundColor(.gray)
                            Text("Add coins to your portfolio from the Markets tab")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(40)
                    } else {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("My holdings")
                                    .font(.headline).bold()
                                    .foregroundColor(.black)
                                Spacer()
                                Text("\(coinViewModel.portfolioItems.count) coins")
                                    .font(.caption)
                                    .foregroundColor(.black)
                            }
                            .padding(.horizontal)
                            
                            ForEach(coinViewModel.portfolioItems) { item in
                                HStack(spacing: 12) {
                                    AsyncImage(url: URL(string: item.coin.image)) { image in
                                        image.resizable()
                                    } placeholder: {
                                        Circle().foregroundColor(.orange)
                                    }
                                    .frame(width: 44, height: 44)
                                    .clipShape(Circle())
                                    
                                    VStack(alignment: .leading) {
                                        Text(item.coin.name).bold()
                                            .foregroundColor(.black)
                                        Text("\(item.amount.formatted()) \(item.coin.symbol.uppercased())")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing) {
                                        Text(item.value.formatted(.currency(code: "GBP").precision(.fractionLength(0))))
                                            .bold()
                                            .foregroundColor(.black)
                                        Text("\(item.coin.priceChangePercentage24h >= 0 ? "+" : "")\(item.coin.priceChangePercentage24h.formatted(.number.precision(.fractionLength(1))))%")
                                            .font(.caption)
                                            .foregroundColor(item.coin.priceChangePercentage24h >= 0 ? .green : .red)
                                    }
                                }
                                .padding(.horizontal)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        coinViewModel.removeFromPortfolio(coinId: item.coin.id)
                                    } label: {
                                        Image(systemName: "trash.fill")
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .background(Color.white.ignoresSafeArea())
            .navigationBarHidden(true)
        }
        .task {
            coinViewModel.updatePortfolio()
        }
    }
}
