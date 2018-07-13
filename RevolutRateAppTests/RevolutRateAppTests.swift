//
//  RevolutRateAppTests.swift
//  RevolutRateAppTests
//
//  Created by Vladimir Kokhanevich on 12/07/2018.
//  Copyright © 2018 Vladimir Kokhanevich. All rights reserved.
//

import XCTest
import RxSwift
import RxTest

@testable import RevolutRateApp

class RevolutRateAppTests: XCTestCase {
    
    private let _bag = DisposeBag()
    
    private lazy var api = API()
    
    private lazy var mainViewModel = MainViewModel(api: api)
    
    func testApiRequest() {
        
        let promise = expectation(description: "waiting rates")
        
        api.rates().subscribe(onSuccess: { response in
            
            XCTAssert(response.rates.count > 0)
            promise.fulfill()
            
        }, onError: { _ in XCTFail() }).disposed(by: _bag)
        
        waitForExpectations(timeout: 5) { error in print(error ?? "") }
    }
    
    func testMainViewModel() {
        
        let promise = expectation(description: "waiting rates")
        
        mainViewModel.observableRates.bind { rates in
            
            XCTAssert(rates.currencies.count > 0)
            promise.fulfill()
            
        }.disposed(by: _bag)
        
        mainViewModel.currencyRequest()
        
        waitForExpectations(timeout: 5) { error in print(error ?? "") }
    }
}
