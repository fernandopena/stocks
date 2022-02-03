//
//  StockCell.swift
//  StocksUI
//
//  Created by Fernando Pena on 2/3/22.
//

import UIKit

public class StockCell : UITableViewCell {
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var percentChangeLabel: UILabel!
}


extension StockCell {
    func setup(viewModel: StockRowViewModel) {
        self.symbolLabel.text = viewModel.symbol
        self.priceLabel.text = viewModel.price
        self.percentChangeLabel.text = viewModel.percentChange
        self.percentChangeLabel.textColor = UIColor(viewModel.changeState.color)
    }
}
