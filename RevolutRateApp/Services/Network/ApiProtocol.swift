//
//  APIProtocol.swift
//  RevolutRateApp
//
//  Created by Vladimir Kokhanevich on 12/07/2018.
//  Copyright © 2018 Vladimir Kokhanevich. All rights reserved.
//

import Foundation
import RxSwift

protocol ApiProtocol {
    
    func rates(base currency: String) -> Single<RateResponse>
}
