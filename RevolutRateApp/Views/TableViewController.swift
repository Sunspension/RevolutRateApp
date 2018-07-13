//
//  TableViewController.swift
//  RevolutRateApp
//
//  Created by Vladimir Kokhanevich on 12/07/2018.
//  Copyright © 2018 Vladimir Kokhanevich. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TableViewController: UITableViewController {
    
    private let _bag = DisposeBag()
    
    private var rates = Rates()
    
    var viewModel: MainViewModel!
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupTableView()
        setupViewModel()
        viewModel.currencyRequest()
    }

    
    // MARK: - UITableViewDataSource methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if rates.currencies.count == 0 { return 0 }
        
        return section == 0 ? 1 : rates.currencies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        if indexPath.section == 0 {
            
            cell.configure(.baseCurrency(currency: rates.baseCurrency))
            viewModel.observableBaseCurrencyRatio = cell.value.rx.text.orEmpty.asObservable()
            
            return cell
        }
        
        let currency = rates.currencies[indexPath.row]
        cell.configure(.regular(currency: currency))
        
        return cell
    }
    
    
    // MARK: - UITableViewDelegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 { return }
        
        tableView.beginUpdates()
        
        tableView.moveRow(at: IndexPath(row: 0, section: 0), to: IndexPath(row: 0, section: 1))
        tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
        
        viewModel.moveItem(from: indexPath.row)
        tableView.endUpdates()
        
        tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .none)
        makeNewFirstResponder()
    }
    
    // MARK: - Private methods
    
    private func setupTableView() {
        
        tableView.rowHeight = 80
        tableView.tableFooterView = UIView()
    }
    
    private func setupViewModel() {
        
        viewModel.observableRates.bind { [unowned self] rates in
            
            self.rates = rates
            self.tableView.reloadData()
            
        }.disposed(by: _bag)
    }
    
    private func makeNewFirstResponder() {
        
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TableViewCell {
            
            cell.configure(.baseCurrency(currency: rates.baseCurrency))
            cell.value.becomeFirstResponder()
            viewModel.observableBaseCurrencyRatio = cell.value.rx.text.orEmpty.asObservable()
        }
    }
}
