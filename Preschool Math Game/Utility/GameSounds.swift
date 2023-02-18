//
//  GameSounds.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 6/25/21.
//

import Foundation
import AVFoundation

class GameSounds {
    
    var backgroundSound: AVAudioPlayer?
    var winSound: AVAudioPlayer?
    var loseSound: AVAudioPlayer?
    
    func prepareBackgroundSound() {
        do {
            backgroundSound = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "background_sound", ofType: "mp3")!))
            
            backgroundSound?.prepareToPlay()
        } catch {
            print(error)
        }
    }
    
    func prepareLoseSound() {
        do {
            loseSound = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "positive_pops_swoosh_effect", ofType: "wav")!))
            
            loseSound?.prepareToPlay()
        } catch {
            print(error)
        }
    }
    
    func prepareWinSound() {
        do {
            winSound = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "nice_game_complete", ofType: "wav")!))
            
            winSound?.prepareToPlay()
        } catch {
            print(error)
        }
    }
    
    func playBackgroundSound() {
        backgroundSound?.play()
    }
    
    func stopBackgroundSound() {
        backgroundSound?.stop()
    }
    
    func playWinSound() {
        winSound?.play()
    }
    
    func stopWinSound() {
        winSound?.stop()
    }
    
    func playLoseSound() {
        loseSound?.play()
    }
    
    func stopLoseSound() {
        loseSound?.stop()
    }
}
