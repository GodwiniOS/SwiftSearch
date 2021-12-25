//
//  CurrencyImageView.swift
//  SwiftSearch
//
//  Created by Godwin A on 5/9/21.
//

import SwiftUI

struct CurrencyImageView: View {
    
    @StateObject var vm: CurrencyImageViewModel
    
    init(currency: CurrencyModel) {
        _vm = StateObject(wrappedValue: CurrencyImageViewModel(currency: currency))
    }
    
    var body: some View {
        ZStack {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if vm.isLoading {
                ProgressView()
            } else {
                Image(systemName: "questionmark")
                    .foregroundColor(Color.theme.secondaryText)
            }
        }
    }
}
