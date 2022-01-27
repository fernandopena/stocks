//
//  FinnhubClient.swift
//  FinnhubClient
//
//  Created by Fernando Pena on 1/24/22.
//

import Foundation

public struct FinnhubClient {
    static let scheme = "https"
    static let host = "finnhub.io"
    static let path = "/api/v1"
    static let key = "c7nbbn2ad3ifj5l0aq9g"
    
    let httpClient: HTTPClient
    
    public init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
}
