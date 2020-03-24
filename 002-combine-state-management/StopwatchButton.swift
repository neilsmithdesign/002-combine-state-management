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
            setColors()
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
        setColors()
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
        isEnabled = viewModel.isEnabled
    }
    
    private func setColors() {
        self.backgroundColor = currentBackgroundColor
        self.setTitleColor(titleColor, for: .normal)
    }
    
    private var currentBackgroundColor: UIColor {
        isEnabled ? viewModel.color : viewModel.disbaledColor
    }
    
    private var titleColor: UIColor {
        isEnabled ? viewModel.titleColor : viewModel.disabledTitleColor
    }
    
}

extension StopwatchButton {
    
    struct ViewModel {
        let title: String
        let isEnabled: Bool
        let color: UIColor
        
        var disbaledColor: UIColor { color.withAlphaComponent(0.4) }
        let titleColor: UIColor = .white
        var disabledTitleColor: UIColor { titleColor.withAlphaComponent(0.4) }
    }
    
    enum Position {
        case left
        case right
    }
    
}

extension StopwatchButton.ViewModel {
    
    static var start: Self {
        .init(title: "Start", isEnabled: true, color: .systemGreen)
    }
    static var stop: Self {
        .init(title: "Stop", isEnabled: true, color: .systemRed)
    }
    static func lap(isEnabled: Bool) -> Self {
        .init(title: "Lap", isEnabled: isEnabled, color: .systemGray)
    }
    static var reset: Self {
        .init(title: "Reset", isEnabled: true, color: .systemGray)
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
