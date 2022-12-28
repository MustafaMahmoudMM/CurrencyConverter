//
//  Factory.swift
//  CurrencyConverter
//
//  Created by Mustafa Mahmoud on 17/09/2021.
//

import Foundation

class Factory {
    
    static func getExchangingCurrencyUseCase() -> ExchangingCurrencyUseCase{
        let repository = ExchangingCurrencyRepository.getExchangingCurrencyRepository(remoteDataSource: ExchangingCurrencyRemoteDataSource.sharedInstance)
        return ExchangingCurrencyUseCase(repository: repository)
    }
}
