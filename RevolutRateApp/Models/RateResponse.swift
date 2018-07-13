//
//  RateResponse.swift
//  RevolutRateApp
//
//  Created by Vladimir Kokhanevich on 12/07/2018.
//  Copyright © 2018 Vladimir Kokhanevich. All rights reserved.
//

import Foundation

private enum CodingKeys: String, CodingKey {
    
    case base, rates
}

struct RateResponse {
    
    var base = ""
    var rates: [String : Double]
}

extension RateResponse: Decodable {
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        base = try values.decode(String.self, forKey: .base)
        rates = try values.decode([String : Double].self, forKey: .rates)
    }
}
