//
//  APIClient.swift
//  CurrencyConverter
//
//  Created by Mustafa Mahmoud on 17/09/2021.
//

import Foundation

protocol APIClient{
    
    func executeGetRequest(url:String,parameters: [String:Any]?,header : [String:String]?,compilationHandler:@escaping (Any?,Error?) -> Void)
}
