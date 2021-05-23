//
//  SearchTableViewCell.swift
//  CurrencyCalculator
//
//  Created by Cem Sezeroglu on 23.05.2021.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    @IBOutlet weak var assetNameLabel:UILabel!
    @IBOutlet weak var assetSymbolLabel:UILabel!
    @IBOutlet weak var assetTypeLabel:UILabel!
    
    
    func configure(with searchResult:Searchresult){
        self.assetNameLabel.text = searchResult.name
        self.assetSymbolLabel.text = searchResult.symbol
        self.assetTypeLabel.text = searchResult.type
            .appending(" ")
            .appending(searchResult.currency)
        
    }
}
