//
//  HTTPClient.swift
//  FinnhubClient
//
//  Created by Fernando Pena on 1/24/22.
//

import Foundation

public class HTTPClient {
    private let session: URLSession
    
    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func request<Model, Mapper: JSONMapper>(components: URLComponents,
                                            mapper: Mapper,
                                            completion: @escaping (Result<Model, HTTPError>) -> Void) where Mapper.Model == Model {
        guard let url = components.url else {
            return completion(.failure(HTTPError.cantFormRequest(components.description)))
        }
        let task = session.dataTask(with: URLRequest(url: url)) { data, urlResponse, responseError in
            do {
                if let responseError = responseError {
                    throw HTTPError.networkError(responseError)
                }
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    throw HTTPError.nonHTTPResponse
                }
                guard let data = data else {
                    throw HTTPError.emptyResponse
                }
                let result = mapper.map(data, from: httpResponse) as Result<Model, HTTPError>
                return completion(result)
            } catch {
                if let httpError = error as? HTTPError {
                    return completion(.failure(httpError))
                } else if let decodingError = error as? DecodingError {
                    return completion(.failure(HTTPError.decodingError(decodingError)))
                } else {
                    return completion(.failure(HTTPError.networkError(error)))
                }
            }
        }
        task.resume()
    }
}

