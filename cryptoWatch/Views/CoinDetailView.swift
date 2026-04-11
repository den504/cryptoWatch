//
//  CoinDetailView.swift
//  cryptoWatch
//
//  Created by Chidubem Obinwanne on 10/04/2026.
//

import SwiftUI

struct CoinDetailView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack{
            Button{
                dismiss()
            }
            label:{
                HStack{
                    Image(systemName:"chevron.left")
                    Text("Markets")
                }.foregroundColor(.gray).font(.title2).fontWeight(.semibold).frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .top))
            }
            
            HStack{
                Circle().fill(Color.green).frame(width:100, height: 100).overlay(Text("B").font(.title).foregroundColor(.white)).padding(.trailing, 6)
                
                VStack{
                    Text("Solana").font(.largeTitle).bold().padding(.leading, 6)
                    Text("SOL - Rank #5").font(.headline).foregroundColor(.secondary).padding(.leading, 5)
                }
                
            }.padding(.top, 20).padding(.bottom, 5).frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .top))
            
            Text("$158.40").font(.system(size: 50)).fontWeight(.bold).frame(maxWidth: .infinity, alignment: .leading)
            
            HStack{
                Image(systemName:"arrowtriangle.down.fill")
                Text("£1.39 -0.87% (24h)")
            }.foregroundColor(.red).font(.title3).fontWeight(.semibold).frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .top)).padding(.bottom, 40)
            
            VStack(spacing: 15){
                HStack(spacing: 15){
                    VStack{
                        Text("Market Cap").font(.headline).fontWeight(.semibold).frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .top)).textCase(.uppercase).foregroundColor(.gray)
                        Text("£72.1B").font(.title).bold().frame(maxWidth: .infinity, alignment: .topLeading)
                    }.padding(20).border(Color.gray.opacity(0.3), width: 1).background(RoundedRectangle(cornerRadius: 20).fill(Color.gray.opacity(0.15))
                        .stroke(Color.gray, lineWidth: 1))
                    
                    VStack{
                        Text("24h volume ").font(.headline).fontWeight(.semibold).frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .top)).textCase(.uppercase).foregroundColor(.gray)
                        Text("£3.8B").font(.title).bold().frame(maxWidth: .infinity, alignment: .topLeading)
                    }.padding(20).border(Color.gray.opacity(0.3), width: 1).background(RoundedRectangle(cornerRadius: 20).fill(Color.gray.opacity(0.15))
                        .stroke(Color.gray, lineWidth: 1))
                }
                
                HStack(spacing: 15){
                    VStack{
                        Text("24H High").font(.headline).fontWeight(.semibold).frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .top)).textCase(.uppercase).foregroundColor(.gray)
                        Text("£168.80").font(.title).bold().frame(maxWidth: .infinity, alignment: .topLeading)
                    }.padding(20).border(Color.gray.opacity(0.3), width: 1).background(RoundedRectangle(cornerRadius: 20).fill(Color.gray.opacity(0.15))
                        .stroke(Color.gray, lineWidth: 1))
                    
                    VStack{
                        Text("24h Low ").font(.headline).fontWeight(.semibold).frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .top)).textCase(.uppercase).foregroundColor(.gray)
                        Text("£155.20").font(.title).bold().frame(maxWidth: .infinity, alignment: .topLeading)
                    }.padding(20).border(Color.gray.opacity(0.3), width: 1).background(RoundedRectangle(cornerRadius: 20).fill(Color.gray.opacity(0.15))
                        .stroke(Color.gray, lineWidth: 1))
                }
                
                HStack(spacing: 15){
                    VStack{
                        Text("All time High").font(.headline).fontWeight(.semibold).frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .top)).textCase(.uppercase).foregroundColor(.gray)
                        Text("£260.06").font(.title).bold().frame(maxWidth: .infinity, alignment: .topLeading)
                    }.padding(20).border(Color.gray.opacity(0.3), width: 1).background(RoundedRectangle(cornerRadius: 20).fill(Color.gray.opacity(0.15))
                        .stroke(Color.gray, lineWidth: 1))
                    
                    VStack{
                        Text("Circulating ").font(.headline).fontWeight(.semibold).frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .top)).textCase(.uppercase).foregroundColor(.gray)
                        Text("£465M ").font(.title).bold().frame(maxWidth: .infinity, alignment: .topLeading)
                    }.padding(20).border(Color.gray.opacity(0.3), width: 1).background(RoundedRectangle(cornerRadius: 20).fill(Color.gray.opacity(0.15))
                        .stroke(Color.gray, lineWidth: 1))
                }
            }.padding(.bottom)
            
            
            Button(action: {print("Added to Watchlist")}){
                HStack{
                    Image(systemName: "bookmark.circle.fill")
                    Text("Add to Watchlist")
                }.padding().frame(maxWidth: .infinity).background(Color.green).foregroundColor(.white).font(.headline).cornerRadius(15)
                }
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading).padding()
        
    }
}

#Preview {
    CoinDetailView().preferredColorScheme(.dark)
}
