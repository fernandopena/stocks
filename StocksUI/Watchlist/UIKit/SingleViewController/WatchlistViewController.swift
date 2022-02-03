//
//  WatchlistViewController.swift
//  StocksUI
//
//  Created by Fernando Pena on 1/31/22.
//

import UIKit
import Combine
import SwiftUI

public class WatchlistViewController : UIViewController {
    enum Section {
      case main
    }
    typealias DataSource = UITableViewDiffableDataSource<Section, StockRowViewModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, StockRowViewModel>
    
    @IBOutlet weak var tableView: UITableView!

    private var subscriptions = Set<AnyCancellable>()
    public var viewModel: WatchlistViewModel!
    private lazy var dataSource = makeDataSource()
    @IBOutlet weak var autorefreshContainer: UIView!
    private var autorefreshHostingController: UIHostingController<AutorefreshView>!

    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
    
    private func setupUI() {
        addRefreshControl()
        addAutorefreshView()
    }
    
    private func addRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        tableView?.refreshControl = refreshControl
    }
    
    private func addAutorefreshView() {
        let autorefreshView = AutorefreshView(isLoading: viewModel.isLoading,
                                          remainingTime: viewModel.autorefreshRemainingTime)
        
        autorefreshHostingController = UIHostingController(rootView: autorefreshView)
        addChild(autorefreshHostingController)
        autorefreshHostingController.view.translatesAutoresizingMaskIntoConstraints = false
        autorefreshContainer.addSubview(autorefreshHostingController.view)
        autorefreshHostingController.didMove(toParent: self)
        NSLayoutConstraint.activate([
            autorefreshHostingController.view.leadingAnchor.constraint(equalTo: autorefreshContainer.leadingAnchor, constant: 0),
            autorefreshHostingController.view.trailingAnchor.constraint(equalTo: autorefreshContainer.trailingAnchor, constant: 0),
            autorefreshHostingController.view.topAnchor.constraint(equalTo: autorefreshContainer.topAnchor, constant: 0),
            autorefreshHostingController.view.bottomAnchor.constraint(equalTo: autorefreshContainer.bottomAnchor, constant: 0)
        ])
    }
    
    
    private func setupBindings() {
        viewModel.$errorMessage.sink{ [weak self] errorMessage in
            if errorMessage != nil {
                self?.displayViewModelErrorAlert()
            }
        }.store(in: &subscriptions)
        
        viewModel.$dataSource.sink { [weak self] rowViewModels in
            self?.applySnapshot(viewModels: rowViewModels)            
        }.store(in: &subscriptions)
        
        viewModel.$isLoading.sink { [weak self] isLoading in
            self?.autorefreshHostingController.rootView = AutorefreshView(isLoading: isLoading, remainingTime: self?.viewModel.autorefreshRemainingTime ?? 0)
        }.store(in: &subscriptions)

        viewModel.$autorefreshRemainingTime.sink { [weak self] remainingTime in
            self?.autorefreshHostingController.rootView = AutorefreshView(isLoading: self?.viewModel.isLoading ?? false, remainingTime: remainingTime)
        }.store(in: &subscriptions)
    }
    
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(tableView: tableView) { tableView, indexPath, rowViewModel in
            let cell = tableView.dequeueReusableCell(withIdentifier: "StockCell", for: indexPath) as? StockCell
            cell?.setup(viewModel: rowViewModel)
            return cell
        }
        return dataSource
    }
    
    func applySnapshot(viewModels: [StockRowViewModel], animatingDifferences: Bool = false) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModels)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    @objc func refresh() {
        viewModel.fetch()
        tableView.refreshControl?.endRefreshing()
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
