//
//  MarketsView.swift
//  cryptoWatch
//
//  Created by Chidubem Obinwanne on 06/04/2026.
//

import SwiftUI

struct MarketsView: View {
    let mockCryptos: [Crypto] = [
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
                Text("Live Prices").font(.largeTitle).fontWeight(.bold).padding(1)
                
                HStack{
                    Circle().fill(Color.green).frame(width: 10, height: 10)
                    Text("Updating every 60s")
                }.padding(.horizontal, 15).padding(.vertical, 5).background(RoundedRectangle(cornerRadius: 20).fill(Color.green.opacity(0.2))
                    .stroke(Color.green, lineWidth: 2)).padding(.bottom, 25)
                
                List(mockCryptos){ coin in
                    
                    // One Item
                    HStack{
                        
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
                            Text("+").font(.title2).foregroundColor(.blue)
                        }.padding(10).background(RoundedRectangle(cornerRadius: 50)
                            .stroke(Color.blue, lineWidth: 1).fill(Color.blue.opacity(0.2)) .frame(width: 30, height: 30))
                        
                    }.frame(maxWidth: .infinity)
                        .listRowInsets(EdgeInsets()).listRowSeparator(.hidden).padding(.leading, 5).padding(.vertical, 15).padding(.trailing, 15)
                    
                }.listStyle(.plain).scrollContentBackground(.hidden)
            }.padding(.horizontal, 5)
        }
    }
}

struct Crypto: Identifiable {
    let id = UUID()
    let name: String
    let symbol: String
    let price: Double
    let changePercent: Double
}



#Preview {
    MarketsView().preferredColorScheme(.dark)
}
