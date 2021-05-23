//
//  TimeSeriesMounthlyAdjusted.swift
//  CurrencyCalculator
//
//  Created by Cem Sezeroglu on 23.05.2021.
//

import Foundation

struct MonthInfo {
    let date : Date
    let adjustedOpen : Double
    let adjustedClose:Double
    
}

struct TimeSeriesMounthlyAdjusted:Codable {
    let meta : Meta?
    let timeSeries: [String:OHLC]
    
    enum  CodingKeys: String,CodingKey {
        case meta = "Meta Data"
        case timeSeries = "Monthly Adjusted Time Series"
    }
    
    func getMonthInfos()->[MonthInfo] {
        var monthInfos : [MonthInfo] = []
        let sortedTimeSeries = timeSeries.sorted(by: {$0.key > $1.key})
        sortedTimeSeries.forEach { (dateString,ohlc) in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: dateString)!
            let adjustedOpen = getAdjustedOpen(ohlc: ohlc)
            let monthInfo = MonthInfo(date: date, adjustedOpen: adjustedOpen, adjustedClose: Double(ohlc.adjustedClose)!)
            monthInfos.append(monthInfo)
        }
        return monthInfos
    }
    private func getAdjustedOpen(ohlc:OHLC)-> Double{
        return Double(ohlc.open)! * (Double(ohlc.adjustedClose)!/Double(ohlc.close)!)
        
    }
}

struct  Meta: Codable {
    let symbol : String
    
    enum  CodingKeys: String,CodingKey {
        case symbol = "2. Symbol"
    }
}
struct OHLC:Codable {
    let open,close,adjustedClose: String
    
    enum  CodingKeys: String,CodingKey {
        case open = "1. open"
        case close = "4. close"
        case adjustedClose = "5. adjusted close"
    }
    
}
