//
//  SearchResults.swift
//  CurrencyCalculator
//
//  Created by Cem Sezeroglu on 23.05.2021.
//

import Foundation

struct SearchResults:Codable {
    
    let items:[Searchresult]
    
    enum CodingKeys:String,CodingKey{
        case items = "bestMatches"
    }
}

struct Searchresult:Codable {
    
    let symbol :String
    let name:String
    let type:String
    let currency:String
    
    enum  CodingKeys: String,CodingKey {
        case symbol = "1. symbol"
        case name = "2. name"
        case type = "3. type"
        case currency = "8. currency"
    }
}
