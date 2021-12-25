//
//  CurrencyLogoView.swift
//  SwiftSearch
//
//  Created by Godwin A on 5/9/21.
//

import SwiftUI

struct CurrencyLogoView: View {
    
    let currency: CurrencyModel
    
    var body: some View {
        VStack {
            CurrencyImageView(currency: currency)
                .frame(width: 50, height: 50)
            Text(currency.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.accent)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text(currency.name)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
        }
    }
}
