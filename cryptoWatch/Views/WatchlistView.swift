//
//  WatchlistView.swift
//  cryptoWatch
//
//  Created by Chidubem Obinwanne on 06/04/2026.
//

import SwiftUI
import SwiftData

struct WatchlistView: View {
    @EnvironmentObject var coinViewModel: CoinViewModel
    @EnvironmentObject var watchlistViewModel : WatchlistViewModel
    @Environment(\.modelContext) var context
    
    @State private var selectedCoin: Coin?
    @Binding var selectedTab: Int
    
    var isLoading: Bool {
        watchlistViewModel.watchlistCoins.isEmpty && watchlistViewModel.errorMessage == nil
    }
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.black.ignoresSafeArea()
                VStack(alignment: .leading){
                    //        VStack{
                    Text("Watchlist").font(.largeTitle).fontWeight(.bold).padding(1).padding(.leading, 5)
                    
                    Text("\(watchlistViewModel.watchlistCoins.count) coins saved").fontWeight(.semibold).foregroundColor(.gray)
                        .padding(.horizontal, 10).padding(.bottom, 25)
                    //        }
                    //        .padding(.horizontal, 6).frame(maxWidth: .infinity, alignment: .leading)
                    
                    if isLoading{
                        Text("Loading coins...")
                    }else if let error = watchlistViewModel.errorMessage{
                        Text("Error \(error)").foregroundStyle(.red)
                    }else{
                        List{
                            
                            ForEach(watchlistViewModel.watchlistCoins, id: \.id){ coin in
                                // One Item
                                
                                
                                HStack{
                                    HStack{
                                        Rectangle().fill(Color.green).frame(width: 5, height: 60,).padding(.trailing, 10)}
                                    
                                    
                                    if let imageURL =  URL(string: coin.image), !coin.image.isEmpty{
                                        AsyncImage(url: imageURL) { image in
                                            image
                                                .resizable()
                                                .scaledToFill()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                        
                                    } else {
                                        
                                        Circle().fill(Color.blue).frame(width:50, height: 50).overlay(Text(String(coin.name.prefix(1))).font(.title).foregroundColor(.white)).padding(.trailing, 6)
                                    }
                                    
                                    
                                    Circle().fill(Color.blue).frame(width:50, height: 50).overlay(Text(String(coin.name.prefix(1))).font(.title).foregroundColor(.white)).padding(.trailing, 6)
                                }
                                
                                
                                VStack(alignment: .leading, spacing: 6){
                                    Text("\(coin.name)").font(.title2).fontWeight(.bold)
                                    Text(coin.symbol).font(.subheadline).textCase(.uppercase)
                                }
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 6){
                                    Text(coin.formattedCurrentPrice).font(.title2).bold()
                                    HStack{
                                        if let change = coin.priceChangePercentage24h {
                                            Text("\(change >= 0 ? "+" : "")\(change, specifier: "%.2f")%")
                                                .font(.callout).fontWeight(.medium)
                                                .foregroundColor(change < 0 ? .red : .green)
                                        } else {
                                            Text("N/A")
                                                .font(.callout).fontWeight(.medium)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    Spacer()
                                    
                                    VStack(alignment: .trailing, spacing: 6){
                                        Text(coin.formattedCurrentPrice).font(.title2).bold()
                                        HStack{
                                            let priceChange = coin.priceChangePercentage24h ?? 0
                                            Text("\(priceChange >= 0 ? "+" : "")\(priceChange, specifier: "%.2f")%")
                                                .font(.callout).fontWeight(.medium)
                                                .foregroundColor(priceChange < 0 ? .red : .green)
                                        }
                                        .padding(.horizontal, 6).padding(.vertical, 3).background(RoundedRectangle(cornerRadius: 20).fill(Color.green.opacity(0.2)))
                                    }.padding(.trailing, 15)
                                    
                                }.frame(maxWidth: .infinity, alignment: .leading)
                                    .listRowInsets(EdgeInsets()).listRowSeparator(.hidden).padding(.leading, 5).padding(.vertical, 15).padding(.trailing, 15).listRowBackground(Color.clear).onTapGesture {
                                        selectedCoin = coin
                                    }
                            }.onDelete(perform: deleteItems)
                            
                        }.listStyle(.plain).scrollContentBackground(.hidden).navigationDestination(item: $selectedCoin) { coin in
                            CoinDetailView(selectedTab: $selectedTab, coin: coin ).onDisappear {
                                selectedCoin = nil
                            }
                        }
                    }
                }.padding(.top, 20).foregroundColor(.white)
            }
            
        }
        .task {
            watchlistViewModel.updateCoinsData(coinViewModel.allCoins)
        }
        }
    
    
    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let coin = watchlistViewModel.watchlistCoins[index]
            watchlistViewModel.removeFromWatchlist(coin)
        }
    }
}
    
#Preview {
//    WatchlistView().preferredColorScheme(.dark)
//    let container = {try! ModelContainer(for: WatchList.self)}()
//    return WatchlistView().environmentObject(CoinViewModel(context: container.mainContext)).preferredColorScheme(.dark)
}
