//
//  HTTPError.swift
//  FinnhubClient
//
//  Created by Fernando Pena on 1/25/22.
//

import Foundation


public enum HTTPError: Error, CustomStringConvertible {
    case cantFormRequest(String)
    case nonHTTPResponse
    case emptyResponse
    case serverError(Int)
    case networkError(Error)
    case decodingError(DecodingError)
    
    public var description: String {
        switch self {
        case .cantFormRequest(let urlString): return "Failed to generate url: \(urlString)"
        case .nonHTTPResponse: return "Response received is not HTTP"
        case .emptyResponse: return "Response received is empty"
        case .serverError(let statusCode): return "Request failed with code: \(statusCode)"
        case .networkError(let error): return "Request failed with error: \(error)"
        case .decodingError(let decodingError): return "Failed to decode response: \(decodingError)"
        }
    }
}
