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
    
    @State private var selectedCoin: Coin?
    
    
    var isLoading: Bool {
        coinViewModel.coins.isEmpty && coinViewModel.errorMessage == nil
    }
    
    var body: some View {
        NavigationStack{
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
                    Text("Error \(error)").foregroundStyle(.red)
                }else{
                    List(coinViewModel.coins, id: \.id){ coin in
                        // One Item
                        //                        NavigationLink(destination: CoinDetailView(coin: coin)) {
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
                                
                                Circle().fill(Color.blue).frame(width:50, height: 50).overlay(Text(String(coin.name.prefix(1))).font(.title).foregroundColor(.white)).padding(.trailing, 6)
                            }
                            
                            
                            VStack(alignment: .leading, spacing: 6){
                                Text("\(coin.name)").font(.title2).fontWeight(.bold)
                                Text(coin.symbol).font(.subheadline).textCase(.uppercase)
                            }
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 6){
                                Text("£\(coin.currentPrice, specifier: "%.2f")").font(.title2).bold()
                                HStack{
                                    Text("\(coin.priceChangePercentage24h >= 0 ? "+" : "")\(coin.priceChangePercentage24h, specifier: "%.2f")%")
                                        .font(.callout).fontWeight(.medium)
                                        .foregroundColor(coin.priceChangePercentage24h < 0 ? .red : .green)
                                }
                                .padding(.horizontal, 6).padding(.vertical, 3).background(RoundedRectangle(cornerRadius: 20).fill(Color.green.opacity(0.2)))
                            }.padding(.trailing, 15)
                            

//                            let isDisabled = coinViewModel.isInWatchlist(coin)
//                            Button {
//                                coinViewModel.addToWatchlist(coin)
//                            } label: {
//                                Text("+")
//                                    .font(.title2)
//                                    .foregroundColor(isDisabled ? .gray : .blue)
//                                    .padding(10)
//                                    .background(
//                                        RoundedRectangle(cornerRadius: 50)
//                                            .stroke(isDisabled ? Color.gray: Color.blue, lineWidth: 1)
//                                            .fill(Color.blue.opacity(0.2)).frame(width: 30, height: 30)
//                                    )
//                            }
//                            .buttonStyle(.plain).disabled(isDisabled)
                            
                        }.frame(maxWidth: .infinity, alignment: .leading)
                            .listRowInsets(EdgeInsets()).listRowSeparator(.hidden).padding(.leading, 5).padding(.vertical, 15).padding(.trailing, 15).onTapGesture {
                                selectedCoin = coin
                            }
                        //                        }.buttonStyle(.plain)
                    }.listStyle(.plain).scrollContentBackground(.hidden).navigationDestination(item: $selectedCoin) { coin in
                        CoinDetailView(coin: coin)
                    }
                }
            }.padding(.horizontal, 10).padding(.top, 20)
//                .navigationTitle("Live Prices").navigationBarTitleDisplayMode(.large)
        }
            
        }
}


#Preview {
    let container = {try! ModelContainer(for: WatchList.self)}()
   return  MarketsView().environmentObject(CoinViewModel(context: container.mainContext)).preferredColorScheme(.dark)
}
