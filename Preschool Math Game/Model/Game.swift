//
//  Game.swift
//  Preschool Math Game
//
//  Created by Armen Gasparyan on 18.02.22.
//

import Foundation
import UIKit

//MARK: - Game

class Game {
    let type: GameType
    let subtype: GameAddress.SubType
    let name: String
    let prize: String
    let prizeCount: Int
    let hasDifficulty: Bool
    var isLocked: Bool {
        set {
            guard !subscribed else { return }
            UserDefaults.standard.set(newValue, forKey: id + "IsLocked")
        }
        get {
            guard !subscribed else { return false }
            return UserDefaults.standard.bool(forKey: id + "IsLocked")
        }
    }
    
    init(
        type: GameType,
        subtype: GameAddress.SubType,
        name: String,
        prize: String,
        prizeCount: Int = 0,
        hasDifficulty: Bool = false
    ) {
        self.type = type
        self.subtype = subtype
        self.name = name
        self.prize = prize
        self.prizeCount = prizeCount
        self.hasDifficulty = hasDifficulty
    }
    
    var id: String { return type.rawValue + name }
}

//MARK: - GameAddress

struct GameAddress {
    var gameType: GameType
    var countType: CountType
    var subType: SubType
    var difficulty: GameDifficulty

    enum GameType: Int {
        case schulte, memory, compare

        var strRawValue: String {
            switch self {
            case .schulte:
                return "Schulte"
            case .memory:
                return "Memory"
            case .compare:
                return "Compare"
            }
        }
    }

    enum CountType: Int {
        case ascending, descending, matching

        var strRawValue: String {
            switch self {
            case .ascending:
                return "Ascending"
            case .descending:
                return "Descending"
            case .matching:
                return "Matching"
            }
        }
    }

    enum SubType: Int {
        case classic, stepByStep, images, numbers, counting1, counting2, findNumber, oddEven, shapes1, shapes2, shapes3, shapes4, adding1, adding2, adding3, addingMix, adding4, adding5, ascending, descending, learning, multipl1, multipl2, multipl3, compare, scale, division1, division2, subtract1, subtract2, subtract3, subtract4, subtract5

        var strRawValue: String {
            switch self {
            case .classic:
                return "Classic"
            case .stepByStep:
                return "Step By Step"
            case .images:
                return "Images"
            case .numbers:
                return "Numbers"
            case .counting1:
                return "Counting 1"
            case .counting2:
                return "Counting2"
            case .findNumber:
                return "Find Number"
            case .oddEven:
                return "Odd or Even"
            case .shapes1:
                return "Shapes 1"
            case .shapes2:
                return "Shapes 2"
            case .shapes3:
                return "Shapes 3"
            case .shapes4:
                return "Shapes 4"
            case .adding1:
                return "Adding 1"
            case .adding2:
                return "Adding 2"
            case .adding3:
                return "Adding 3"
            case .adding4:
                return "Adding 4"
            case .adding5:
                return "Adding 5"
            case .addingMix:
                return "Adding Mix"
            case .ascending:
                return "Ascending"
            case .descending:
                return "Descending"
            case .learning:
                return "Learning"
            case .multipl1:
                return "Multiplication 1"
            case .multipl2:
                return "Multiplication 2"
            case .multipl3:
                return "Multiplication 3"
            case .compare:
                return "Commpare"
            case .scale:
                return "Scale"
            case .division1:
                return "Division 1"
            case .division2:
                return "Division 2"
            case .subtract1:
                return "Subtracting 1"
            case .subtract2:
                return "Subtracting 2"
            case .subtract3:
                return "Subtracting 3"
            case .subtract4:
                return "Subtracting 4"
            case .subtract5:
                return "Subtracting 5"
            }
        }

        var subIndex: Int {
            switch self {
            case .classic:
                return 0
            case .stepByStep:
                return 1
            case .images:
                return 2
            case .numbers:
                return 3
            case .scale:
                return 4
            default:
                return 0
            }
        }
    }

    init(ints: [Int] = [0, 0, 0, 0]) {
        self.gameType   = GameType(rawValue: ints[0]) ?? .schulte
        self.subType    = SubType(rawValue: ints[1]) ?? .classic
        if subType == .images {
            self.countType = .matching
        } else {
            self.countType  = CountType(rawValue: ints[2]) ?? .ascending
        }
        self.difficulty = GameDifficulty(rawValue: ints[3]) ?? .beginner
    }

    var subgameId: String { return gameType.strRawValue.lowercased() + subType.strRawValue + difficulty.strRawValue }

    var gameId: String { return gameType.strRawValue.lowercased() + subType.strRawValue}
}
