//
//  JSONMapper.swift
//  FinnhubClient
//
//  Created by Fernando Pena on 1/25/22.
//

import Foundation

protocol JSONMapper {
    associatedtype Model: Decodable
    var serverOKCodes: [Int] { get }
    var jsonDecoder: JSONDecoder { get }
    func map(_ data: Data, from response: HTTPURLResponse) -> Result<Model, HTTPError>
}


extension JSONMapper {
    func map(_ data: Data, from response: HTTPURLResponse) -> Result<Quote, HTTPError> {
        guard serverOKCodes.contains(response.statusCode) else {
            return .failure(HTTPError.serverError(response.statusCode))
        }
        do {
            let mappedResponse = try jsonDecoder.decode(Quote.self, from: data)
            return .success(mappedResponse)
        } catch let decodingError as DecodingError {
            return .failure(HTTPError.decodingError(decodingError))
        } catch {
            return .failure(HTTPError.networkError(error))
        }
    }
}
