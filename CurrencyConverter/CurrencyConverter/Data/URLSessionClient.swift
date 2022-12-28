//
//  URLSessionClient.swift
//  CurrencyConverter
//
//  Created by Mustafa Mahmoud on 17/09/2021.
//

import Foundation

struct URLSessionClient: APIClient {
    
    //MARK: Shared Instance
    
    static let sharedInstance =  URLSessionClient()
    
    fileprivate init() {
        
    }
    
    
    func executeGetRequest(url:String,parameters: [String:Any]?,header : [String:String]?,compilationHandler:@escaping (Any?,Error?) -> Void){
        
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            compilationHandler(data,error)
            }.resume()
    }
}
