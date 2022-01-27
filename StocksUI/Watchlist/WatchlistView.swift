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
    
    public var body: some View {
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
        WatchlistView(viewModel: WatchlistViewModel(service: WatchlistServiceMock()))
    }
}
