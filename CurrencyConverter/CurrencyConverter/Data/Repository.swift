//
//  Repository.swift
//  CurrencyConverter
//
//  Created by Mustafa Mahmoud on 17/09/2021.
//

import Foundation

protocol Repository {
    
    func getData(requestValue: RequestValues, compilationHandler:@escaping (ResponseValues?,Error?) -> Void)
}
