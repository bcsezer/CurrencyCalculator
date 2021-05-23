//
//  APIService.swift
//  CurrencyCalculator
//
//  Created by Cem Sezeroglu on 23.05.2021.
//

import Foundation
import Combine

struct APIService {
    
    let keys = ["6QBC1JC789611O5H","PXY81PAE0FS2JGE7","83GY4LM0APTNBGST"]
    
    var API_KEY:String{
        return keys.randomElement() ?? ""//Return random index (key)from keys array.
    }
   
    func  fetchResultsPublisher(keywords:String) -> AnyPublisher<SearchResults,Error>{
        let urlString = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(keywords)&apikey=\(API_KEY)"
        
      let url = URL(string: urlString)!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map({$0.data})
            .decode(type: SearchResults.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
