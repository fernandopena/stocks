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
            Text("\(viewModel.symbol)")
                .font(.headline)
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("\(viewModel.price)")
                    .font(.subheadline)
                Text("\(viewModel.percentChange)")
                    .font(.footnote)
                    .foregroundColor(viewModel.changeState.color)
            }
        }
    }
}
struct StocksListRow_Previews: PreviewProvider {
    static var previews: some View {
        StockRow(viewModel: StockRowViewModel(symbol: "AAPL",
                                              price: "161.74",
                                              percentChange: "▲ 0.07%",
                                              changeState: .positive))
    }
}


private extension StockRowViewModel.ChangeState {
    var color: Color {
        switch self {
        case .neutral: return .black
        case .negative: return .red
        case .positive: return .green
        }
    }
}
 
