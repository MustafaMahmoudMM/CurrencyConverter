//
//  UseCase.swift
//  CurrencyConverter
//
//  Created by Mustafa Mahmoud on 17/09/2021.
//

import Foundation

protocol UseCase {
    func executeUseCase(requestValues: RequestValues, compilationHandler:@escaping (ResponseValues?,Error?) -> Void)
    
    
}

protocol RequestValues {
    
}


protocol ResponseValues {
    
}

struct GenricResponseValues: ResponseValues {
    let result: String
}
