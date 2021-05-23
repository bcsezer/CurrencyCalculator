//
//  ProgressAnimation.swift
//  CurrencyCalculator
//
//  Created by Cem Sezeroglu on 23.05.2021.
//

import Foundation
import MBProgressHUD

protocol ProgressAnimation where Self: UIViewController {
    func showLoadingAnimation()
    func hideLoadingAnimation()
}
extension ProgressAnimation {
    func showLoadingAnimation(){
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
      
    }
    func hideLoadingAnimation(){
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        
    }
}
