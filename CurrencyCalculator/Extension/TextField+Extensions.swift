//
//  TextField+Extensions.swift
//  CurrencyCalculator
//
//  Created by Cem Sezeroglu on 24.05.2021.
//

import UIKit

extension UITextField{
    
    func addDoneButton(){
        let screenWidth = UIScreen.main.bounds.width
        let doneToolBar : UIToolbar = UIToolbar(frame: .init(x: 0, y: 0, width: screenWidth, height: 50))
        doneToolBar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        let doneBarButtonitem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        
        let items = [flexSpace,doneBarButtonitem]
        doneToolBar.items = items
        doneToolBar.sizeToFit()
        inputAccessoryView = doneToolBar
    }
    @objc private func dismissKeyboard(){
        resignFirstResponder()
    }
}
