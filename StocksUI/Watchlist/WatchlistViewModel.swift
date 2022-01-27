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
    @Published var isLoading: Bool
    @Published var errorMessage: String?
    @Published var lastUpdate: Date

    private let service: WatchlistService

    public init(service: WatchlistService) {
        self.service = service
        self.isLoading = false
        self.lastUpdate = Date.distantPast
        fetch()
    }
    
    
    struct TestError: Error {}
    func fetch() {
        self.isLoading = true
        service.getWatchlist { [weak self] result in
            switch result {
            case let .success(stocks):
                self?.dataSource = stocks.map(WatchlistPresenter.map)
                self?.lastUpdate = Date()
            case let .failure(error):
                self?.errorMessage = error.localizedDescription
            }
            self?.isLoading = false
        }
    }
}
