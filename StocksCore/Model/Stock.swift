//
//  Stock.swift
//  Stocks
//
//  Created by Fernando Pena on 1/26/22.
//

import Foundation

public struct Stock {
    public let symbol: String
    public let quote: StockQuote?
    
    public init(symbol: String, quote: StockQuote?) {
        self.symbol = symbol
        self.quote = quote
    }
}

public struct StockQuote {
    public let current: Double
    public let change: Double
    public let percentChange: Double
    public let high: Double
    public let low: Double
    public let open: Double
    public let previousClose: Double
    public let date: Date
    
    public init(current: Double, change: Double, percentChange: Double, high: Double, low: Double, open: Double, previousClose: Double, date: Date) {
        self.current = current
        self.change = change
        self.percentChange = percentChange
        self.high = high
        self.low = low
        self.open = open
        self.previousClose = previousClose
        self.date = date
    }
}


