//
//  ApiService.swift
//  RevolutRateApp
//
//  Created by Vladimir Kokhanevich on 12/07/2018.
//  Copyright © 2018 Vladimir Kokhanevich. All rights reserved.
//

import Foundation
import Moya

enum ApiService {
    
    case rates(currency: String)
}

extension ApiService {
    
    var parameters : [String : Any] {
        
        switch self {
            
        case .rates(let currency):
            
            return ["base" : currency]
        }
    }
}

extension ApiService: TargetType {
    
    var baseURL: URL {
        
        return URL(string: "https://revolut.duckdns.org")!
    }
    
    var path: String {
        
        return "/latest"
    }
    
    var method: Moya.Method {
        
        return .get
    }
    
    var sampleData: Data {
        
        return Data()
    }
    
    var task: Task {
        
        return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        
        return nil
    }
}
