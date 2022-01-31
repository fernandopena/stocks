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
    
    @Environment(\.scenePhase) var scenePhase
    
    public var body: some View {
        List {
            autorefreshSection
            if !viewModel.dataSource.isEmpty {
                stocksSection
            } else if !viewModel.isLoading {
                emptySection
            }
        }
        .refreshable {
            viewModel.fetch()
        }
        .listStyle(PlainListStyle())
        .navigationTitle("Watchlist")
        .navigationBarTitleDisplayMode(.inline)
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
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                viewModel.startAutorefresh()
            } else {
                viewModel.stopAutorefresh()
            }
        }
    }
}


private extension WatchlistView {
    var autorefreshSection: some View {
        Section(header: autorefreshHeader) {}
    }
    
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
    
    var autorefreshHeader: some View {
        ZStack(alignment: .center) {
            Color(.clear)
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else if viewModel.autorefreshRemainingTime > 0 {
                Text("Updates in: \(viewModel.autorefreshRemainingTime)")
            }
        }
        .frame(height: 20)

    }
    
    var autorefreshView: some View {
        ZStack(alignment: .center) {
            Color(.systemGroupedBackground)
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else if viewModel.autorefreshRemainingTime > 0 {
                Text("Updates in: \(viewModel.autorefreshRemainingTime)")
                    .padding(.vertical, 5)
            }
        }
        .frame(height: 40)
    }
}



struct WatchlistView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WatchlistView(viewModel: WatchlistViewModel(service: WatchlistServiceMock()))
        }
        .previewInterfaceOrientation(.portraitUpsideDown)
    }
}
