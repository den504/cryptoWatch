import SwiftUI
import SwiftData
import Charts

struct PortfolioView: View {
    @EnvironmentObject var coinViewModel: CoinViewModel
    @State private var itemToDelete: String? = nil
    @State private var selectedItem: PortfolioItem? = nil
    @Binding var selectedTab: Int
    
    @State private var chartData: [PortfolioPoint] = []
    @State private var selectedFilter: String = "1M"
    @State private var isLoadingChart = false
    
    
    func daysFromFilter(_ filter: String) -> String {
        switch filter {
        case "1D": return "1"
        case "1W": return "7"
        case "1M": return "30"
        default: return "7"
        }
    }
    
    var body: some View {
        NavigationStack {
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // MARK: Header
                        VStack(spacing: 4) {
                            Text("TOTAL VALUE")
                                .font(.callout)
                                .foregroundColor(.gray)
                            Text(coinViewModel.totalPortfolioValue.formatted(.currency(code: "GBP")))
                                .font(.system(size: 40, weight: .bold))
                        }
                        .padding(.top)
                        
                        if isLoadingChart {
                            ProgressView()
                                .frame(height: 200)
                        } else if !chartData.isEmpty {
                            Chart(chartData) { item in
                                LineMark(
                                    x: .value("Time", item.time),
                                    y: .value("Value", item.value)
                                )
                                .foregroundStyle(Color.green)
                                .interpolationMethod(.catmullRom)
                                
                                AreaMark(
                                    x: .value("Time", item.time),
                                    y: .value("Value", item.value)
                                )
                                .foregroundStyle(Color.green.opacity(0.2))
                            }
                            .frame(height: 200)
                            .chartXAxis(.hidden)
                            .chartYAxis(.hidden)
                        }
                        
                        HStack(spacing: 12) {
                            ForEach(["1D", "1W", "1M"], id: \.self) { filter in
                                Button {
                                    guard selectedFilter != filter else { return }
                                    
                                    selectedFilter = filter
                                    
                                    Task {
                                        await loadChart()
                                    }
                                    
                                } label: {
                                    Text(filter)
                                        .font(.caption).bold()
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(
                                            selectedFilter == filter
                                            ? Color.green.opacity(0.3)
                                            : Color.clear
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.gray.opacity(0.8))
                                        )
                                        .cornerRadius(20)
                                        .foregroundColor(
                                            selectedFilter == filter ? .green : .gray
                                        )
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 8)
                        
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
//                                                .foregroundColor(.black)
                                            Text("\(item.amount.formatted()) \(item.coin.symbol.uppercased())")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .trailing) {
                                            Text(item.value.formatted(.currency(code: "GBP").precision(.fractionLength(0))))
                                                .bold()
//                                                .foregroundColor(.black)
                                            Text("\(item.coin.priceChangePercentage24h >= 0 ? "+" : "")\(item.coin.priceChangePercentage24h.formatted(.number.precision(.fractionLength(1))))%")
                                                .font(.caption)
                                                .foregroundColor(item.coin.priceChangePercentage24h >= 0 ? .green : .red)
                                        }
                                    }
                                    .padding(.horizontal)
                                    .onTapGesture {
                                        selectedItem = item
                                    }
                                    .onLongPressGesture{
                                        itemToDelete = item.id
                                    }
                                    .alert("Delete \(item.coin.name)?", isPresented: .constant(itemToDelete == item.id)){
                                        Button("Delete", role: .destructive) {
                                            coinViewModel.removeFromPortfolio(coinId: item.coin.id)
                                            itemToDelete = nil
                                        }
                                        Button ("Cancel", role: .cancel){
                                            itemToDelete = nil
                                        }
                                    }
                                    //                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    //                                    Button(role: .destructive) {
                                    //                                        coinViewModel.removeFromPortfolio(coinId: item.coin.id)
                                    //                                    } label: {
                                    //                                        Image(systemName: "trash.fill")
                                    //                                    }
                                    //                                }
                                }
                            }
                        }
                    }.foregroundColor(.white)
                }.padding(.top, 70)
                .background(Color.black.ignoresSafeArea())
                .navigationBarHidden(true)
                .sheet(item: $selectedItem){item in
                    PortfolioSheetView(coin: item.coin, existingAmount: item.amount, selectedTab: $selectedTab)
                        .environmentObject(coinViewModel)
                        .presentationDetents([.medium])
                    
                }.task{
                    await loadChart()
                }
            
        }
        
        
    }
    func loadChart() async {
        isLoadingChart = true
        
        let days = daysFromFilter(selectedFilter)
        chartData = await coinViewModel.fetchPortfolioChart(days: days)
        
        isLoadingChart = false
    }
}
