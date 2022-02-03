//
//  WatchlistContainerViewController.swift
//  StocksUI
//
//  Created by Fernando Pena on 2/3/22.
//

import UIKit
import Combine
import SwiftUI

public class WatchlistContainerViewController : UIViewController {
    public var viewModel: WatchlistViewModel!
    private var autorefreshHostingController: AutorefreshHostingController!

    private var subscriptions = Set<AnyCancellable>()

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.startAutorefresh()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopAutorefresh()
    }
    
    private func setupBindings() {
        viewModel.$errorMessage.sink{ [weak self] errorMessage in
            if errorMessage != nil {
                self?.displayViewModelErrorAlert()
            }
        }.store(in: &subscriptions)
        
        viewModel.$isLoading.sink { [weak self] isLoading in
            self?.autorefreshHostingController.rootView = AutorefreshView(isLoading: isLoading, remainingTime: self?.viewModel.autorefreshRemainingTime ?? 0)
        }.store(in: &subscriptions)
        
        viewModel.$autorefreshRemainingTime.sink { [weak self] remainingTime in
            self?.autorefreshHostingController.rootView = AutorefreshView(isLoading: self?.viewModel.isLoading ?? false, remainingTime: remainingTime)
        }.store(in: &subscriptions)
    }
    
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "tableViewSegue",
           let watchlistTVC = segue.destination as? WatchlistTableViewController {
               watchlistTVC.viewModel = viewModel
        } else if segue.identifier == "autorefreshViewSegue",
            let autorefreshHC = segue.destination as? AutorefreshHostingController {
            autorefreshHostingController = autorefreshHC
        }
    }
    
    private func displayViewModelErrorAlert() {
        let alert = UIAlertController(title: "Unable to load watchlist",
                                      message: viewModel.errorMessage,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { action in
            self.viewModel.fetch()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

    
