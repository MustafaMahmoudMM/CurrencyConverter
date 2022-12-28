//
//  ExchangingCurrencyPresenter.swift
//  CurrencyConverter
//
//  Created by Mustafa Mahmoud on 17/09/2021.
//

import Foundation

class ExchangingCurrencyPresenter: ExchangingCurrencyPresenterProtocol{
    
    
    weak var view: ExchangingCurrencyViewControllerProtocol?
    var exchangingCurrencyUseCase: ExchangingCurrencyUseCase?
    
    required init(view: ExchangingCurrencyViewControllerProtocol) {
        self.view = view
        exchangingCurrencyUseCase = Factory.getExchangingCurrencyUseCase()
        
    }
    
    func exchangeCurrency(amount: String, from: CurrencyType, to: CurrencyType) {
        if canChangeCurrency(amount: amount, from: from, to: to){
            self.view?.showProgressBar()
            
            exchangingCurrencyUseCase?.executeUseCase(requestValues: ExchangingCurrencyRequestValues(fromAmount: amount, fromCurrency: from.rawValue, toCurrency: to.rawValue), compilationHandler: { (exchangingCurrency, error) in
                self.view?.hideProgressBar()
                if let responseValue = exchangingCurrency as? ExchangingCurrencyResponseValues {
                    self.view?.updateReceivedAmount(with: responseValue.exchangingCurrency)
                }
            })
        } else {
            self.view?.hideProgressBar()
            self.view?.displayAlert(title: "Currency Can't Converted", message: "Please enter valid amount and make sure you have Balance of currency you want to convert fromand select different currencies.")
        }
    }
    
    func canChangeCurrency(amount: String, from: CurrencyType, to: CurrencyType) -> Bool {
        let fromBalance = UserDefaults.standard.double(forKey: from.rawValue)
        if let amount = Double(amount), amount > 0, fromBalance > 0, fromBalance >= amount, from != to {
            return true
        }
        return false
    }
}
