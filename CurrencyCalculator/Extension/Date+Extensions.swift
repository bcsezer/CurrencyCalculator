//
//  Date+Extensions.swift
//  CurrencyCalculator
//
//  Created by Cem Sezeroglu on 24.05.2021.
//

import Foundation

extension Date{
    var MMYYFormat : String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        
        return dateFormatter.string(from: self)
    }
}
