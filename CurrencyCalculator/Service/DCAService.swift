//
//  DCA.swift
//  CurrencyCalculator
//
//  Created by Cem Sezeroglu on 29.05.2021.
//

import Foundation

struct DCAService {
    
    func calculate(asset:Asset,initialInvestmentAmount:Double,MonthlyDolarCoastAverageAmount:Double,initialDayOfInvestmentIndex:Int)-> DCAResult{
        
       let investmentAmount =  getInvestmentAmount(initialInvestmentAmount: initialInvestmentAmount, MonthlyDolarCoastAverageAmount: MonthlyDolarCoastAverageAmount, initialDayOfInvestmentIndex: initialDayOfInvestmentIndex)
        
        let numberOfShares = getNumberOfShares(asset: asset, initialInvestmentAmount: initialInvestmentAmount, MonthlyDolarCoastAverageAmount: MonthlyDolarCoastAverageAmount, initialDayOfInvestmentIndex: initialDayOfInvestmentIndex)
        
        let sharePrice = getLatestSharePrice(asset: asset)
        let currentValue = getCurrentValue(numberOfShares: numberOfShares, latestSharePrices: sharePrice)
        
        let isProfitable = currentValue > investmentAmount
        let gain =  currentValue - investmentAmount
        let yield = gain / investmentAmount
        
        let annualReturn = getAnuualReturn(currentValue: currentValue, investmentAmount: investmentAmount, initialDayOfInvestmentIndex: initialDayOfInvestmentIndex)
        
        
        return .init(currentValue: currentValue,
                     investmentAmount: investmentAmount,
                     gaing: gain,
                     yield: yield,
                     annualReturn: annualReturn,
                     isProfitable: isProfitable)
    }
    
    func getInvestmentAmount(initialInvestmentAmount:Double,
                             MonthlyDolarCoastAverageAmount:Double,
                             initialDayOfInvestmentIndex:Int) -> Double{
        var  totalAmount = Double()
        totalAmount += initialInvestmentAmount
        let dolarCostAveragingAmount = ( MonthlyDolarCoastAverageAmount * initialDayOfInvestmentIndex.doubleValue)
        
        totalAmount += dolarCostAveragingAmount
        
        return totalAmount
        
    }
    func getCurrentValue(numberOfShares:Double,latestSharePrices:Double)-> Double{
        
        
        return numberOfShares*latestSharePrices
    }
    private func getLatestSharePrice(asset:Asset)->Double{
        
        return asset.timeSeriesMonthlyAdjusted.getMonthInfos().first?.adjustedClose ?? 0
        
    }
    
    private func getAnuualReturn(currentValue:Double , investmentAmount:Double, initialDayOfInvestmentIndex:Int) -> Double{
        let rate = currentValue / investmentAmount
        let years = ((initialDayOfInvestmentIndex+1)/12).doubleValue
        print("years : \(years)")
        
        return pow(rate, (1/years))-1
        
    }
    private func getNumberOfShares(asset:Asset,initialInvestmentAmount:Double,MonthlyDolarCoastAverageAmount:Double,initialDayOfInvestmentIndex:Int)-> Double{
        
        var totalShares = Double()

        let initialInvestmentOpenPrice = asset.timeSeriesMonthlyAdjusted.getMonthInfos()[initialDayOfInvestmentIndex].adjustedOpen
        
         let initialInvestmentShares = initialInvestmentAmount / initialInvestmentOpenPrice
        
        totalShares += initialInvestmentShares
        
        asset.timeSeriesMonthlyAdjusted.getMonthInfos().prefix(initialDayOfInvestmentIndex).forEach { (monthInfo) in
            let dsaInvestmentShares = MonthlyDolarCoastAverageAmount / monthInfo.adjustedClose
            
            totalShares += dsaInvestmentShares
            
        }
        return totalShares
    }
}

struct DCAResult {
    
    let currentValue : Double
    let investmentAmount:Double
    let gaing : Double
    let yield : Double
    let annualReturn : Double
    let isProfitable:Bool
}
