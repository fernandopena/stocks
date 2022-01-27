//
//  StocksApp.swift
//  Stocks
//
//  Created by Fernando Pena on 1/24/22.
//

import SwiftUI
import StocksCore
import StocksUI

@main
struct StocksApp: App {
    
    let viewModel: WatchlistViewModel

    init() {
        let service = WatchlistProvider(symbolsService: WatchlistSymbolsServiceMock(), quoteService: QuotesServiceRandomFailure())
        self.viewModel = WatchlistViewModel(service: service)
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                WatchlistView(viewModel: viewModel)
            }
        }
    }
}
