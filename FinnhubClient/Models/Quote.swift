//
//  Quote.swift
//  FinnhubClient
//
//  Created by Fernando Pena on 1/25/22.
//

import Foundation

public struct Quote: Decodable {
    public let current: Double
    public let change: Double
    public let percentChange: Double
    public let high: Double
    public let low: Double
    public let open: Double
    public let previousClose: Double
    public let timestamp: Int
    
    private enum CodingKeys: String, CodingKey {
        case current = "c"
        case change = "d"
        case percentChange = "dp"
        case high = "h"
        case low = "l"
        case open = "o"
        case previousClose = "pc"
        case timestamp = "t"
    }
}


