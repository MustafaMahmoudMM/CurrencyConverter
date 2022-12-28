//
//  ExchangingCurrencyRepository.swift
//  CurrencyConverter
//
//  Created by Mustafa Mahmoud on 17/09/2021.
//

import Foundation

class ExchangingCurrencyRepository: Repository
{
    // MARK: - Shared Instance
    private static var exchangingCurrencyRepository : ExchangingCurrencyRepository?
    
    // MARK: - data source Instance
    private final var remoteDataSource: ExchangingCurrencyDataSource?
    
    // MARK: - get Shared Instance
    static func getExchangingCurrencyRepository(remoteDataSource: ExchangingCurrencyDataSource ) -> ExchangingCurrencyRepository{
        
        if exchangingCurrencyRepository == nil {
            exchangingCurrencyRepository = ExchangingCurrencyRepository(remoteDataSource: remoteDataSource)
        }
        
        return exchangingCurrencyRepository!
    }
    
    private init(remoteDataSource: ExchangingCurrencyDataSource ) {
        
        self.remoteDataSource = remoteDataSource
    }
    
    
    // MARK: - implement Repository Protocol
    func getData(requestValue: RequestValues, compilationHandler:@escaping (ResponseValues?,Error?) -> Void){
        remoteDataSource?.exchangingCurrency(requestValue: requestValue, compilationHandler: { (responseData, error) in
            
            if let data = responseData as? Data {
                let decoder = JSONDecoder()
                let exchangingCurrency = try! decoder.decode(ExchangingCurrencyModel.self, from: data)
                let responseValue = ExchangingCurrencyResponseValues(exchangingCurrency: exchangingCurrency)
                compilationHandler(responseValue,error)
            } else {
                compilationHandler(nil,error)
            }
        })
    }
}
