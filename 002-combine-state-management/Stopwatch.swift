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
    
    private (set) var state: CurrentValueSubject<State, Never> = .init(.inactive)
    
}

extension Stopwatch {
    
    func toggleStartPause() {
        state.send(state.value.newState(for: .startPause))
    }
    
    func recordLapOrReset() {
        if state.value == .active {
            recordLap()
        }
        state.send(state.value.newState(for: .lapReset))
    }
    
    private func recordLap() {
        print("To do: record lap")
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
