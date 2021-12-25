//
//  CurrencyDetailProvider.swift
//  SwiftSearch
//
//  Created by Godwin A on 5/11/21.
//

import Foundation
import Combine

class CurrencyDetailProvider {
    
    @Published var currencyDetails: CurrencyDetailModel? = nil
    
    var currencyDetailSubscription: AnyCancellable?
    let currency: CurrencyModel
    
    init(currency: CurrencyModel) {
        self.currency = currency
        getCurrencyDetails()
    }
    
    func getCurrencyDetails() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(currency.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else { return }

        currencyDetailSubscription = NetworkingManager.download(url: url)
            .decode(type: CurrencyDetailModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedCurrencyDetails) in
                self?.currencyDetails = returnedCurrencyDetails
                self?.currencyDetailSubscription?.cancel()
            })
    }
}
