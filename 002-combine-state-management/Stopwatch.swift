//
//  Stopwatch.swift
//  002-combine-state-management
//
//  Created by Neil Smith on 24/03/2020.
//  Copyright © 2020 Neil Smith Design LTD. All rights reserved.
//

import Foundation
import Combine

final class Stopwatch {
    
    init() {}
    
    @Published private (set) var time: Time = .init()
    
    private var timer: Timer?
    
}

extension Stopwatch {
    
    
    // MARK: Start/Pause
    func toggleStartPause() {
        if time.state == .active {
            pause()
        } else {
            start()
        }
    }
    
    private func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { _ in
            let latest = Date().timeIntervalSinceReferenceDate
            self.time.update(latest)
        })
        let now = Date().timeIntervalSinceReferenceDate
        time.start(now)
    }
    
    private func pause() {
        timer?.invalidate()
        timer = nil
        time.pause()
    }
    
    
    // MARK: Lap/Reset
    func recordLapOrReset() {
        if time.state == .active {
            recordLap()
        } else {
            time.reset()
        }
    }
    
    private func recordLap() {
        print("To do: record lap")
    }
    
}

extension Stopwatch {
    
    struct Time {

        
        var total: TimeInterval {
            if let start = intervalStart {
                return previousIntervalTotals + current - start
            } else {
                return previousIntervalTotals
            }
        }
        
        var state: State {
            if total <= 0 {
                return .inactive
            } else if intervalStart == nil {
                return .paused
            } else {
                return .active
            }
        }
        
        mutating func start(_ time: TimeInterval) {
            intervalStart = time
            current = time
        }
        
        mutating func update(_ time: TimeInterval) {
            current = time
        }
        
        mutating func pause() {
            previousIntervalTotals = total
            intervalStart = nil
        }
        
        mutating func reset() {
            current = 0
            intervalStart = nil
            previousIntervalTotals = 0
        }

        private var current: TimeInterval = 0
        private var intervalStart: TimeInterval?
        private var previousIntervalTotals: TimeInterval = 0
        
    }
    
}

extension Stopwatch {
    
    enum State {
        case inactive
        case active
        case paused
        
        func newState(for action: Action) -> State {
            switch action {
            case .startPause: return self == .active ? .paused : .active
            case .lapReset: return self == .paused ? .inactive : self
            }
        }
        
    }
    
    enum Action {
        case startPause
        case lapReset
    }
    
}
