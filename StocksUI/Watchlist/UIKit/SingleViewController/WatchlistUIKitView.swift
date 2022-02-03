//
//  WatchlistUIKitView.swift
//  StocksUI
//
//  Created by Fernando Pena on 1/31/22.
//

import SwiftUI

public struct WatchlistUIKitView: UIViewControllerRepresentable {
    public typealias UIViewControllerType = WatchlistViewController
    @ObservedObject var viewModel: WatchlistViewModel

    public init(viewModel: WatchlistViewModel) {
        self.viewModel = viewModel
    }

    public func makeUIViewController(context: Context) -> WatchlistViewController {
        let storyboard = UIStoryboard(name: "Watchlist", bundle: Bundle(for: WatchlistViewController.self))
        let watchlistVC = storyboard.instantiateViewController(identifier: "WatchlistViewController") as! WatchlistViewController
        watchlistVC.viewModel = viewModel
        return watchlistVC
    }
    
    public func updateUIViewController(_ uiViewController: WatchlistViewController, context: Context) {
        
    }
}

