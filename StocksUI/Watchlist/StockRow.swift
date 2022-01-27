//
//  StockRow.swift
//  Stocks
//
//  Created by Fernando Pena on 1/25/22.
//

import SwiftUI

struct StockRow: View {
    private let viewModel: StockRowViewModel
    
    init(viewModel: StockRowViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(viewModel.symbol)")
                Text("\(viewModel.time)")
                    .font(.footnote)
            }
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("\(viewModel.price)")
                    .font(.body)
                Text("\(viewModel.percentChange)")
                    .font(.footnote)
            }
        }
    }
}
struct StocksListRow_Previews: PreviewProvider {
    static var previews: some View {
        StockRow(viewModel: StockRowViewModel(symbol: "AAPL",
                                              price: "161.74",
                                              percentChange: "0.07 %",
                                              time: "12:10:43"))
    }
}
