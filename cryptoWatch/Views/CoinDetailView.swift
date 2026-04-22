//
//  CoinDetailView.swift
//  cryptoWatch
//
//  Created by Chidubem Obinwanne on 10/04/2026.
//

import SwiftUI

struct CoinDetailView: View {
    @EnvironmentObject var coinViewModel: CoinViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showPortfolioSheet = false
    @State private var holdingAmount: String = ""
    
    let coin: Coin

    var body: some View {
        VStack{
            Button{
                dismiss()
            }
            label:{
                HStack{
                    Image(systemName:"chevron.left")
                    Text("Markets")
                }.foregroundColor(.gray).font(.title3).fontWeight(.semibold).frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .top))
            }
            
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
                    Circle().fill(Color.green).frame(width:100, height: 100).overlay(Text("B").font(.title).foregroundColor(.white)).padding(.trailing, 6)
                }
                
                
                VStack{
                    Text(coin.name).font(.largeTitle).bold().padding(.leading, 6).frame(maxWidth: .infinity, alignment: .leading)
                    Text(coin.symbol).font(.headline).foregroundColor(.secondary).padding(.leading, 5).textCase(.uppercase).frame(maxWidth: .infinity, alignment: .leading)
                }
                
            }.padding(.top, 20).padding(.bottom, 5).frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .top))
            
            Text("\(coin.currentPrice, specifier: "%.2f")").font(.system(size: 50)).fontWeight(.bold).frame(maxWidth: .infinity, alignment: .leading)
            
            HStack{
                Image(systemName:"arrowtriangle.down.fill")
//                Text("-0.87% (24h)")
                Text("\(coin.priceChangePercentage24h >= 0 ? "+" : "")\(coin.priceChangePercentage24h, specifier: "%.2f")% (24h)")
            }.foregroundColor(.red).font(.title3).fontWeight(.semibold).frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .top)).padding(.bottom, 40)
            
            VStack(spacing: 15){
                HStack(spacing: 15){
                    VStack{
                        Text("Market Cap").font(.headline).fontWeight(.semibold).frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .top)).textCase(.uppercase).foregroundColor(.gray)
                        Text(coin.formattedMarketCap).font(.title).bold().frame(maxWidth: .infinity, alignment: .topLeading)
                    }.padding(20).border(Color.gray.opacity(0.3), width: 1).background(RoundedRectangle(cornerRadius: 20).fill(Color.gray.opacity(0.15))
                        .stroke(Color.gray, lineWidth: 1))
                    
                    VStack{
                        Text("24h volume ").font(.headline).fontWeight(.semibold).frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .top)).textCase(.uppercase).foregroundColor(.gray)
                        Text(coin.formattedTotalVolume).font(.title).bold().frame(maxWidth: .infinity, alignment: .topLeading)
                    }.padding(20).border(Color.gray.opacity(0.3), width: 1).background(RoundedRectangle(cornerRadius: 20).fill(Color.gray.opacity(0.15))
                        .stroke(Color.gray, lineWidth: 1))
                }
                
                HStack(spacing: 15){
                    VStack{
                        Text("24H High").font(.headline).fontWeight(.semibold).frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .top)).textCase(.uppercase).foregroundColor(.gray)
                        Text(coin.formattedHigh24h).font(.title).bold().frame(maxWidth: .infinity, alignment: .topLeading)
                    }.padding(20).border(Color.gray.opacity(0.3), width: 1).background(RoundedRectangle(cornerRadius: 20).fill(Color.gray.opacity(0.15))
                        .stroke(Color.gray, lineWidth: 1))
                    
                    VStack{
                        Text("24h Low ").font(.headline).fontWeight(.semibold).frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .top)).textCase(.uppercase).foregroundColor(.gray)
                        Text(coin.formattedLow24h).font(.title).bold().frame(maxWidth: .infinity, alignment: .topLeading)
                    }.padding(20).border(Color.gray.opacity(0.3), width: 1).background(RoundedRectangle(cornerRadius: 20).fill(Color.gray.opacity(0.15))
                        .stroke(Color.gray, lineWidth: 1))
                }
                
                HStack(spacing: 15){
                    VStack{
                        Text("All time High").font(.headline).fontWeight(.semibold).frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .top)).textCase(.uppercase).foregroundColor(.gray)
                        Text(coin.formattedAth).font(.title).bold().frame(maxWidth: .infinity, alignment: .topLeading)
                    }.padding(20).border(Color.gray.opacity(0.3), width: 1).background(RoundedRectangle(cornerRadius: 20).fill(Color.gray.opacity(0.15))
                        .stroke(Color.gray, lineWidth: 1))
                    
                    VStack{
                        Text("Circulating ").font(.headline).fontWeight(.semibold).frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .top)).textCase(.uppercase).foregroundColor(.gray)
                        Text(coin.formattedCirculatingSupply).font(.title).bold().frame(maxWidth: .infinity, alignment: .topLeading)
                    }.padding(20).border(Color.gray.opacity(0.3), width: 1).background(RoundedRectangle(cornerRadius: 20).fill(Color.gray.opacity(0.15))
                        .stroke(Color.gray, lineWidth: 1))
                }
            }.padding(.bottom)
            
            
            let isAdded = coinViewModel.isInWatchlist(coin)
            
            //Place here when already in portfolio view model has being created
//            let isInPortofolio = coinViewModel.isInWatchlist(coin)
            
            HStack(spacing: 12){
                //add  isInPortofolio is portfolio  view model is added
                Button(action: {
                    showPortfolioSheet = true }){
                    HStack{
                        Image(systemName: "plus.circle.fill")
                        Text("Add to Portfolio")
                    }.padding().frame(maxWidth: .infinity).background(Color.blue).foregroundColor(.white).font(.headline).cornerRadius(15)
                    }.buttonStyle(.plain)
                
                Button(action: {
                    coinViewModel.addToWatchlist(coin)
                    print("Added to Watchlist")}){
                    HStack{
                        Image(systemName: "bookmark.circle.fill")
                        Text(!isAdded ? "Add to Watchlist" : "Added to Watchlist")
                    }.padding().frame(maxWidth: .infinity).background(!isAdded ? Color.green: Color.green.opacity(0.4)).foregroundColor(.white).font(.headline).cornerRadius(15)
                    }.buttonStyle(.plain).disabled(isAdded)
            }
            .sheet(isPresented: $showPortfolioSheet){
                PortfolioSheetView(coin: coin)
                    .presentationDetents([.medium])
            }
            
            

        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading).padding().navigationBarBackButtonHidden(true)
        
    }
}

#Preview {
//    CoinDetailView().preferredColorScheme(.dark)
}
