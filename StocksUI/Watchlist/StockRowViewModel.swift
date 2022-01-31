//
//  StockRowViewModel.swift
//  Stocks
//
//  Created by Fernando Pena on 1/25/22.
//

import Foundation


struct StockRowViewModel: Identifiable {
    enum ChangeState {
        case neutral
        case negative
        case positive
    }

    let id = UUID()
    let symbol: String
    let price: String
    let percentChange: String
    let changeState: ChangeState
}

extension StockRowViewModel {
    static func changeState(change: Double) -> ChangeState {
        if change > 0 {
            return .positive
        } else if change < 0 {
            return .negative
        } else {
            return .neutral
        }
    }
}



extension StockRowViewModel.ChangeState {
    var indicator: String {
        switch self {
        case .neutral: return ""
        case .negative: return "▼"
        case .positive: return "▲"
        }
    }
}
