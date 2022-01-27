//
//  WatchlistService.swift
//  Stocks
//
//  Created by Fernando Pena on 1/24/22.
//

import Foundation

public protocol WatchlistService {
    func getWatchlist(completion: @escaping (Result<[Stock], Error>) -> Void)
}


public protocol WatchlistSymbolsService {
    func getWatchlistSymbols(completion: @escaping (Result<[String], Error>) -> Void)
}


public protocol QuoteService {
    func getQuote(symbol: String, completion: @escaping (Result<StockQuote, Error>) -> Void)
}
