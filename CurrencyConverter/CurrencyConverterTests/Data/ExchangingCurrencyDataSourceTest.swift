//
//  ExchangingCurrencyDataSourceTest.swift
//  CurrencyConverterTests
//
//  Created by Mustafa Mahmoud on 28/12/2022.
//

import XCTest

@testable import CurrencyConverter
class ExchangingCurrencyDataSourceTest: XCTestCase {
    var exchangingCurrencyRemoteDataSource: ExchangingCurrencyRemoteDataSource!
    var exchangingCurrencyRemoteDataSourceMockSuccess: ExchangingCurrencyRemoteDataSourceMock!
    var exchangingCurrencyRemoteDataSourceMockFailure: ExchangingCurrencyRemoteDataSourceMock!
    override func setUp() {
        exchangingCurrencyRemoteDataSource = ExchangingCurrencyRemoteDataSource.sharedInstance
        exchangingCurrencyRemoteDataSourceMockSuccess = ExchangingCurrencyRemoteDataSourceMock(expectedResult: .success)
        exchangingCurrencyRemoteDataSourceMockFailure = ExchangingCurrencyRemoteDataSourceMock(expectedResult: .failure)
    }
    
    override func tearDown() {
        exchangingCurrencyRemoteDataSource = nil
    }
    
    func testExchangingCurrencyRemoteDataSource() {
        exchangingCurrencyRemoteDataSource.exchangingCurrency(requestValue: ExchangingCurrencyRequestValues(fromAmount: "50", fromCurrency: CurrencyType.eur.rawValue, toCurrency: CurrencyType.usd.rawValue), compilationHandler: { (data, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(data)
        })
    }
    
    func testExchangingCurrencyRemoteDataSourceSuccess() {
        exchangingCurrencyRemoteDataSourceMockSuccess.exchangingCurrency(requestValue: ExchangingCurrencyRequestValues(fromAmount: "50", fromCurrency: CurrencyType.eur.rawValue, toCurrency: CurrencyType.usd.rawValue), compilationHandler: { (data, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(data)
        })
    }
    
    func testExchangingCurrencyRemoteDataSourceFailure() {
        exchangingCurrencyRemoteDataSourceMockFailure.exchangingCurrency(requestValue: ExchangingCurrencyRequestValues(fromAmount: "50", fromCurrency: CurrencyType.eur.rawValue, toCurrency: CurrencyType.usd.rawValue), compilationHandler: { (data, error) in
            XCTAssertNotNil(error)
            XCTAssertNil(data)
        })
    }
}

class ExchangingCurrencyRemoteDataSourceMock: ExchangingCurrencyDataSource {

    enum ExpectedResult {
        case success
        case failure
    }

    let expectedResult: ExpectedResult

    init(expectedResult: ExpectedResult) {
        self.expectedResult = expectedResult
    }

    func exchangingCurrency(requestValue: RequestValues,compilationHandler:@escaping (Any?,Error?) -> Void) {
        let apiClient = URLSessionClient.sharedInstance
        switch self.expectedResult {
        case .success:
            let exchangingRequestValues = requestValue as? ExchangingCurrencyRequestValues
            let url = "http://api.evp.lt/currency/commercial/exchange/\(exchangingRequestValues?.fromAmount ?? "0.0")-\(exchangingRequestValues?.fromCurrency ?? "")/\(exchangingRequestValues?.toCurrency ?? "")/latest"
            
            var headers: [String : String] = [:]
            headers["Content-type"] = "application/json"
            
            apiClient.executeGetRequest(url: url, parameters: nil, header: headers, compilationHandler: compilationHandler)
        case .failure:
            let url = "https://www.google.com"
            
            var headers: [String : String] = [:]
            headers["Content-type"] = "application/json"
            
            apiClient.executeGetRequest(url: url, parameters: nil, header: headers, compilationHandler: compilationHandler)
        }
    }
}
