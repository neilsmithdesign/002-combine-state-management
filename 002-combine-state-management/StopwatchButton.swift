//
//  StopwatchButton.swift
//  002-combine-state-management
//
//  Created by Neil Smith on 24/03/2020.
//  Copyright © 2020 Neil Smith Design LTD. All rights reserved.
//

import UIKit

final class StopwatchButton: UIButton {
    
    var viewModel: StopwatchButton.ViewModel {
        didSet {
            configure()
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.4
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.7 : 1.0
        }
    }
    
    init(viewModel: StopwatchButton.ViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height / 2
    }
    
    private func configure() {
        setTitle(viewModel.title, for: .normal)
        backgroundColor = viewModel.color
        isEnabled = viewModel.isEnabled
    }
    
}

extension StopwatchButton {
    
    struct ViewModel {
        let title: String
        let color: UIColor
        let isEnabled: Bool
    }
    
    enum Position {
        case left
        case right
    }
    
}

extension StopwatchButton.ViewModel {
    
    static var start: Self {
        .init(title: "Start", color: .systemGreen, isEnabled: true)
    }
    static var stop: Self {
        .init(title: "Stop", color: .systemRed, isEnabled: true)
    }
    static func lap(isEnabled: Bool) -> Self {
        .init(title: "Lap", color: .systemGray, isEnabled: isEnabled)
    }
    static var reset: Self {
        .init(title: "Reset", color: .systemGray, isEnabled: true)
    }
    
}

extension StopwatchButton.ViewModel {
    
    static func make(for state: Stopwatch.State, position: StopwatchButton.Position) -> Self {
        switch position {
        case .left:
            switch state {
            case .inactive: return .lap(isEnabled: false)
            case .active: return .lap(isEnabled: true)
            case .paused: return .reset
            }
        case .right:
            switch state {
            case .paused, .inactive: return .start
            case .active: return .stop
            }
        }
    }
    
}
