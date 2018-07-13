//
//  Currency.swift
//  RevolutRateApp
//
//  Created by Vladimir Kokhanevich on 12/07/2018.
//  Copyright © 2018 Vladimir Kokhanevich. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class Currency {
    
    private (set) var observableValue = PublishRelay<Double>()
    
    var name = ""
    
    var ratio = 1.0 {
        
        didSet { observableValue.accept(value * ratio) }
    }
    
    var value = 0.0 {
        
        didSet { observableValue.accept(value * ratio) }
    }
    
    var quantity = 1.0
    
    
    init(name: String, value: Double) {
        
        self.name = name
        self.value = value
        quantity = 1
    }
    
    func reset() {
        
        ratio = 1.0
        value = 0.0
        quantity = 1.0
    }
}
