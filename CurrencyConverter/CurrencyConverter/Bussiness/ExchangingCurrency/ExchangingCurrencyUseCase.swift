//
//  ExchangingCurrencyUseCase.swift
//  CurrencyConverter
//
//  Created by Mustafa Mahmoud on 17/09/2021.
//

import Foundation

struct ExchangingCurrencyUseCase : UseCase {
    var repository: Repository
    func executeUseCase(requestValues: RequestValues, compilationHandler:@escaping (ResponseValues?,Error?) -> Void){
        repository.getData(requestValue: requestValues, compilationHandler: compilationHandler)
        
    }
}

struct ExchangingCurrencyRequestValues: RequestValues{
    let fromAmount: String
    let fromCurrency: String
    let toCurrency: String
}

struct ExchangingCurrencyResponseValues: ResponseValues {
    let exchangingCurrency: ExchangingCurrencyModel
}
