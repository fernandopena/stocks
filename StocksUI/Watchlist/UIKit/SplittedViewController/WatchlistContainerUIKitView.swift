//
//  WatchlistContainerUIKitView.swift
//  StocksUI
//
//  Created by Fernando Pena on 2/3/22.
//

import UIKit
import SwiftUI

public struct WatchlistContainerUIKitView: UIViewControllerRepresentable {
    public typealias UIViewControllerType = WatchlistContainerViewController
    @ObservedObject var viewModel: WatchlistViewModel

    public init(viewModel: WatchlistViewModel) {
        self.viewModel = viewModel
    }

    public func makeUIViewController(context: Context) -> WatchlistContainerViewController {
        let storyboard = UIStoryboard(name: "SplittedWatchlist", bundle: Bundle(for: WatchlistViewController.self))
        let watchlistVC = storyboard.instantiateViewController(identifier: "WatchlistContainerViewController") as! WatchlistContainerViewController
        watchlistVC.viewModel = viewModel
        return watchlistVC
    }
    
    public func updateUIViewController(_ uiViewController: WatchlistContainerViewController, context: Context) {
        
    }
}
