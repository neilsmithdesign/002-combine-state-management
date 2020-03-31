//
//  StopwatchViewController.swift
//  002-combine-state-management
//
//  Created by Neil Smith on 24/03/2020.
//  Copyright © 2020 Neil Smith Design LTD. All rights reserved.
//

import UIKit
import Combine

final class StopwatchViewController: UIViewController {
    
    
    // MARK: Init
    init(stopwatch: Stopwatch) {
        self.stopwatch = stopwatch
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    
    // MARK: Model
    private let stopwatch: Stopwatch
    private var subscriptions: Set<AnyCancellable> = .init()
    
    
    // MARK: Formatter
    private let timeFormatter: TimeFormatter = .init()
    
    
    // MARK: Subviews
    private lazy var leftButton: StopwatchButton = {
        let btn = StopwatchButton(viewModel: .make(for: self.stopwatch.time.state, position: .left))
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(didTapLeft), for: .touchUpInside)
        return btn
    }()
    
    private lazy var rightButton: StopwatchButton = {
        let btn = StopwatchButton(viewModel: .make(for: self.stopwatch.time.state, position: .right))
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(didTapRight), for: .touchUpInside)
        return btn
    }()
    
    private lazy var timeLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .monospacedDigitSystemFont(ofSize: 64, weight: .thin)
        l.textColor = .label
        l.textAlignment = .center
        return l
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        let sv = UIStackView(arrangedSubviews: [self.leftButton, spacer, self.rightButton])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alignment = .fill
        sv.axis = .horizontal
        sv.distribution = .fill
        return sv
    }()
    
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        buildViewHierarchy()
        configureSubscriptions()
    }
    
}


// MARK: Model observations
private extension StopwatchViewController {
    
    func configureSubscriptions() {
        bind(stopwatch.$time, to: .left, button: leftButton)
        bind(stopwatch.$time, to: .right, button: rightButton)
        stopwatch.$time
            .map { self.timeFormatter.string(for: $0.total) }
            .assign(to: \.text, on: timeLabel)
            .store(in: &subscriptions)
    }
    
    func bind(_ time: Published<Stopwatch.Time>.Publisher,
              to position: StopwatchButton.Position,
              button: StopwatchButton) {
        time
            .map { StopwatchButton.ViewModel.make(for: $0.state, position: position) }
            .assign(to: \.viewModel, on: button)
            .store(in: &subscriptions)
    }

}


// MARK: User Interactions
private extension StopwatchViewController {
    
    @objc func didTapLeft() {
        stopwatch.recordLapOrReset()
    }
    
    @objc func didTapRight() {
        stopwatch.toggleStartPause()
    }
    
}


// MARK: Layout
private extension StopwatchViewController {
    
    func buildViewHierarchy() {
        view.addSubview(buttonStackView)
        constrain(leftButton)
        constrain(rightButton)
        buttonStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        buttonStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24).isActive = true
        buttonStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true
        view.addSubview(timeLabel)
        timeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor).isActive = true
    }

    func constrain(_ button: StopwatchButton) {
        button.heightAnchor.constraint(equalToConstant: 88).isActive = true
        button.widthAnchor.constraint(equalTo: button.heightAnchor).isActive = true
    }
    
}
