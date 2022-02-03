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
            TabView {
                NavigationView {
                    WatchlistUIKitView(viewModel: viewModel)
                        .navigationTitle("Watchlist UIKit")
                        .navigationBarTitleDisplayMode(.inline)
                }
                .tabItem {
                    Image(systemName: "iphone")
                    Text("UIKit")
                }
                NavigationView {
                    WatchlistContainerUIKitView(viewModel: viewModel)
                        .navigationTitle("Watchlist UIKit 2")
                        .navigationBarTitleDisplayMode(.inline)
                }
                .tabItem {
                    Image(systemName: "iphone")
                    Text("UIKit 2")
                }
                NavigationView {
                    WatchlistView(viewModel: viewModel)
                        .navigationTitle("Watchlist SwiftUI")
                        .navigationBarTitleDisplayMode(.inline)
                }
                .tabItem {
                    Image(systemName: "swift")
                    Text("SwiftUI")
                }
            }
            
        }
    }
}
