//
//  MainViewModel.swift
//  RevolutRateApp
//
//  Created by Vladimir Kokhanevich on 12/07/2018.
//  Copyright © 2018 Vladimir Kokhanevich. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class MainViewModel {
    
    private var _bag = DisposeBag()
    
    private let _timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
    
    private var _rates = Rates()
    
    private var api: ApiProtocol
    
    private (set) var observableRates = PublishRelay<Rates>()
    
    var observableBaseCurrencyRatio = Observable.just("1") {
        
        didSet {
            
            observableBaseCurrencyRatio
                .bind { [unowned self] ratio in
                    
                    self._rates.currencies.forEach({ $0.ratio = Double(ratio) ?? 0 })
                    
            }.disposed(by: _bag)
        }
    }
    
    init(api: ApiProtocol) {
        
        self.api = api
    }
    
    
    // MARK: - Internal methods
    
    func currencyRequest() {
        
        _timer.flatMapLatest { [unowned self] _ in self.api.rates(base: self._rates.baseCurrency.name) }
            .subscribe(onNext: { response in
                
                self.postResponseHandler(response)
                
        }, onError: { error in debugPrint(error) }).disposed(by: _bag)
    }
    
    func moveItem(from: Int) {
        
        _bag = DisposeBag()
        
        let newBaseCurrency = _rates.currencies[from]
        newBaseCurrency.reset()
        
        _rates.currencies.remove(at: from)
        
        let oldBaseCurrency = Currency(name: _rates.baseCurrency.name, value: 0.0)
        _rates.currencies.insert(oldBaseCurrency, at: 0)
        
        _rates.baseCurrency = newBaseCurrency
        currencyRequest()
    }
    
    
    // MARK: - Private methods
    
    private func postResponseHandler(_ response: RateResponse) {
        
        if _rates.currencies.count > 0 {
            
            updateCurrencyValues(response.rates)
        }
        else {
            
            _rates.baseCurrency = Currency(name: response.base, value: 0.0)
            createCurrencyList(response.rates)
            observableRates.accept(_rates)
        }
    }
    
    private func createCurrencyList(_ currencies: [String : Double]) {
        
        _rates.currencies = currencies.map({ Currency(name: $0.key, value: $0.value) })
    }
    
    private func updateCurrencyValues(_ currencies: [String : Double]) {
        
        for index in 0 ..< _rates.currencies.count {
            
            let currency = _rates.currencies[index]
            currency.value = currencies[currency.name]!
        }
    }
}
