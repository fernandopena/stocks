//
//  WatchlistTableViewController.swift
//  StocksUI
//
//  Created by Fernando Pena on 2/3/22.
//

import UIKit
import Combine

public class WatchlistTableViewController : UITableViewController {
    enum Section {
      case main
    }
    typealias DataSource = UITableViewDiffableDataSource<Section, StockRowViewModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, StockRowViewModel>

    private var subscriptions = Set<AnyCancellable>()
    public var viewModel: WatchlistViewModel!
    private lazy var dataSource = makeDataSource()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    private func setupBindings() {
        viewModel.$dataSource.sink { [weak self] rowViewModels in
            self?.applySnapshot(viewModels: rowViewModels)
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
    
    @IBAction func refresh() {
        viewModel.fetch()
        tableView.refreshControl?.endRefreshing()
    }
}
