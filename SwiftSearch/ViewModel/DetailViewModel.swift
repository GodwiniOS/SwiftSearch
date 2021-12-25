//
//  DetailViewModel.swift
//  SwiftSearch
//
//  Created by Godwin A on 5/11/21.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    
    @Published var overviewStatistics: [StatisticModel] = []
    @Published var additionalStatistics: [StatisticModel] = []
    @Published var currencyDescription: String? = nil
    @Published var websiteURL: String? = nil
    @Published var redditURL: String? = nil

    @Published var currency: CurrencyModel
    private let currencyDetailProvider: CurrencyProvider
    private var cancellables = Set<AnyCancellable>()
    
    init(currency: CurrencyModel) {
        self.currency = currency
        self.currencyDetailProvider = CurrencyProvider(currency: currency)
        self.addSubscribers()
    }
    
    private func addSubscribers() {
        
        currencyDetailProvider.$currencyDetails
            .combineLatest($currency)
            .map(mapDataToStatistics)
            .sink { [weak self] (returnedArrays) in
                self?.overviewStatistics = returnedArrays.overview
                self?.additionalStatistics = returnedArrays.additional
            }
            .store(in: &cancellables)
        
        currencyDetailProvider.$currencyDetails
            .sink { [weak self] (returnedCurrencyDetails) in
                self?.currencyDescription = returnedCurrencyDetails?.readableDescription
                self?.websiteURL = returnedCurrencyDetails?.links?.homepage?.first
                self?.redditURL = returnedCurrencyDetails?.links?.subredditURL
            }
            .store(in: &cancellables)
        
    }
    
    
    private func mapDataToStatistics(currencyDetailModel: CurrencyDetailModel?, currencyModel: CurrencyModel) -> (overview: [StatisticModel], additional: [StatisticModel]) {
        let overviewArray = createOverviewArray(currencyModel: currencyModel)
        let additionalArray = createAdditionalArray(currencyDetailModel: currencyDetailModel, currencyModel: currencyModel)
        return (overviewArray, additionalArray)
    }
    
    private func createOverviewArray(currencyModel: CurrencyModel) -> [StatisticModel] {
        let price = currencyModel.currentPrice.asCurrencyWith6Decimals()
        let pricePercentChange = currencyModel.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Current Price", value: price, percentageChange: pricePercentChange)
        
        let marketCap = "$" + (currencyModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = currencyModel.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "Market Capitalization", value: marketCap, percentageChange: marketCapPercentChange)
        
        let rank = "\(currencyModel.rank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)
        
        let volume = "$" + (currencyModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = StatisticModel(title: "Volume", value: volume)
        
        let overviewArray: [StatisticModel] = [
            priceStat, marketCapStat, rankStat, volumeStat
        ]
        return overviewArray
    }
    
    private func createAdditionalArray(currencyDetailModel: CurrencyDetailModel?, currencyModel: CurrencyModel) -> [StatisticModel] {
        
        let high = currencyModel.high24H?.asCurrencyWith6Decimals() ?? String().notAvail
        let highStat = StatisticModel(title: "24h High", value: high)
        
        let low = currencyModel.low24H?.asCurrencyWith6Decimals() ?? String().notAvail
        let lowStat = StatisticModel(title: "24h Low", value: low)
        
        let priceChange = currencyModel.priceChange24H?.asCurrencyWith6Decimals() ?? String().notAvail
        let pricePercentChange = currencyModel.priceChangePercentage24H
        let priceChangeStat = StatisticModel(title: "24h Price Change", value: priceChange, percentageChange: pricePercentChange)
        
        let marketCapChange = "$" + (currencyModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = currencyModel.marketCapChangePercentage24H
        let marketCapChangeStat = StatisticModel(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentChange)
        
        let blockTime = currencyDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? String().notAvail : "\(blockTime)"
        let blockStat = StatisticModel(title: "Block Time", value: blockTimeString)
        
        let hashing = currencyDetailModel?.hashingAlgorithm ?? String().notAvail
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
        
        let additionalArray: [StatisticModel] = [
            highStat, lowStat, priceChangeStat, marketCapChangeStat, blockStat, hashingStat
        ]
        return additionalArray
    }
    
}
