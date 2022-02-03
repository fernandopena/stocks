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
        VStack {
            autorefreshView
            List {
                mainSection
            }
            .refreshable {
                viewModel.fetch()
            }
            .listStyle(PlainListStyle())
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
        .onAppear {
            viewModel.startAutorefresh()
         }
        .onDisappear {
            viewModel.stopAutorefresh()
        }
       
    }
}


private extension WatchlistView {
    var mainSection: some View {
        Section {
            if !viewModel.dataSource.isEmpty {
                stocksContent
            } else if !viewModel.isLoading {
                emptyContent
            }
        }
    }
    
    var stocksContent: some View {
        ForEach(viewModel.dataSource) {
            StockRow(viewModel: $0)
        }
    }
    
    var emptyContent: some View {
        Text("No results")
            .foregroundColor(.gray)
    }
    
    var autorefreshView: some View {
        AutorefreshView(isLoading: viewModel.isLoading,
                        remainingTime: viewModel.autorefreshRemainingTime)
            .frame(height: 20)
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


public struct AutorefreshView: View {
    var isLoading: Bool
    var remainingTime: Int

    public var body: some View {
        ZStack(alignment: .center) {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else if remainingTime > 0 {
                Text("Updates in: \(remainingTime)")
                    .foregroundColor(.gray)
                    .font(.footnote)
            }
        }
    }
}
