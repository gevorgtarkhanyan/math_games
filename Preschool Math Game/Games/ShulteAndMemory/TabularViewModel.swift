//
//  TabularViewModel.swift
//  Preschool Math Game
//
//  Created by Armen Gasparyan on 22.02.22.
//

import Foundation
import UIKit

protocol TabularViewModelDelegate: AnyObject {
    func failAction()
    func succesSchulteAscendingBeginer()
    func gameEnded(iconName: String)
    func updateTimer(second: Int)
    func selectFirstItem(index: Int)
    func reset()
    func showParental()
    func reloadData()
}

class TabularViewModel {
    var gameAddress = GameAddress()
    var game = TabularGame()

    var lastSelected = 0
    var firstSelectionIndex = 0
    
    //Images
    var firstIndexPath: IndexPath?
    var secondIndexPath: IndexPath?
    var pairs = 0 { didSet {
        switch gameAddress.difficulty {
        case .beginner where pairs == 8:
            memoryImagesEnded()
        case .intermediate where pairs == 10:
            memoryImagesEnded()
        case .advance where pairs == 15:
            memoryImagesEnded()
        default:
            break
        }
    }
    }
    
    private var step: Int {
        guard gameAddress.subType == .stepByStep else { return 1 }
        return [2, 3, 4, 5][gameAddress.difficulty.rawValue]
    }
    
    private var prizeIcons = ["winPrize1", "winPrize2", "winPrize3", "winPrize"]
    private var currentPrizeIcon: String = "winPrize"
    private var timer: Timer?
    private var checkTimer: Timer?
    private var timerSecond = 0
    private var timerStarted = false
    
    weak var delegate: TabularViewModelDelegate?
    
    //MARK: - Page Data
    
    var personName: String { return game.personName }
    
    var numbers: [Int] { return game.numbers }
    
    var images: [UIImage] { return game.images }
    
    var prizes: [Prize]? { return game.prizes }
    
    var stopwatch: Stopwatch? { return game.stopwatch }
    
    var analiticsValue: String { return gameAddress.subgameId }
    
    var prizeCount: Int { return game.prizes?.count ?? 0 }
    
    var multiplier: Double { return Double(columnRow.r) / Double(columnRow.c) }
    
    var columnRow: (c: Int, r: Int) {
        let sqrtValue: Double
        
        switch gameAddress.subType {
        case .images:
            sqrtValue = sqrt(Double(images.count))
        default:
            sqrtValue = sqrt(Double(numbers.count))
        }
        
        let intSqrtValue = Int(sqrtValue)
        
        if (sqrtValue - Double(intSqrtValue)) == 0.0 {
            return (intSqrtValue, intSqrtValue)
        } else { return (intSqrtValue, intSqrtValue + 1) }
    }
    
    func getIconNames(row: Int) -> String {
        switch gameAddress.countType {
        case .ascending:
            return "tabularCellBlue"
        case .descending:
            return "tabularCellRed"
        case .matching:
            return "tabularCellGrey"
        }
    }
    
    var isAscending: Bool { return gameAddress.countType == .ascending }
    
    //MARK: - Setup Game
    
    private func gameSetup() {
        var personName: String = ""
        var numbers: [Int] = [Int](1...16).shuffled()
        var imagePairs: [[UIImage]] = []
        var images: [UIImage] = []
        
        for number in 1...24 {
            let image = UIImage(named: "matching-\(number)")!
            imagePairs.append([image, image])
        }
        imagePairs.shuffle()
        
        var prizes: [Prize]? = [
            Prize(id: 0, name: "prize1", second: 30),
            Prize(id: 1, name: "prize2", second: 40),
            Prize(id: 2, name: "prize3", second: 60)
        ]
        
        //        var stopwatch: Stopwatch?       = nil
        
        let tuple = (gameAddress.gameType, gameAddress.subType, gameAddress.countType, gameAddress.difficulty)
        
        switch tuple {
            ///schulte  ascending
        case (.schulte, .classic, .ascending, .beginner):
            lastSelected = 0
            personName = "footballer"
            numbers = [Int](1...16).shuffled()
            prizes = nil
            firstSelectionIndex = numbers.firstIndex(of: 1) ?? 0
            
        case (.schulte, .classic, .ascending, .intermediate):
            lastSelected = 0
            personName = "footballer"
            numbers = [Int](1...25).shuffled()
            firstSelectionIndex = numbers.firstIndex(of: 1) ?? 0
            
        case (.schulte, .classic, .ascending, .advance):
            lastSelected = 0
            personName = "footballer"
            numbers = [Int](1...36).shuffled()
            firstSelectionIndex = numbers.firstIndex(of: 1) ?? 0
            
            ///schulte descending
        case (.schulte, .classic, .descending, .beginner):
            lastSelected = 17
            personName = "curly"
            numbers = [Int](1...16).shuffled()
            prizes = nil
            firstSelectionIndex = numbers.firstIndex(of: numbers.max() ?? 1) ?? 0
        case (.schulte, .classic, .descending, .intermediate):
            lastSelected = 26
            personName = "curly"
            numbers = [Int](1...25).shuffled()
            firstSelectionIndex = numbers.firstIndex(of: numbers.max() ?? 1) ?? 0
        case (.schulte, .classic, .descending, .advance):
            lastSelected = 37
            personName = "curly"
            numbers = [Int](1...36).shuffled()
            firstSelectionIndex = numbers.firstIndex(of: numbers.max() ?? 1) ?? 0
            
        case (.schulte, .stepByStep, .ascending, _):
            lastSelected = 0
            personName = "curly"
            numbers = [Int](1...25).shuffled()
            numbers = numbers.map { $0 * step }
            firstSelectionIndex = numbers.firstIndex(of: numbers.min() ?? 1) ?? 0
            
        case (.schulte, .stepByStep, .descending, _):
            personName = "curly"
            numbers = [Int](1...25).shuffled()
            numbers = numbers.map { $0 * step }
            lastSelected = (numbers.max() ?? 26) + step
            firstSelectionIndex = numbers.firstIndex(of: numbers.max() ?? 1) ?? 0
            
            ///memory
        case (.memory, .images, _, .beginner):
            imagePairs = Array(imagePairs[0...7])
            images = Array(imagePairs.joined())
            images.shuffle()
            prizes = nil
            
        case (.memory, .images, _, .intermediate):
            imagePairs = Array(imagePairs[0...9])
            images = Array(imagePairs.joined())
            images.shuffle()
            
        case (.memory, .images, _, .advance):
            imagePairs = Array(imagePairs[0...14])
            images = Array(imagePairs.joined())
            images.shuffle()
            
        default:
            break
        }
        
        game = TabularGame(personName: personName, numbers: numbers, images: images, prizes: prizes, stopwatch: stopwatch)
    }
    
    @objc func updateTimer() {
        timerSecond += 1
        delegate?.updateTimer(second: timerSecond)
    }

    private func timerInvalidate() {
        timer?.invalidate()
        timer = nil
        timerStarted = false
        delegate?.updateTimer(second: timerSecond)
    }
    
    //MARK: - Public
    
    func startTimer() {
        guard !timerStarted && game.prizes != nil else { return }

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        timerStarted = true
    }
    
    func setNavigationIndexes(_ indexes: [Int]) {
        gameAddress = GameAddress(ints: indexes)
        gameSetup()
    }
    
    func selectFirstItem() { delegate?.selectFirstItem(index: firstSelectionIndex) }
    
    //MARK: - Game action
    
    func checkImages(firstCell: ImageCollectionViewCell?, secondCell: ImageCollectionViewCell?, collectionView: UICollectionView, firstIndexPath: IndexPath?, secondIndexPath: IndexPath?) {
        if firstCell?.imageView.image.hashValue == secondCell?.imageView.image.hashValue {
            firstCell?.selectionImageView.isHidden = false
            secondCell?.selectionImageView.isHidden = false
            
            firstCell?.isUserInteractionEnabled = false
            secondCell?.isUserInteractionEnabled = false
            
            firstCell?.setGreyBackground()
            secondCell?.setGreyBackground()
            
            self.firstIndexPath = nil
            self.secondIndexPath = nil
            
            pairs += 1
        } else {
            firstCell?.isUserInteractionEnabled = false
            secondCell?.isUserInteractionEnabled = false
            
            // Advance / Intermediate
            if gameAddress.difficulty != .beginner {
                checkTimer = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false) { _ in
                    if firstCell?.isSelected == true && secondCell?.isSelected == true {
                        firstCell?.isUserInteractionEnabled = false
                        secondCell?.isUserInteractionEnabled = false
                        self.unselectFirstCell(collectionView: collectionView, firstCell: firstCell)
                        self.unselectSecondCell(collectionView: collectionView, secondCell: secondCell)
                        firstCell?.isUserInteractionEnabled = true
                        secondCell?.isUserInteractionEnabled = true
                    }
                    firstCell?.isUserInteractionEnabled = true
                    secondCell?.isUserInteractionEnabled = true
                }
            } else {
                // Beginner
                checkTimer = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false) { _ in
                    if secondCell?.isSelected == true {
                        firstCell?.isUserInteractionEnabled = false
                        self.unselectSecondCell(collectionView: collectionView, secondCell: secondCell)
                        firstCell?.isUserInteractionEnabled = true
                        secondCell?.isUserInteractionEnabled = true
                    }
                    secondCell?.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    func unselectFirstCell(collectionView: UICollectionView, firstCell: ImageCollectionViewCell?) {
        collectionView.deselectItem(at: firstIndexPath!, animated: true)
        firstCell?.hideImage()
        firstIndexPath = nil
    }
    
    func unselectSecondCell(collectionView: UICollectionView, secondCell: ImageCollectionViewCell?) {
        self.game.audio.playLoseSound()
        collectionView.deselectItem(at: secondIndexPath!, animated: true)
        if self.gameAddress.difficulty == .beginner {
            secondCell?.setGreyBackground()
        } else {
            secondCell?.hideImage()
        }
        secondIndexPath = nil
        Vibration.error.vibrate()
    }
    
    func selectedAction(_ index: Int) {
        startTimer()
        let tuple = (gameAddress.gameType, gameAddress.subType, gameAddress.countType, gameAddress.difficulty)
        
        switch tuple {
        case (.schulte, _, .ascending, _):
            schulteAscendingAction(index)
            
        case (.schulte, _, .descending, _):
            schulteDescendingAction(index)
            
        default:
            break
        }
    }
    
    func refresh() {
        if subscribed {
            timerSecond = 0
            timerInvalidate()
            gameSetup()
            getState()
            delegate?.reloadData()
            delegate?.reset()
        } else { delegate?.showParental() }
    }
}

//MARK: - Games Logics
// Schulte
extension TabularViewModel {
    private func schulteAscendingAction(_ index: Int) {
        let selectedNumber = numbers[index]
        let num = selectedNumber - step
        if num == lastSelected {
            lastSelected = selectedNumber
            delegate?.succesSchulteAscendingBeginer()
            if selectedNumber == numbers.max() {
                schulteEnded()
            }
        } else {
            delegate?.failAction()
            game.audio.playLoseSound()
        }
    }
    
    private func schulteDescendingAction(_ index: Int) {
        let selectedNumber = numbers[index]
        let num = selectedNumber + step
        if num == lastSelected {
            lastSelected = selectedNumber
            delegate?.succesSchulteAscendingBeginer()
            if selectedNumber == numbers.min() {
                schulteEnded()
            }
        } else {
            delegate?.failAction()
            game.audio.playLoseSound()
        }
    }
    
    private func schulteEnded() {
        let parentGame = GameCenter.allGames.first { $0.id == gameAddress.gameId }
        parentGame?.isLocked = true
        timerInvalidate()
        getWinner()
        delegate?.gameEnded(iconName: currentPrizeIcon)
        game.audio.playWinSound()
    }
    
    private func memoryImagesEnded() {
        let parentGame = GameCenter.allGames.first { $0.id == gameAddress.gameId }
        parentGame?.isLocked = true
        timerInvalidate()
        getWinner()
        delegate?.gameEnded(iconName: currentPrizeIcon)
        pairs = 0
        game.audio.playWinSound()
    }
    
    private func getWinner() {
        guard prizes != nil else { return }
        var index: Int = -1
        
        switch timerSecond {
        case 0...30:    index = 0
        case 30...40:   index = 1
        case 40...60:   index = 2
        default:        index = 3
        }
        
        if index == 3 {
            if game.prizes?.count == 3 {
                let losePrize = Prize(id: index, name: "prize", second: timerSecond)
                game.prizes?.append(losePrize)
            }
        }
        game.prizes?[index].win(with: timerSecond)
        currentPrizeIcon = prizeIcons[index]
        saveState()
    }
}

//MARK: - State

extension TabularViewModel {
    private func saveState() { Defaults.saveDefaults(data: game.winPrize, key: gameAddress.subgameId) }
    
    func getState() {
        guard let winPrize: Prize =  Defaults.loadDefaults(key: gameAddress.subgameId) else { return }
        
        //        let contains = game.prizes?.contains(where: { $0.name == winPrize.name }) ?? true
        //        if !contains {
        //            game.prizes?.append(winPrize)
        //        }
        
        if let _ = (game.prizes?.first { $0 == winPrize }) {
            game.prizes?.enumerated().forEach { index, value in
                if value == winPrize {
                    game.prizes?[index] = winPrize
                }
            }
        } else { game.prizes?.append(winPrize) }
    }
}
