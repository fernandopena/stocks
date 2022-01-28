//
//  WatchlistViewModel.swift
//  Stocks
//
//  Created by Fernando Pena on 1/24/22.
//

import Foundation
import Combine
import StocksCore

public class WatchlistViewModel: ObservableObject {
    @Published private (set) var dataSource: [StockRowViewModel] = []
    @Published private (set) var isLoading: Bool
    @Published var errorMessage: String?
    @Published private (set) var autorefreshRemainingTime: Int

    private static let autorefreshInterval: Int = 60
    private let service: WatchlistService
    private var lastUpdate: Date
    private var countdownTimer: CountdownTimer?
    private var subscribers = [AnyCancellable]()

    public init(service: WatchlistService) {
        self.service = service
        self.isLoading = false
        self.lastUpdate = Date.distantPast
        self.autorefreshRemainingTime = WatchlistViewModel.autorefreshInterval
        setupCountdownTimer()
    }
    
    private func setupCountdownTimer() {
        self.countdownTimer = CountdownTimer(interval: WatchlistViewModel.autorefreshInterval, block: { [weak self] in
            self?.fetch()
        })
        countdownTimer?.$timeRemaining
               .assign(to: \.autorefreshRemainingTime, on: self)
               .store(in: &subscribers)
    }
    
    func stopAutorefresh() {
        self.countdownTimer?.pause()
    }
    
    func startAutorefresh() {
        self.countdownTimer?.start(lastFired: self.lastUpdate)
    }
    
    func fetch() {
        self.isLoading = true
        service.getWatchlist { [weak self] result in
            if let self = self {
                switch result {
                case let .success(stocks):
                    self.dataSource = stocks.map(WatchlistPresenter.map)
                    self.lastUpdate = Date()
                    self.countdownTimer?.start(lastFired: self.lastUpdate)
                case let .failure(error):
                    self.errorMessage = error.localizedDescription
                }
                self.isLoading = false
            }
        }
    }
}
