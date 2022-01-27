//
//  WatchlistViewModel.swift
//  Stocks
//
//  Created by Fernando Pena on 1/24/22.
//

import Foundation
import StocksCore

public class WatchlistViewModel: ObservableObject {
    @Published var dataSource: [StockRowViewModel] = []
    @Published var error: Error?
    
    private let service: WatchlistService
    
    public init(service: WatchlistService) {
        self.service = service
        fetch()
    }
    
    
    func fetch() {
        service.getWatchlist { [weak self] result in
            switch result {
            case let .success(stocks):
                self?.dataSource = stocks.map(WatchlistPresenter.map)
            case let .failure(error):
                self?.error = error
            }
        }
    }
}
