//
//  APIService.swift
//  CurrencyCalculator
//
//  Created by Cem Sezeroglu on 23.05.2021.
//

import Foundation
import Combine

struct APIService {
    //MARK:Handle Errors
    enum APIServiceError : Error {
        case encoding
        case badRequest
    }
    
    let keys = ["6QBC1JC789611O5H","PXY81PAE0FS2JGE7","83GY4LM0APTNBGST"]
    
    var API_KEY:String{
        return keys.randomElement() ?? ""//Return random index (key)from keys array.
    }
   
    func  fetchResultsPublisher(keywords:String) -> AnyPublisher<SearchResults,Error>{
        
        let result = parseQuery(text: keywords)
        var keyword = String()
        
        switch result {
        case .success(let query):
            keyword = query
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        
        }
       
        
        let urlString = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(keyword)&apikey=\(API_KEY)"
        let urlResult = parseURL(urlString: urlString)
        
        switch urlResult {
            case .success(let url):
                
                 return URLSession.shared.dataTaskPublisher(for: url)
                     .map({$0.data})
                     .decode(type: SearchResults.self, decoder: JSONDecoder())
                     .receive(on: RunLoop.main)
                     .eraseToAnyPublisher()
                
            case .failure(let error):
                return Fail(error: error).eraseToAnyPublisher()
        
        }
    }
    
    func fetchTimeSeriesMounthlyPublisher(keywords:String)-> AnyPublisher<TimeSeriesMounthlyAdjusted,Error>{
       
        let result = parseQuery(text: keywords)
        var symbol = String()
        
        switch result {
        case .success(let query):
            symbol = query
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        
        }
        
        
        let urlString = "https://www.alphavantage.co/query?function=TIME_SERIES_MONTHLY_ADJUSTED&symbol=\(symbol)&apikey=\(API_KEY)"
        
        let urlResult = parseURL(urlString: urlString)
        
        switch urlResult {
            case .success(let url):
                
                 return URLSession.shared.dataTaskPublisher(for: url)
                     .map({$0.data})
                     .decode(type: TimeSeriesMounthlyAdjusted.self, decoder: JSONDecoder())
                     .receive(on: RunLoop.main)
                     .eraseToAnyPublisher()
                
            case .failure(let error):
                return Fail(error: error).eraseToAnyPublisher()
        
        }
       
       
    }
    
    private func parseQuery(text:String)-> Result<String, Error>{
        
        if let query = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed){
                
            return .success(query)
        }else{
            return .failure(APIServiceError.encoding)
        }
       
    }
    private func parseURL(urlString:String) -> Result<URL,Error>{
        if let url = URL(string: urlString) {
            return .success(url)
        }else{
            return.failure(APIServiceError.badRequest)
        }
    }
}
