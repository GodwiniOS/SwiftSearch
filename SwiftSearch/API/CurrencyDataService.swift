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
    @Published var currencyDetails: CurrencyDetailModel? = nil
    @Published var marketData: MarketDataModel? = nil
    
    var currencyDetailSubscription: AnyCancellable?
    var currencySubscription: AnyCancellable?
    var marketDataSubscription: AnyCancellable?

    var currency: CurrencyModel?
    
    init(currency: CurrencyModel) {
        self.currency = currency
        getCurrencyDetails()
    }
    
    
    init() {
        getCurrencys()
        getData()
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
    
    func getCurrencyDetails() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(currency!.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else { return }

        currencyDetailSubscription = NetworkingManager.download(url: url)
            .decode(type: CurrencyDetailModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedCurrencyDetails) in
                self?.currencyDetails = returnedCurrencyDetails
                self?.currencyDetailSubscription?.cancel()
            })
    }
    
    func getData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
        
        marketDataSubscription = NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedGlobalData) in
                self?.marketData = returnedGlobalData.data
                self?.marketDataSubscription?.cancel()
            })
    }
    
}
