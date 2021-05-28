//
//  CalculatorTableViewController.swift
//  CurrencyCalculator
//showInitialDateOfInvestment
//  Created by Cem Sezeroglu on 23.05.2021.
//

import UIKit
import Combine

class CalculatorTableViewController: UITableViewController {
    
    @IBOutlet weak var initialInvestmentAmountTextField:UITextField!
    @IBOutlet weak var monthlyDolarCostAveragingTextField:UITextField!
    @IBOutlet weak var initialDateOfInvestment: UITextField!
    
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var assetNameLabel: UILabel!
    @IBOutlet var currencyLabels: [UILabel]!
    @IBOutlet weak var investingAmountCurrency: UILabel!
    
    @Published private var initialDateOfInvestmentIndex:Int?
    @Published private var initialInvestmentAmount:Int?
    @Published private var monthlyDolarCostAveragingAmount: Int?
    
    private var subscribers = Set<AnyCancellable>()
    
    @IBOutlet weak var dateSlider: UISlider!
    
    var asset : Asset?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTextViews()
        setupDateSlider()
        observeForm()
    }
    private func setupTextViews(){
        initialInvestmentAmountTextField.addDoneButton()
        monthlyDolarCostAveragingTextField.addDoneButton()
        initialDateOfInvestment.delegate = self
        
    }
    private func setupDateSlider(){
        if let count = asset?.timeSeriesMonthlyAdjusted.getMonthInfos().count{
            dateSlider.maximumValue = (count-1).floatValue
        }
    }
    private func setupViews(){
        symbolLabel.text = asset?.searchResult.symbol
        assetNameLabel.text = asset?.searchResult.name
        investingAmountCurrency.text = asset?.searchResult.currency
        currencyLabels.forEach { (label) in
            label.text = asset?.searchResult.currency.addBrackets()
        }
    }
    
    private func observeForm(){
        $initialDateOfInvestmentIndex.sink { [weak self](index) in
            
            guard let index = index else {return} //çünkü index nil dönebilir. Dönerse fonksiyonda sorun çıkmasın diye guardlıyoruz
            self?.dateSlider.value = index.floatValue
            
            if let dateString  = self?.asset?.timeSeriesMonthlyAdjusted.getMonthInfos()[index].date.MMYYFormat{
                self?.initialDateOfInvestment.text = dateString
            }
        }.store(in: &subscribers)
        
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: initialInvestmentAmountTextField).compactMap({
            ($0.object as? UITextField)?.text
        }).sink { [weak self](text) in
            self?.initialInvestmentAmount = Int(text) ?? 0
        }.store(in: &subscribers)
        
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: monthlyDolarCostAveragingTextField).compactMap({
            ($0.object as? UITextField)?.text
        }).sink { [weak self](text) in
            self?.monthlyDolarCostAveragingAmount = Int(text) ?? 0
            
        }.store(in: &subscribers)
        
        Publishers.CombineLatest3($initialInvestmentAmount, $monthlyDolarCostAveragingAmount, $initialDateOfInvestmentIndex)
            .sink { (initialInvestmentAmount,monthlyDolarCostAveragingAmount,initialDateOfInvestmentIndex ) in
                
            }.store(in: &subscribers)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DateSelectionTableViewController , let timeSeriesMonthly = sender as? TimeSeriesMounthlyAdjusted{
            destination.timeSeriesMonthlyAdjusted = timeSeriesMonthly
            destination.selectedIndex = initialDateOfInvestmentIndex
            destination.didSelectDate = { [weak self] index in
                self?.handleDateSelection(at: index)
            }
        }
    }
    
    private func handleDateSelection(at index:Int){
        guard navigationController?.visibleViewController is DateSelectionTableViewController else {return}
        navigationController?.popViewController(animated: true)
        if let monthInfos = asset?.timeSeriesMonthlyAdjusted.getMonthInfos(){
            initialDateOfInvestmentIndex = index
            let monthInfo = monthInfos[index]
            let dateString = monthInfo.date.MMYYFormat
            initialDateOfInvestment.text = dateString
        }
    }
    
    @IBAction func dateSliderDidChange(_ sender: UISlider) {
        initialDateOfInvestmentIndex = Int(sender.value)
    }
    
   

}
extension CalculatorTableViewController : UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == initialDateOfInvestment{
            performSegue(withIdentifier: "showInitialDateOfInvestment", sender: asset?.timeSeriesMonthlyAdjusted)
            return false
        }
        return true
    }
}
