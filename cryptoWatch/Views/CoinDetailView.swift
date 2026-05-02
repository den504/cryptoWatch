//
//  CoinDetailView.swift
//  cryptoWatch
//
//  Created by Chidubem Obinwanne on 10/04/2026.
//

import SwiftUI
import Charts

struct CoinDetailView: View {
    @EnvironmentObject var coinViewModel: CoinViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showPortfolioSheet = false
    @State private var selectedFilter: String = "1D"
    @Binding var selectedTab: Int
    
    let coin: Coin
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    // MARK: Back button
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Markets")
                        }
                        .foregroundColor(.gray)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    // MARK: Coin header
                    HStack {
                        if let imageURL = URL(string: coin.image), !coin.image.isEmpty {
                            AsyncImage(url: imageURL) { image in
                                image.resizable().scaledToFill()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            
                        } else {
                            Circle().fill(Color.blue).frame(width:40, height: 40).overlay(Text(String(coin.name.prefix(1))).font(.headline).foregroundColor(.white))
                        }
                        
                        VStack(alignment: .leading) {
                            Text(coin.name).font(.largeTitle).bold()
                            Text(coin.symbol).font(.headline).foregroundColor(.secondary).textCase(.uppercase)
                        }
                        Spacer()
                    }
                    
                    // MARK: Price Section
                    VStack(alignment: .leading, spacing: 4) {
                        Text(coin.formattedCurrentPrice)
                            .font(.system(size: 44)).fontWeight(.bold)
                        
                        HStack {
                            Image(systemName: coin.priceChangePercentage24h >= 0 ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                            Text("\(coin.priceChangePercentage24h >= 0 ? "+" : "")\(coin.priceChangePercentage24h, specifier: "%.2f")% (24h)")
                        }
                        .foregroundColor(coin.priceChangePercentage24h >= 0 ? .green : .red)
                        .font(.title3).fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // MARK: Chart Section
                    VStack {
                        if coinViewModel.chartData.isEmpty {
                            ProgressView()
                                .frame(height: 150)
                        } else {
                            Chart(coinViewModel.chartData) { point in
                                LineMark(
                                    x: .value("Time", point.timestamp),
                                    y: .value("Price", point.price)
                                )
                                .foregroundStyle(Color.green)
                                
                                AreaMark(
                                    x: .value("Time", point.timestamp),
                                    y: .value("Price", point.price)
                                )
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color.green.opacity(0.3), Color.clear],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                            }
                            .chartXAxis(.hidden)
                            .chartYAxis(.hidden)
                            .frame(height: 150)
                        }
                        
                        // MARK: Time filters
                        HStack(spacing: 12) {
                            ForEach(["1D", "1W", "1M"], id: \.self) { filter in
                                Button {
                                    selectedFilter = filter
                                    Task {
                                        await coinViewModel.fetchChartData(for: coin.id, filter: filter)
                                    }
                                } label: {
                                    Text(filter)
                                        .font(.caption).bold()
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(selectedFilter == filter ? Color.green.opacity(0.3) : Color.clear)
                                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray.opacity(0.4)))
                                        .cornerRadius(20)
                                        .foregroundColor(selectedFilter == filter ? .green : .gray)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 8)
                    }
                    
                    // MARK: Stats Grid
                    VStack(spacing: 12) {
                        HStack(spacing: 12) {
                            StatView(title: "Market Cap", value: coin.formattedMarketCap)
                            StatView(title: "24H Volume", value: coin.formattedTotalVolume)
                        }
                        
                        HStack(spacing: 12) {
                            StatView(title: "24H High", value: coin.formattedHigh24h)
                            StatView(title: "24H Low", value: coin.formattedLow24h)
                        }
                        
                        HStack(spacing: 12) {
                            StatView(title: "All Time High", value: coin.formattedAth)
                            StatView(title: "Circulating", value: coin.formattedCirculatingSupply)
                        }
                    }
                    
                    // MARK: Action Buttons
                    let isAdded = coinViewModel.isInWatchlist(coin)
                    let isInPortfolio = coinViewModel.isInPortfolio(coin)
                    
                    HStack(spacing: 12) {
                        Button {
                            showPortfolioSheet = true
                        } label: {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text(isInPortfolio ? "Added" : "Add to Portfolio")
                            }
                            .font(.subheadline).bold()
                            .padding()
                            .frame(maxWidth: .infinity, minHeight: 55)
                            .background(isInPortfolio ? Color.blue.opacity(0.4) : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                        }
                        .buttonStyle(.plain)
                        .disabled(isInPortfolio)
                        
                        Button {
                            coinViewModel.addToWatchlist(coin)
                        } label: {
                            HStack {
                                Image(systemName: "bookmark.circle.fill")
                                Text(isAdded ? "Watching" : "Watch")
                            }
                            .font(.subheadline).bold()
                            .padding()
                            .frame(maxWidth: .infinity, minHeight: 55)
                            .background(isAdded ? Color.green.opacity(0.4) : Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                        }
                        .buttonStyle(.plain)
                        .disabled(isAdded)
                    }
                    .padding(.top, 8)
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showPortfolioSheet) {
            PortfolioSheetView(coin: coin, selectedTab: $selectedTab)
                .environmentObject(coinViewModel)
                .presentationDetents([.medium])
        }
        .task {
            coinViewModel.chartData = []
            await coinViewModel.fetchChartData(for: coin.id, filter: "1D")
        }
    }
}

struct StatView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption).fontWeight(.semibold)
                .textCase(.uppercase).foregroundColor(.gray)
            Text(value)
                .font(.title3).bold()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 16)
            .fill(Color.gray.opacity(0.15))
            .stroke(Color.gray, lineWidth: 1))
    }
}

#Preview {
    // CoinDetailView(selectedTab: .constant(0), coin: PreviewData.coin)
}
