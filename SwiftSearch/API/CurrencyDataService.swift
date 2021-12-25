//
//  CurrencyProvider.swift
//  SwiftSearch
//
//  Created by Godwin A on 5/9/21.
//

import Foundation
import Combine

class CurrencyProvider {
    
    @Published var allCurrencys: [CurrencyModel] = []
    
    var currencySubscription: AnyCancellable?
    
    init() {
        getCurrencys()
    }
    
    func getCurrencys() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=inr&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else { return }

        currencySubscription = NetworkingManager.download(url: url)
            .decode(type: [CurrencyModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedCurrencys) in
                self?.allCurrencys = returnedCurrencys
                self?.currencySubscription?.cancel()
            })
    }
}
