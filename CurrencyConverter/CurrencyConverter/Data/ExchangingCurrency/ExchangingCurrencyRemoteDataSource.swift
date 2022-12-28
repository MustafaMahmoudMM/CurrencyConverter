//
//  ExchangingCurrencyRemoteDataSource.swift
//  CurrencyConverter
//
//  Created by Mustafa Mahmoud on 17/09/2021.
//

import Foundation

class ExchangingCurrencyRemoteDataSource: ExchangingCurrencyDataSource {
    
    static let sharedInstance = ExchangingCurrencyRemoteDataSource()
    let apiClient = URLSessionClient.sharedInstance
    
    // MARK: - implement ExchangingCurrencyDataSource Protocol
    
    func exchangingCurrency(requestValue: RequestValues,compilationHandler:@escaping (Any?,Error?) -> Void){
        
        let exchangingRequestValues = requestValue as? ExchangingCurrencyRequestValues
        let url = "http://api.evp.lt/currency/commercial/exchange/\(exchangingRequestValues?.fromAmount ?? "0.0")-\(exchangingRequestValues?.fromCurrency ?? "")/\(exchangingRequestValues?.toCurrency ?? "")/latest"
        
        var headers: [String : String] = [:]
        headers["Content-type"] = "application/json"
        
        apiClient.executeGetRequest(url: url, parameters: nil, header: headers, compilationHandler: compilationHandler)
        
    }
}
