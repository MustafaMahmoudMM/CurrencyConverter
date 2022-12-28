//
//  ExchangingCurrencyModel.swift
//  CurrencyConverter
//
//  Created by Mustafa Mahmoud on 17/09/2021.
//

import Foundation

struct ExchangingCurrencyModel: Codable {
    
    let amount : String?
    let currency : String?
    
    
    enum CodingKeys: String, CodingKey {
        case amount
        case currency
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        amount = try values.decodeIfPresent(String.self, forKey: .amount)
        currency = try values.decodeIfPresent(String.self, forKey: .currency)
    }
}
