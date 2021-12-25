//
//  HomeViewModel.swift
//  SwiftSearch
//
//  Created by Godwin A on 5/9/21.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var statistics: [StatisticModel] = []
    @Published var allCurrencys: [CurrencyModel] = []
    @Published var portfolioCurrencys: [CurrencyModel] = []
    @Published var isLoading: Bool = false
    @Published var searchText: String = ""
        
    private let currencyProvider = CurrencyProvider()
    private let marketProvider = MarketProvider()
    private var cancellables = Set<AnyCancellable>()
    

    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        
        // updates allCurrencys
        $searchText
            .combineLatest(currencyProvider.$allCurrencys)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCurrencys)
            .sink { [weak self] (returnedCurrencys) in
                self?.allCurrencys = returnedCurrencys
            }
            .store(in: &cancellables)
        
        
        // updates marketData
        marketProvider.$marketData
            .combineLatest($portfolioCurrencys)
            .map(mapGlobalMarketData)
            .sink { [weak self] (returnedStats) in
                self?.statistics = returnedStats
                self?.isLoading = false
            }
            .store(in: &cancellables)
        
    }
    
    func reloadData() {
        isLoading = true
        currencyProvider.getCurrencys()
        marketProvider.getData()
    }
    
    private func filterAndSortCurrencys(text: String, currencys: [CurrencyModel]) -> [CurrencyModel] {
        return filterCurrencys(text: text, currencys: currencys)
    }

    private func filterCurrencys(text: String, currencys: [CurrencyModel]) -> [CurrencyModel] {
        guard !text.isEmpty else {
            return currencys
        }
        
        let lowercasedText = text.lowercased()
        
        return currencys.filter { (currency) -> Bool in
            return currency.name.lowercased().contains(lowercasedText) ||
                    currency.symbol.lowercased().contains(lowercasedText) ||
                    currency.id.lowercased().contains(lowercasedText)
        }
    }
    
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?, portfolioCurrencys: [CurrencyModel]) -> [StatisticModel] {
        var stats: [StatisticModel] = []
    
        guard let data = marketDataModel else {
            return stats
        }
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolioValue =
            portfolioCurrencys
                .map({ $0.currentHoldingsValue })
                .reduce(0, +)
        
        let previousValue =
            portfolioCurrencys
                .map { (currency) -> Double in
                    let currentValue = currency.currentHoldingsValue
                    let percentChange = currency.priceChangePercentage24H ?? 0 / 100
                    let previousValue = currentValue / (1 + percentChange)
                    return previousValue
                }
                .reduce(0, +)

        let percentageChange = ((portfolioValue - previousValue) / previousValue)
        
        let portfolio = StatisticModel(
            title: "Portfolio Value",
            value: portfolioValue.asCurrencyWith2Decimals(),
            percentageChange: percentageChange)
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        return stats
    }
}
