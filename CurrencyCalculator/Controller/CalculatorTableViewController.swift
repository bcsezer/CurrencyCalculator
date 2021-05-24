//
//  CalculatorTableViewController.swift
//  CurrencyCalculator
//showInitialDateOfInvestment
//  Created by Cem Sezeroglu on 23.05.2021.
//

import UIKit

class CalculatorTableViewController: UITableViewController {
    
    @IBOutlet weak var initialInvestmentAmountTextField:UITextField!
    @IBOutlet weak var monthlyDolarCostAveragingTextField:UITextField!
    @IBOutlet weak var initialDateOfInvestment: UITextField!
    
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var assetNameLabel: UILabel!
    @IBOutlet var currencyLabels: [UILabel]!
    @IBOutlet weak var investingAmountCurrency: UILabel!
    
    
    var asset : Asset?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTextViews()
    }
    private func setupTextViews(){
        initialInvestmentAmountTextField.addDoneButton()
        monthlyDolarCostAveragingTextField.addDoneButton()
        initialDateOfInvestment.delegate = self
        
    }
    private func setupViews(){
        symbolLabel.text = asset?.searchResult.symbol
        assetNameLabel.text = asset?.searchResult.name
        investingAmountCurrency.text = asset?.searchResult.currency
        currencyLabels.forEach { (label) in
            label.text = asset?.searchResult.currency.addBrackets()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DateSelectionTableViewController , let timeSeriesMonthly = sender as? TimeSeriesMounthlyAdjusted{
            destination.timeSeriesMonthlyAdjusted = timeSeriesMonthly
            destination.didSelectDate = { [weak self] index in
                self?.handleDateSelection(at: index)
            }
        }
    }
    
    private func handleDateSelection(at index:Int){
        guard navigationController?.visibleViewController is DateSelectionTableViewController else {return}
        navigationController?.popViewController(animated: true)
        if let monthInfos = asset?.timeSeriesMonthlyAdjusted.getMonthInfos(){
            let monthInfo = monthInfos[index]
            let dateString = monthInfo.date.MMYYFormat
            initialDateOfInvestment.text = dateString
        }
    }
  
   

}
extension CalculatorTableViewController : UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == initialDateOfInvestment{
            performSegue(withIdentifier: "showInitialDateOfInvestment", sender: asset?.timeSeriesMonthlyAdjusted)
        }
        return false
    }
}
