//
//  ViewController.swift
//  CurrencyCalculator
//
//  Created by Cem Sezeroglu on 23.05.2021.
//

import UIKit
import Combine
import MBProgressHUD

class SearchTableViewController: UITableViewController,ProgressAnimation {

    //Enum for mode control
    private enum Mode {
        case onBoarding
        case searching
    }
    
    private lazy var searchController : UISearchController = {
       let sc = UISearchController(searchResultsController: nil)
        
        //Properties
        sc.searchResultsUpdater = self
        sc.delegate = self
        sc.obscuresBackgroundDuringPresentation = false //When user click searchbar background turns black
        sc.searchBar.placeholder = "Enter a company name or symbol"
        sc.searchBar.autocapitalizationType = .allCharacters
        return sc
    }()
    private let apiService = APIService()
    private var subscribers = Set<AnyCancellable>()
    @Published private var searchQuery = String()
    private var searchResults : SearchResults?
    
    //Mode initialization
    @Published private var mode : Mode = .onBoarding
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        observeForm()
     
        
    }
    
    private func observeForm(){
        
        //Debounce apiden response alana kadar biraz bekliyor
        
        //wait 0.5 second then observe in main thread
        $searchQuery
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [unowned self] (searchQuery) in
                guard !searchQuery.isEmpty else {return}
                showLoadingAnimation()
                self.apiService.fetchResultsPublisher(keywords: searchQuery).sink { (completion) in
                   hideLoadingAnimation()
                    //If there is an error
                    switch completion{
                    case .failure(let error):
                        print(error.localizedDescription)
                    case .finished:
                        break
                    }
                    //This block is abput if process is succeed
                } receiveValue: { (searchResults) in
                    self.searchResults = searchResults
                    self.tableView.reloadData()
                
                }.store(in: &self.subscribers)
                
            }.store(in: &subscribers)
        
        $mode.sink { [unowned self] (Mode) in
            switch Mode{
            case.onBoarding:
                
                self.tableView.backgroundView = SearchPlaceHolderView()
            case.searching:
                
             
                    self.tableView.backgroundView = nil
                

                
            }
        }.store(in: &subscribers)
    }
    
   

    private func setupNavigationBar(){
        navigationItem.title = "Search"
        navigationItem.searchController = searchController
    }
    
    private func setupTableView(){
        self.tableView.tableFooterView = UIView()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.items.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! SearchTableViewCell
        
        if let searchResults = self.searchResults{
            let searchData = searchResults.items[indexPath.row]
            cell.configure(with: searchData)
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let searchResults = self.searchResults {
            let searchResultData = searchResults.items[indexPath.row]
            let symbol = searchResultData.symbol
            handleSelection(for: symbol, searchData: searchResultData)
        }
    }
    
    private func handleSelection(for symbol:String,searchData : Searchresult){
        apiService.fetchTimeSeriesMounthlyPublisher(keywords: symbol).sink { (completionResult) in
            switch completionResult{
            case.failure(let error):
                print(error.localizedDescription)
            case .finished :
                break
            }
        } receiveValue: { [weak self](timeSeriesMounthlyAdjusted) in
            
            let asset = Asset(searchResult: searchData, timeSeriesMonthlyAdjusted: timeSeriesMounthlyAdjusted)
            self?.performSegue(withIdentifier: "showCalculater", sender: asset)
           
        }.store(in: &subscribers)


    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCalculater",let destination = segue.destination as? CalculatorTableViewController, let asset = sender as? Asset {
            destination.asset = asset
        }
    }
}
//MARK:UISearchResultUpdating Delegate and UISearchControllerDelegate

extension SearchTableViewController : UISearchResultsUpdating,UISearchControllerDelegate{
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchQuery = searchController.searchBar.text,
              !searchQuery.isEmpty else {
            return
        }
        self.searchQuery = searchQuery
    }
    func willPresentSearchController(_ searchController: UISearchController) {
        mode = .searching
    }
    
    
}

