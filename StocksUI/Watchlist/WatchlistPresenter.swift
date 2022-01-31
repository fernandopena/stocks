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
        var changeState = StockRowViewModel.ChangeState.neutral

        if let quote = stock.quote {
            price = String(format: "%.2f", quote.current)
            changeState = StockRowViewModel.changeState(change: quote.percentChange)
            percentChange = String(format: "\(changeState.indicator) %.2f%%", abs(quote.percentChange))
        }
        return StockRowViewModel(symbol: stock.symbol,
                                 price: price,
                                 percentChange:percentChange,
                                 changeState: changeState)
    }
}

