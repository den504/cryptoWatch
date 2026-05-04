//
//  MarketsView.swift
//  cryptoWatch
//
//  Created by Chidubem Obinwanne on 06/04/2026.
// 

import SwiftUI
import SwiftData

struct MarketsView: View {
    @EnvironmentObject var coinViewModel: CoinViewModel
    @Environment(\.modelContext) var context
    
    @State private var searchText = ""
    @State private var selectedCoin: Coin?
    @Binding var selectedTab: Int
   
    var filteredCoins: [Coin] {
        if searchText.isEmpty {
            return coinViewModel.coins
        } else {
            return coinViewModel.coins.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.symbol.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var isLoading: Bool {
        coinViewModel.coins.isEmpty && coinViewModel.errorMessage == nil
    }
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.black.ignoresSafeArea()
                
                VStack(alignment: .leading){
                    Text("Live Prices").font(.largeTitle).fontWeight(.bold).padding(1)
                    
                    HStack{
                        Circle().fill(Color.green).frame(width: 10, height: 10)
                        Text("Updating every 60s").font(.callout)
                    }.padding(.horizontal, 15).padding(.vertical, 5).background(RoundedRectangle(cornerRadius: 20).fill(Color.green.opacity(0.2))
                        .stroke(Color.green, lineWidth: 2)).padding(.bottom, 25)
                    
                    
                    if isLoading{
                        Text("Loading coins...")
                    }else if let error = coinViewModel.errorMessage{
                        VStack(spacing: 16) {
                            Image(systemName: "wifi.exclamationmark")
                                .font(.system(size: 50))
                                .foregroundColor(.orange)
                                .symbolEffect(.pulse)
                            
                            Text("Unable to load prices")
                                .font(.headline).bold()
                            
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                            
                            Button {
                                Task {
                                    await coinViewModel.getCoins()
                                }
                            } label: {
                                Text("Try Again")
                                    .bold()
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .background(Color.orange)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(40)
                    }else{
                        List(filteredCoins, id: \.id){ coin in
                            HStack{

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
                                    Circle().fill(Color.blue).frame(width:40, height: 40).overlay(Text(String(coin.name.prefix(1))).font(.title).foregroundColor(.white)).padding(.trailing, 6)
                                }
                                
                                VStack(alignment: .leading, spacing: 6){
                                    Text("\(coin.name)").font(.title2).fontWeight(.bold)
                                    Text(coin.symbol).font(.subheadline).textCase(.uppercase)
                                }
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 6){
                                    Text("£\(coin.currentPrice ?? 0, specifier: "%.2f")").font(.title2).bold()
                                    HStack{
                                        let change = coin.priceChangePercentage24h ?? 0
                                        Text("\(change > 0 ? "+" : "")\(change, specifier: "%.2f")%")
                                            .font(.callout).fontWeight(.medium)
                                            .foregroundColor(change <= 0 ? .red : .green)
                                    }
                                    .padding(.horizontal, 6).padding(.vertical, 3).background(RoundedRectangle(cornerRadius: 20).fill((coin.priceChangePercentage24h ?? 0) > 0 ? Color.green.opacity(0.2): Color.red.opacity(0.2)))
                                }.padding(.trailing, 15)
                                
                            }.frame(maxWidth: .infinity, alignment: .leading)
                                .listRowInsets(EdgeInsets()).listRowSeparator(.hidden).padding(.leading, 5).padding(.vertical, 15).padding(.trailing, 15).listRowBackground(Color.clear).onTapGesture {
                                    selectedCoin = coin
                                }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.automatic)
                        .navigationDestination(item: $selectedCoin) { coin in
                            CoinDetailView(selectedTab: $selectedTab, coin: coin ).onDisappear {
                                selectedCoin = nil
                            }
                        }
                    }
                }
                .padding(.horizontal, 10)
                .padding(.top, 5)
                .foregroundColor(.white)
            }
        }
        .searchable(text: $searchText, prompt: "Search coins")
        .preferredColorScheme(.dark)
        .padding(0)
    }
}


#Preview {
//    let container = {try! ModelContainer(for: WatchList.self)}()
//   return  MarketsView().environmentObject(CoinViewModel(context: container.mainContext)).preferredColorScheme(.dark)
}
