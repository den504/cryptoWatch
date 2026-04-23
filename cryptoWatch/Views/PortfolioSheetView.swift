//
//  PortfolioSheetView.swift
//  cryptoWatch
//
//  Created by Dennis Okafor on 21/04/2026.
//
import SwiftUI

struct PortfolioSheetView : View {
    let coin: Coin //from the Market view, to the CoinDetail, to PortfolioSheetView
    @EnvironmentObject var coinViewModel: CoinViewModel
    @State private var holdingAmount: String = ""
    @Environment(\.dismiss) var dismiss

    
    //compute VAR for current value
    var currentValue: Double {
        let amount = Double(holdingAmount) ?? 0
        return (amount * coin.currentPrice).rounded()
    }
    
    
    var body: some View {
        
        VStack(spacing: 20){
            //Add to portfolio
            HStack {
                Text("Add to portfolio").font(.title2).bold()
                Spacer()
                Button{ dismiss() } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.title2)
                }
            }.padding(.horizontal)
                .padding(.top)
            
            //Coin info row
            
            HStack(spacing: 12){
                AsyncImage(url: URL(string: coin.image)) { image
                    in image.resizable()
                } placeholder: {
                    Circle().foregroundColor(.orange)
                }
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text(coin.name).bold()
                    Text("Current price: \(coin.currentPrice.formatted(.currency(code: "GBP")))")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .padding(.horizontal)
            
            //field for holding
            
            VStack(alignment: .leading, spacing: 8){
                Text("HOW MUCH DO YOU HOLD")
                    .font(.caption)
                    .foregroundColor(.gray)
                HStack{
                    TextField("0.00", text: $holdingAmount)
                        .keyboardType(.decimalPad)
                        .font(.title2.bold())
                    Text(coin.symbol.uppercased())
                        .foregroundColor(.gray)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 12).stroke(Color.orange, lineWidth: 1.5)
                )
                .padding(.horizontal)
            }
            .padding(.horizontal)
            
            //display for current value
            HStack{
                Text("Current value")
                    .foregroundColor(.gray)
                Spacer()
                Text(currentValue.formatted(.currency(code:"GBP")))
                    .foregroundColor(.green)
                    .bold()
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .padding(.horizontal)
            
            //Button for Save holding
            Button {
                let amount = Double(holdingAmount) ?? 0
                if amount > 0 {
                    coinViewModel.addToPortfolio(coinId: coin.id, amount: amount)
                    print("Saved \(amount) of \(coin.name) to portfolio")
                }
                dismiss()
            } label: {
                Text("Save holding")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
    }
}
