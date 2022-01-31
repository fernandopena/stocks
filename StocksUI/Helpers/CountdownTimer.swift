//
//  CountdownTimer.swift
//  StocksUI
//
//  Created by Fernando Pena on 1/28/22.
//

import Foundation

public class CountdownTimer: ObservableObject {
    private var timer: Timer?
    private let interval: Int
    private let repeats: Bool
    @Published private(set) var timeRemaining: Int

    let block: () -> Void

    public init(interval: Int, repeats: Bool = true, block: @escaping () -> Void) {
        self.interval = interval
        self.repeats = repeats
        self.timeRemaining = interval
        self.block = block
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer() {
        if timeRemaining != 0 {
            timeRemaining -= 1
        } else {
            block()
            if let timer = self.timer {
                if !self.repeats {
                    timer.invalidate()
                } else {
                    timeRemaining = interval
                }
            }
        }
    }
    
    public func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    public func start(lastFired: Date = Date.distantPast) {
        recalulateMissingTime(lastUpdate: lastFired)
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }
    }
    
    public func recalulateMissingTime(lastUpdate: Date) {
        let timeIntervalSinceLastUpdate = -lastUpdate.timeIntervalSinceNow
        timeRemaining = max(interval - Int(timeIntervalSinceLastUpdate), 0)
    }
}
