//
//  GameCenter.swift
//  Preschool Math Game
//
//  Created by Armen Gasparyan on 21.02.22.
//

import Foundation

enum GameType: String, CaseIterable {
    case counting
    case shapes
    case adding
    case sorting
    case sortingLearning
    case multipl
    case compare
    case division
    case subtract
    case schulte
    case memory
}

//indexes
extension GameType {
    var index: Int {
        switch self {
        case .schulte:
            return 0
        case .memory:
            return 1
        case .compare:
            return 2
        default:
            return -1
        }
    }
}

///write all games here
class GameCenter {
    static let allGames: [Game] = [
        Game(type: .schulte, subtype: .classic, name: "Classic", prize: "", hasDifficulty: true),
        Game(type: .schulte, subtype: .stepByStep, name: "Step By Step", prize: "", hasDifficulty: true),
        Game(type: .memory, subtype: .images, name: "Images", prize: "", hasDifficulty: true),
        Game(type: .counting, subtype: .counting1, name: "Counting 1", prize: "", hasDifficulty: false),
        Game(type: .counting, subtype: .counting2, name: "Counting 2", prize: "", hasDifficulty: false),
        Game(type: .counting, subtype: .findNumber, name: "Find Number", prize: "", hasDifficulty: true),
        Game(type: .counting, subtype: .oddEven, name: "Odd or Even", prize: "", hasDifficulty: false),
        Game(type: .shapes, subtype: .shapes1, name: "Shapes 1", prize: "", hasDifficulty: false),
        Game(type: .shapes, subtype: .shapes2, name: "Shapes 2", prize: "", hasDifficulty: false),
        Game(type: .shapes, subtype: .shapes3, name: "Shapes 3", prize: "", hasDifficulty: false),
        Game(type: .shapes, subtype: .shapes4, name: "Shapes 4", prize: "", hasDifficulty: false),
        Game(type: .adding, subtype: .adding1, name: "Adding 1", prize: "", hasDifficulty: false),
        Game(type: .adding, subtype: .adding2, name: "Adding 2", prize: "", hasDifficulty: false),
        Game(type: .adding, subtype: .adding3, name: "Adding 3", prize: "", hasDifficulty: true),
        Game(type: .adding, subtype: .adding4, name: "Adding 4", prize: "", hasDifficulty: false),
        Game(type: .adding, subtype: .adding5, name: "Adding 5", prize: "", hasDifficulty: true),
        Game(type: .adding, subtype: .addingMix, name: "Adding Mix", prize: "", hasDifficulty: false),
        Game(type: .sorting, subtype: .ascending, name: "Ascending", prize: "", hasDifficulty: false),
        Game(type: .sorting, subtype: .descending, name: "Descending", prize: "", hasDifficulty: false),
        Game(type: .sorting, subtype: .learning, name: "Learning", prize: "", hasDifficulty: false),
        Game(type: .multipl, subtype: .multipl1, name: "Multiplication 1", prize: "", hasDifficulty: false),
        Game(type: .multipl, subtype: .multipl2, name: "Multiplication 2", prize: "", hasDifficulty: false),
        Game(type: .multipl, subtype: .multipl3, name: "Multiplication 3", prize: "", hasDifficulty: false),
        Game(type: .compare, subtype: .scale, name: "Scale", prize: "", hasDifficulty: true),
        Game(type: .compare, subtype: .compare, name: "Compare", prize: "", hasDifficulty: false),
        Game(type: .division, subtype: .division1, name: "Division 1", prize: "", hasDifficulty: false),
        Game(type: .division, subtype: .division2, name: "Division 2", prize: "", hasDifficulty: false),
        Game(type: .subtract, subtype: .subtract1, name: "Subtracting 1", prize: "", hasDifficulty: false),
        Game(type: .subtract, subtype: .subtract2, name: "Subtracting 2", prize: "", hasDifficulty: false),
        Game(type: .subtract, subtype: .subtract3, name: "Subtracting 3", prize: "", hasDifficulty: true),
        Game(type: .subtract, subtype: .subtract4, name: "Subtracting 4", prize: "", hasDifficulty: false),
        Game(type: .subtract, subtype: .subtract5, name: "Subtracting 5", prize: "", hasDifficulty: true),
    ]
}
