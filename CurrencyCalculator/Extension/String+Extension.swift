//
//  String+Extension.swift
//  CurrencyCalculator
//
//  Created by Cem Sezeroglu on 23.05.2021.
//

import Foundation
import UIKit

extension String{
    func addBrackets()->String{
        
        return "(\(self))"
    }
    
    func prefix(withText text:String)-> String{
        return text + self
    }
}
