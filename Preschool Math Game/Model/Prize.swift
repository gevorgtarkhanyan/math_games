//
//  Prize.swift
//  Preschool Math Game
//
//  Created by Taron Saribekyan on 27.10.22.
//

import UIKit

class Prize: Codable, Comparable {
    var id: Int
    var name: String
    var seconds: Int

    init(id: Int, name: String, second: Int) {
        self.name = name
        self.seconds = second
        self.id = id
    }

    func win(with seconds: Int) {
        if self.seconds > seconds {
            self.seconds = seconds
        }
        guard !name.contains("win") else { return }
        name.capitalizeFirstLetter()
        name = "win" + name
    }

    var textColor: UIColor {
        switch name {
        case let newName where newName.contains("1"):
            return .prize1
        case let newName where newName.contains("2"):
            return .prize2
        case let newName where newName.contains("3"):
            return .prize3
        default:
            return .losePrize
        }
    }

    static func == (lhs: Prize, rhs: Prize) -> Bool { return lhs.id == rhs.id }

    static func < (lhs: Prize, rhs: Prize) -> Bool { return lhs.seconds < rhs.seconds }
}
