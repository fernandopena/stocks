//
//  WatchlistPresenter.swift
//  Stocks
//
//  Created by Fernando Pena on 1/26/22.
//

import Foundation
import StocksCore

final class WatchlistPresenter {
    static func map(_ stock: Stock) -> StockRowViewModel {
        var price = "-"
        var percentChange = "-"
        var time = "--:--:--"

        if let quote = stock.quote {
            price = String(format: "%.2f", quote.current)
            percentChange = String(format: "%.2f %", quote.percentChange)
            time = hour(from: quote.date)
        }
        return StockRowViewModel(symbol: stock.symbol,
                                 price: price,
                                 percentChange:percentChange,
                                 time:time)
    }
    
    static func hour(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.string(from: date)
    }

}

