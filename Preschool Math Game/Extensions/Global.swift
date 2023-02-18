//
//  Global.swift
//  Preschool Math Game
//
//  Created by Armen Gasparyan on 16.03.22.
//

import Foundation

public var subscribed: Bool {
    return UserDefaults.standard.bool(forKey: UserDefaultsKeys.paymentKey)
}
