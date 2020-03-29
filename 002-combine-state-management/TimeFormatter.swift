//
//  TimeFormatter.swift
//  002-combine-state-management
//
//  Created by Neil Smith on 29/03/2020.
//  Copyright © 2020 Neil Smith Design LTD. All rights reserved.
//

import Foundation

struct TimeFormatter {
    
    func string(for time: TimeInterval) -> String {
        let ms = millisecondsFormatter.string(from: NSNumber(value: time.truncatingRemainder(dividingBy: 1))) ?? "-"
        let mm_ss = minutesSecondsFormatter.string(from: time) ?? "-"
        return mm_ss + ms
    }
    
    private let minutesSecondsFormatter: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.allowedUnits = [.minute, .second]
        f.zeroFormattingBehavior = .pad
        return f
    }()
    
    private let millisecondsFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        f.maximumIntegerDigits  = 0
        f.alwaysShowsDecimalSeparator = true
        return f
    }()
    
}
