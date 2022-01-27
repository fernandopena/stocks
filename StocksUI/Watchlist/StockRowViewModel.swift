//
//  StockRowViewModel.swift
//  Stocks
//
//  Created by Fernando Pena on 1/25/22.
//

import Foundation

struct StockRowViewModel: Identifiable {
    let id = UUID()
    let symbol: String
    let price: String
    let percentChange: String
    let time: String
}
