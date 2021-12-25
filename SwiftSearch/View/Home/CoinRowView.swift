//
//  CurrencyRowView.swift
//  SwiftSearch
//
//  Created by Godwin A on 5/8/21.
//

import SwiftUI

struct CurrencyRowView: View {
        
    let currency: CurrencyModel
    let showHoldingsColumn: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            leftColumn
            Spacer()
            if showHoldingsColumn {
                centerColumn
            }
            rightColumn
        }
        .font(.subheadline)
        .background(
            Color.theme.background.opacity(0.001)
        )
    }
}
extension CurrencyRowView {
    
    private var leftColumn: some View {
        HStack(spacing: 0) {
            Text("\(currency.rank)")
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .frame(minWidth: 30)
            CurrencyImageView(currency: currency)
                .frame(width: 30, height: 30)
            Text(currency.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundColor(Color.theme.accent)
        }
    }
    
    private var centerColumn: some View {
        VStack(alignment: .trailing) {
            Text(currency.currentHoldingsValue.asCurrencyWith2Decimals())
                .bold()
            Text((currency.currentHoldings ?? 0).asNumberString())
        }
        .foregroundColor(Color.theme.accent)
    }
    
    private var rightColumn: some View {
        VStack(alignment: .trailing) {
            Text(currency.currentPrice.asCurrencyWith6Decimals())
                .bold()
                .foregroundColor(Color.theme.accent)
            Text(currency.priceChangePercentage24H?.asPercentString() ?? "")
                .foregroundColor(
                    (currency.priceChangePercentage24H ?? 0 >= 0) ?
                    Color.theme.green :
                    Color.theme.red
                )
        }
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
    }
}
