//
//  WatchlistView.swift
//  Stocks
//
//  Created by Fernando Pena on 1/24/22.
//

import SwiftUI
import StocksCore

public struct WatchlistView: View {
    @ObservedObject var viewModel: WatchlistViewModel
    
    public init(viewModel: WatchlistViewModel) {
        self.viewModel = viewModel
    }
    
    private static let autorefreshInterval: Int = 60
    @Environment(\.scenePhase) var scenePhase
    @State private var timeRemaining = WatchlistView.autorefreshInterval
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func recalculateCountdown(lastUpdate: Date) {
        let timeIntervalSinceLastUpdate = -lastUpdate.timeIntervalSinceNow
        timeRemaining = WatchlistView.autorefreshInterval - Int(timeIntervalSinceLastUpdate)
    }
    
    func fetchIfRequired() {
        if timeRemaining < 0 {
            viewModel.fetch()
        }
    }
    
    public var body: some View {
        VStack() {
            List {
                if viewModel.dataSource.isEmpty {
                    emptySection
                } else {
                    stocksSection
                }
            }
            .refreshable {
                viewModel.fetch()
            }
            .listStyle(GroupedListStyle())
            if self.viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else if timeRemaining > 0 {
                Text("Updates in: \(timeRemaining)")
                    .padding(.bottom, 5)
            }
        }
        .alert(isPresented: Binding<Bool>(
            get: { viewModel.errorMessage != nil },
            set: { _ in viewModel.errorMessage = nil }
        ), content: {
            Alert(
                title: Text("Unable to load watchlist"),
                message: Text(viewModel.errorMessage ?? ""),
                primaryButton: .default(Text("Retry"), action: {
                    self.viewModel.fetch()
                }),
                secondaryButton: .cancel()
            )
        })
        .onReceive(timer) { time in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else if timeRemaining == 0 {
                self.viewModel.fetch()
                timeRemaining -= 1
            }
        }
        .onReceive(viewModel.$lastUpdate, perform: { date in
            recalculateCountdown(lastUpdate: date)
        })
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                recalculateCountdown(lastUpdate: viewModel.lastUpdate)
                fetchIfRequired()
            }
        }.navigationTitle("Watchlist")
    }
}


private extension WatchlistView {
    var stocksSection: some View {
        Section {
            ForEach(viewModel.dataSource) {
                StockRow(viewModel: $0)
            }
        }
    }
    
    var emptySection: some View {
        Section {
            Text("No results")
                .foregroundColor(.gray)
        }
    }
}


struct WatchlistView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WatchlistView(viewModel: WatchlistViewModel(service: WatchlistServiceMock()))
        }
    }
}
