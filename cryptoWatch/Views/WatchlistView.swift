//
//  WatchlistView.swift
//  cryptoWatch
//
//  Created by Chidubem Obinwanne on 06/04/2026.
//

import SwiftUI

struct WatchlistView: View {let mockCryptos: [Crypto] = [
    Crypto(name: "Bitcoin", symbol: "BTC", price: 63241, changePercent: 3.21),
    Crypto(name: "Ethereum", symbol: "ETH", price: 2318, changePercent: -1.44),
    Crypto(name: "Solana", symbol: "SOL", price: 158.40, changePercent: -0.87),
    Crypto(name: "Avalanche", symbol: "AVAX", price: 38.20, changePercent: 4.52),
    Crypto(name: "Cardano", symbol: "ADA", price: 0.458, changePercent: 1.10),
    Crypto(name: "Polkadot", symbol: "DOT", price: 7.82, changePercent: -2.30)
]


var body: some View {
    NavigationStack{
        
        VStack(alignment: .leading){
            //        VStack{
            Text("Watchlist").font(.largeTitle).fontWeight(.bold).padding(1).padding(.leading, 5)
            
            Text("5 coins saved").fontWeight(.semibold).foregroundColor(.gray)
                .padding(.horizontal, 10).padding(.vertical, 5).padding(.bottom, 25)
            //        }
            //        .padding(.horizontal, 6).frame(maxWidth: .infinity, alignment: .leading)
            
            
            List(mockCryptos){ coin in
                
                // One Item
                HStack{
                    Rectangle().fill(Color.green).frame(width: 5, height: 70,).padding(.trailing, 10)
                    
                    
                    Circle().fill(Color.blue).frame(width:50, height: 50).overlay(Text("B").font(.title).foregroundColor(.white)).padding(.trailing, 6)
                    
                    VStack(alignment: .leading, spacing: 6){
                        Text("\(coin.name)").font(.title2).fontWeight(.bold)
                        Text(coin.symbol).font(.subheadline)
                    }
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 6){
                        Text("£\(coin.price, specifier: "%.2f")").font(.title2).bold()
                        HStack{
                            Text("+0.5%").font(.callout).foregroundColor(.green)
                        }
                        .padding(.horizontal, 6).padding(.vertical, 3).background(RoundedRectangle(cornerRadius: 20).fill(Color.green.opacity(0.2)))
                    }.padding(.trailing, 15)
                    
                    HStack{
                        Text("-").font(.title2).foregroundColor(.red)
                    }.padding(10).background(RoundedRectangle(cornerRadius: 50)
                        .stroke(Color.red, lineWidth: 1).fill(Color.red.opacity(0.2)) .frame(width: 30, height: 30))
                    
                }.frame(maxWidth: .infinity)
                    .listRowInsets(EdgeInsets()).listRowSeparator(.hidden).padding(.leading, 5).padding(.vertical, 10).padding(.trailing, 15)
                
            }.listStyle(.plain).scrollContentBackground(.hidden)
        }
    }
}
}

#Preview {
    WatchlistView().preferredColorScheme(.dark)
}
