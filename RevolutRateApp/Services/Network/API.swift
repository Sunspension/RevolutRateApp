//
//  API.swift
//  RevolutRateApp
//
//  Created by Vladimir Kokhanevich on 12/07/2018.
//  Copyright © 2018 Vladimir Kokhanevich. All rights reserved.
//

import Foundation
import Moya
import RxSwift

struct API {
    
    private let provider = MoyaProvider<ApiService>(plugins: [NetworkLoggerPlugin(verbose: true)])
}

extension API: ApiProtocol {
    
    func rates(base currency: String = "EUR") -> Single<RateResponse> {
        
        return provider.rx.request(.rates(currency: currency)).map(RateResponse.self)
    }
}
