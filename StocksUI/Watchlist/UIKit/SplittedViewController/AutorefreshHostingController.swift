//
//  AutorefreshHostingController.swift
//  StocksUI
//
//  Created by Fernando Pena on 2/3/22.
//

import UIKit
import SwiftUI


class AutorefreshHostingController: UIHostingController<AutorefreshView> {

    required init?(coder: NSCoder) {
        super.init(coder: coder,rootView: AutorefreshView(isLoading: false, remainingTime: 0));
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
