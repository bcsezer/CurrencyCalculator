//
//  DateSelectionTableViewController.swift
//  CurrencyCalculator
//
//  Created by Cem Sezeroglu on 24.05.2021.
//

import UIKit

class DateSelectionTableViewController: UITableViewController {
    var timeSeriesMonthlyAdjusted : TimeSeriesMounthlyAdjusted?
    
   private var monthInfos : [MonthInfo] = []
    var didSelectDate : ((Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setupNavigation()
        setupMonthInfos()
    }
    
    private func setupMonthInfos(){
        if let monthData = timeSeriesMonthlyAdjusted?.getMonthInfos(){
            self.monthInfos = monthData
        }
    }
    
    private func setupNavigation(){
        self.title = "Select Date"
    }

}

extension DateSelectionTableViewController {
    
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monthInfos.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DateSelectionTableViewCell", for: indexPath) as! DateSelectionTableViewCell
        let index = indexPath.row
        let monthInfoData = monthInfos[index]
        
        cell.configureCells(with: monthInfoData, index: index)
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        didSelectDate?(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
