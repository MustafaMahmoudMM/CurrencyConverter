//
//  CurrencyExchangeContract.swift
//  CurrencyConverter
//
//  Created by Mustafa Mahmoud on 17/09/2021.
//

import Foundation

protocol ExchangingCurrencyPresenterProtocol: AnyObject {
    
    func exchangeCurrency(amount: String, from: CurrencyType, to: CurrencyType)
}

protocol ExchangingCurrencyViewControllerProtocol: AnyObject {
    
    func updateReceivedAmount(with exchangeCurrencyModel: ExchangingCurrencyModel)
    func displayAlert(title: String, message: String)
    func showProgressBar()
    func hideProgressBar()
    
}
