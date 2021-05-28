//
//  DateSelectionTableViewCell.swift
//  CurrencyCalculator
//
//  Created by Cem Sezeroglu on 24.05.2021.
//

import UIKit

class DateSelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var monthsAgoLAbel: UILabel!
    @IBOutlet weak var dateLAbel: UILabel!
    
  
    
    func configureCells(with monthInfo:MonthInfo,index:Int, isSelected:Bool){
      
        
        dateLAbel.text = monthInfo.date.MMYYFormat
        accessoryType = isSelected ? .checkmark : .none
        
        if index == 1{
            monthsAgoLAbel.text = "1 Months Ago"
        }else if index > 1{
            monthsAgoLAbel.text = "\(index) Months Ago"
        }else{
            monthsAgoLAbel.text = "Just Invested"
        }
        
    }

}
