//
//  Watchlist+DevHelpers.swift.swift
//  Stocks
//
//  Created by Fernando Pena on 1/26/22.
//

import Foundation

public struct WatchlistServiceMock: WatchlistService {
    public init() {}
    public func getWatchlist(completion: @escaping (Result<[Stock], Error>) -> Void) {
        completion(.success(Stock.mockedStocks))
    }
}


public struct QuotesServiceMock: QuoteService {
    public init() {}
    public func getQuote(symbol: String, completion: @escaping (Result<StockQuote, Error>) -> Void) {
        completion(.success(StockQuote.randomQuote(symbol: symbol)))
    }
}

struct AnyError: Error {}

public struct QuotesServiceRandomFailure: QuoteService {
    public init() {}
    public func getQuote(symbol: String, completion: @escaping (Result<StockQuote, Error>) -> Void) {
        if Bool.random() {
            completion(.success(StockQuote.randomQuote(symbol: symbol)))
        } else {
            completion(.failure(AnyError()))
        }
    }
}

public struct WatchlistSymbolsServiceMock: WatchlistSymbolsService {
    public init() {}
    public func getWatchlistSymbols(completion: @escaping (Result<[String], Error>) -> Void) {
        completion(.success(["AAPL", "MSFT", "GOOG"]))
    }
}

private extension StockQuote {
    static func randomQuote(symbol: String) -> StockQuote {
        var price = 100.0
        if (symbol == "AAPL") {
            price = 160.0
        } else if (symbol == "MSFT") {
            price = 290.0
        } else if (symbol == "GOOG") {
            price = 2500.0
        }
        return randomQuote(price: price)
    }
    
    static func randomQuote(price: Double) -> StockQuote {
        let previousClose = price
        let percentChange = Double.random(in: -0.1 ..< 0.1)
        let change = percentChange * previousClose
        let current = previousClose+change
        let high = previousClose + Double.random(in: 0.0 ..< 5.0)
        let low = previousClose + Double.random(in: -5.0 ..< 0.0)
        return StockQuote(current: current,
                          change: change,
                          percentChange: percentChange,
                          high: high,
                          low: low,
                          open: previousClose,
                          previousClose: previousClose,
                          date: Date())
    }
}


private extension Stock {
    static var mockedStock: Stock {
        Stock(symbol: "AAPL",
              quote: StockQuote(current: 161.74,
                                change: 0.12,
                                percentChange: 0.0742,
                                high: 161.76,
                                low: 157.02,
                                open: 158.98,
                                previousClose: 161.62,
                                date: Date(timeIntervalSince1970: TimeInterval(1643138991))))
    }
    
    static var mockedStocks: [Stock] {
        [Stock(symbol: "AAPL",
               quote: StockQuote(current: 161.74,
                                 change: 0.12,
                                 percentChange: 0.0742,
                                 high: 161.76,
                                 low: 157.02,
                                 open: 158.98,
                                 previousClose: 161.62,
                                 date: Date(timeIntervalSince1970: TimeInterval(1643138991)))),
         Stock(symbol: "MSFT",
               quote: StockQuote(current: 288.49,
                                 change: -7.88,
                                 percentChange: -2.6588,
                                 high: 294.99,
                                 low: 285.185,
                                 open: 291.52,
                                 previousClose: 296.37,
                                 date: Date(timeIntervalSince1970: TimeInterval(1643144403)))),
         Stock(symbol: "GOOG",
               quote: StockQuote(current: 2534.71,
                                 change: -72.73,
                                 percentChange: -2.7893,
                                 high: 2586.77,
                                 low: 2527.56,
                                 open: 2568.71,
                                 previousClose: 2607.44,
                                 date: Date(timeIntervalSince1970: TimeInterval(1643144403))))
         
        ]
    }
}

