//
//  WatchlistProvider.swift
//  Stocks
//
//  Created by Fernando Pena on 1/26/22.
//

import Foundation

public class WatchlistProvider: WatchlistService {
    static let blockedRefreshInterval = 10.0 //seconds
    let symbolsService: WatchlistSymbolsService
    let quoteService: QuoteService
    var stocks: [Stock]

    
    public init(symbolsService: WatchlistSymbolsService, quoteService: QuoteService) {
        self.symbolsService = symbolsService
        self.quoteService = quoteService
        self.stocks = []
    }
    
    public func getWatchlist(completion: @escaping (Result<[Stock], Error>) -> Void) {
        if stocks.isEmpty {
            symbolsService.getWatchlistSymbols { [weak self] result in
                switch result {
                case let .success(symbols):
                    self?.stocks = symbols.map{ Stock(symbol: $0, quote: nil) }
                    self?.loadQuotes(stocks: self?.stocks ?? [], completion: completion)
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        } else {
            self.loadQuotes(stocks: stocks, completion: completion)
        }
    }
    
    func loadQuotes(stocks: [Stock], completion: @escaping (Result<[Stock], Error>) -> Void) {
        var mutableStocks = stocks
        let now = Date()
        let group = DispatchGroup()
        for stock in stocks {
            if (stock.quote?.needsRefresh(now: now) ?? true) {
                group.enter()
                quoteService.getQuote(symbol: stock.symbol) { result in
                    switch result {
                    case let .success(quote):
                        if let index = mutableStocks.firstIndex(where: { $0.symbol == stock.symbol }) {
                            mutableStocks[index] = Stock(symbol: stock.symbol, quote: quote)
                        }
                    case .failure(_):
                        break
                    }
                    group.leave()
                }
            }
        }
        group.notify(queue: .main) {
            self.stocks = mutableStocks
            completion(.success(self.stocks))
        }
    }
}


private extension StockQuote {
    func needsRefresh(now: Date) -> Bool {
        let interval = now.timeIntervalSince(self.date)
        return interval > WatchlistProvider.blockedRefreshInterval
    }
}
