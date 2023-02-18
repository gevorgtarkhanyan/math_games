//
//  Timer.swift
//  Preschool Math Game
//
//  Created by Armen Gasparyan on 22.12.21.
//

import Foundation

extension Timer {
    @objc open class func scheduledTimer(withTimeInterval interval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> Void) -> Timer {
        let customTimer = CustomTimer(interval: interval, repeats: repeats, block: block)
        return customTimer.scheduleTimer()
    }
}

// MARK: - Helpers
class CustomTimer {
    let interval: TimeInterval
    let repeats: Bool
    let block: (Timer) -> Void
    
    init(interval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> Void) {
        self.interval = interval
        self.repeats = repeats
        self.block = block
    }
    
    func scheduleTimer() -> Timer {
        return Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(action(timer:)), userInfo: nil, repeats: repeats)
    }
    
    @objc func action(timer: Timer) {
        block(timer)
    }
}
