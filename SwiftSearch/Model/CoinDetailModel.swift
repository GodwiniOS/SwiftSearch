//
//  CurrencyDetailModel.swift
//  SwiftSearch
//
//  Created by Godwin A on 5/11/21.
//

import Foundation

// JSON Data
// https://api.currencygecko.com/api/v3/currencys/bitcurrency?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false




struct CurrencyDetailModel: Codable {
    let id, symbol, name: String?
    let blockTimeInMinutes: Int?
    let hashingAlgorithm: String?
    let description: Description?
    let links: Links?
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, description, links
        case blockTimeInMinutes = "block_time_in_minutes"
        case hashingAlgorithm = "hashing_algorithm"
    }
    
    var readableDescription: String? {
        return description?.en?.removingHTMLOccurances
    }
}

struct Links: Codable {
    let homepage: [String]?
    let subredditURL: String?
    
    enum CodingKeys: String, CodingKey {
        case homepage
        case subredditURL = "subreddit_url"
    }
}

struct Description: Codable {
    let en: String?
}
