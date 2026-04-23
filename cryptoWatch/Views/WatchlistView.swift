//
//  WatchlistView.swift
//  cryptoWatch
//
//  Created by Chidubem Obinwanne on 06/04/2026.
//

import SwiftUI
import SwiftData

struct WatchlistView: View {
    @EnvironmentObject var coinViewModel : CoinViewModel
    @Environment(\.modelContext) var context
    
    var isLoading: Bool {
        coinViewModel.watchlistCoins.isEmpty && coinViewModel.errorMessage == nil
    }
    
    var body: some View {
        NavigationStack{
            
            VStack(alignment: .leading){
                //        VStack{
                Text("Watchlist").font(.largeTitle).fontWeight(.bold).padding(1).padding(.leading, 5)
                
                Text("\(coinViewModel.watchlistCoins.count) coins saved").fontWeight(.semibold).foregroundColor(.gray)
                    .padding(.horizontal, 10).padding(.bottom, 25)
                //        }
                //        .padding(.horizontal, 6).frame(maxWidth: .infinity, alignment: .leading)
                
                if isLoading{
                    Text("Loading coins...")
                }else if let error = coinViewModel.errorMessage{
                    Text("Error \(error)").foregroundStyle(.red)
                }else{
                    List{
                        
                        ForEach(coinViewModel.watchlistCoins, id: \.id){ coin in
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
                                .listRowInsets(EdgeInsets()).listRowSeparator(.hidden).padding(.leading, 5).padding(.vertical, 15).padding(.trailing, 15)
                        }.onDelete(perform: deleteItems)
                        }.listStyle(.plain).scrollContentBackground(.hidden)
                    
                    
                    
                    
                    
                    //                List(coinViewModel.watchlistCoins){ coin in
                    //
                    //                    // One Item
                    //                    HStack{
                    //                        Rectangle().fill(Color.green).frame(width: 5, height: 70,).padding(.trailing, 10)
                    //
                    //
                    //                        Circle().fill(Color.blue).frame(width:50, height: 50).overlay(Text("B").font(.title).foregroundColor(.white)).padding(.trailing, 6)
                    //
                    //                        VStack(alignment: .leading, spacing: 6){
                    //                            Text("\(coin.name)").font(.title2).fontWeight(.bold)
                    //                            Text("\(coin.symbol)").font(.subheadline)
                    //                        }
                    //
                    //                        Spacer()
                    //
                    //                        VStack(alignment: .trailing, spacing: 6){
                    //                            Text("£\(coin.price, specifier: "%.2f")").font(.title2).bold()
                    //                            HStack{
                    //                                Text("+0.5%").font(.callout).foregroundColor(.green)
                    //                            }
                    //                            .padding(.horizontal, 6).padding(.vertical, 3).background(RoundedRectangle(cornerRadius: 20).fill(Color.green.opacity(0.2)))
                    //                        }.padding(.trailing, 15)
                    //
                    //                        HStack{
                    //                            Text("-").font(.title2).foregroundColor(.red)
                    //                        }.padding(10).background(RoundedRectangle(cornerRadius: 50)
                    //                            .stroke(Color.red, lineWidth: 1).fill(Color.red.opacity(0.2)) .frame(width: 30, height: 30))
                    //
                    //                    }.frame(maxWidth: .infinity)
                    //                        .listRowInsets(EdgeInsets()).listRowSeparator(.hidden).padding(.leading, 5).padding(.vertical, 10).padding(.trailing, 15)
                    //
                    //                }.listStyle(.plain).scrollContentBackground(.hidden)
                }
            }.padding(.top, 20)
        }
    }
    
    
    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let coin = coinViewModel.watchlistCoins[index]
            coinViewModel.removeFromWatchlist(coin)
        }
    }
}
    
#Preview {
//    WatchlistView().preferredColorScheme(.dark)
//    let container = {try! ModelContainer(for: WatchList.self)}()
//    return WatchlistView().environmentObject(CoinViewModel(context: container.mainContext)).preferredColorScheme(.dark)
}
