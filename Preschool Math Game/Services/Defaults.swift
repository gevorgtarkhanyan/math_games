//
//  Defaults.swift
//  Preschool Math Game
//
//  Created by Armen Gasparyan on 02.03.22.
//

import Foundation

struct Defaults {
    static func saveDefaults<T:Codable>(data: T, key: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(try? PropertyListEncoder().encode(data), forKey: key)
    }
    
    static func loadDefaults<T:Codable>(key: String) -> T? {
        let userDefaults = UserDefaults.standard
        if let data = userDefaults.value(forKey: key) as? Data {
            let cardInfo = try? PropertyListDecoder().decode(T.self, from: data)
            return cardInfo
        }
        return nil
    }
}
