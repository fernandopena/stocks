//
//  FinnhubClient+Quote.swift
//  FinnhubClient
//
//  Created by Fernando Pena on 1/25/22.
//

import Foundation
import UIKit

extension FinnhubClient {
    public func getQuote(symbol: String, completion: @escaping (Result<Quote, HTTPError>) -> Void) {
        httpClient.request(components: makeQuotesComponents(symbol: symbol), mapper: QuoteMapper(), completion: completion)
    }
    
    private func makeQuotesComponents(symbol: String
    ) -> URLComponents {
        var components = URLComponents()
        components.scheme = FinnhubClient.scheme
        components.host = FinnhubClient.host
        components.path = FinnhubClient.path + "/quote"
        
        components.queryItems = [
            URLQueryItem(name: "symbol", value: symbol),
            URLQueryItem(name: "token", value: FinnhubClient.key)
        ]
        
        return components
    }
}


private final class QuoteMapper: JSONMapper {
    typealias Model = Quote
    
    var serverOKCodes: [Int] { [200] }
    
    var jsonDecoder: JSONDecoder { JSONDecoder() }
}
