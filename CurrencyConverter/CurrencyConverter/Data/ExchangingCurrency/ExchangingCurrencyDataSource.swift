//
//  ExchangingCurrencyDataSource.swift
//  CurrencyConverter
//
//  Created by Mustafa Mahmoud on 17/09/2021.
//

import Foundation

protocol ExchangingCurrencyDataSource {
    
    func exchangingCurrency(requestValue: RequestValues,compilationHandler:@escaping (Any?,Error?) -> Void)
}
