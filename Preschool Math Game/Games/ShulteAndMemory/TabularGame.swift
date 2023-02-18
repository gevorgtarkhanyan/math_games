//
//  SchulteGame.swift
//  Preschool Math Game
//
//  Created by Armen Gasparyan on 24.02.22.
//

import Foundation
import UIKit

class TabularGame {
    var personName: String = ""
    var numbers: [Int] = []
    var images: [UIImage] = []
    var prizes: [Prize]?
    var stopwatch: Stopwatch?
    let audio = GameSounds()
    
    var winPrize: Prize? { return prizes?.first { $0.name.contains("win") } }
    
    init() {}
    
    init(personName: String, numbers: [Int], images: [UIImage], prizes: [Prize]? = nil, stopwatch: Stopwatch? = nil) {
        self.personName = personName
        self.numbers = numbers
        self.images = images
        self.prizes = prizes
        self.stopwatch = stopwatch
        
        if UserDefaults.standard.bool(forKey: UserDefaultsKeys.ischangeEfectsSoundStatus) {
            if UserDefaults.standard.bool(forKey: UserDefaultsKeys.efectsSoundIsOn) {
                audio.prepareLoseSound()
                audio.prepareWinSound()
            }
        } else {
            audio.prepareLoseSound()
            audio.prepareWinSound()
        }
    }
}
