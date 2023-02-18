//
//  BasePageController.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 15.07.21.
//

import UIKit

class BasePageController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var middleViewHeight: NSLayoutConstraint!

    @IBOutlet weak var preschoolMathGameImageView: UIImageView!
    @IBOutlet weak var spaceView: UIView!
    @IBOutlet weak var gamesStackView: UIStackView!

    @IBOutlet weak var preschoolMathGameImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var spaceViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var gamesStackViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var topLeftImageView: UIImageView!
    @IBOutlet weak var bottomLeftImageView: UIImageView!
    @IBOutlet weak var topRightImageView: UIImageView!
    @IBOutlet weak var bottomRightImageView: UIImageView!

    @IBOutlet weak var topLeftImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomLeftImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topRightImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomRightImageHeightConstraint: NSLayoutConstraint!
    
    static var sounds = GameSounds()
    
    override var prefersHomeIndicatorAutoHidden: Bool { return false }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge { return UIRectEdge.bottom }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.setValue(true, forKey: UserDefaultsKeys.isOpenSecondTime)
        
        BasePageController.sounds.prepareBackgroundSound()
        
        if UserDefaults.standard.bool(forKey: UserDefaultsKeys.ischangeBackgroundSoundStatus) {
            if UserDefaults.standard.bool(forKey: UserDefaultsKeys.backgroundSoundIsOn) {
                BasePageController.sounds.playBackgroundSound()
            } else {
                BasePageController.sounds.stopBackgroundSound()
            }
        } else {
            BasePageController.sounds.playBackgroundSound()
        }
        
        if UserDefaults.standard.bool(forKey: UserDefaultsKeys.isChangedShowHunt) {
            GamesLimit.isShowHunt = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isShowHunt)
        } else {
            GamesLimit.isShowHunt = true
        }

        setupUIForPad()
    }

    @IBAction func countingAction(_ sender: UIButton) { initGameSelectionVC(with: .counting) }
    
    @IBAction func addingAction(_ sender: UIButton) { initGameSelectionVC(with: .adding) }
    
    @IBAction func multiplicationAction(_ sender: UIButton) { initGameSelectionVC(with: .multipl) }
    
    @IBAction func divisionAction(_ sender: UIButton) { initGameSelectionVC(with: .division) }

    @IBAction func shulteAction(_ sender: UIButton) { initGameSelectionVC(with: .schulte) }

    @IBAction func memoryAction(_ sender: UIButton) { initGameSelectionVC(with: .memory) }

    @IBAction func shapesAction(_ sender: UIButton) { initGameSelectionVC(with: .shapes) }
    
    @IBAction func sortingAction(_ sender: UIButton) { initGameSelectionVC(with: .sorting) }
    
    @IBAction func compareAction(_ sender: UIButton) { initGameSelectionVC(with: .compare) }
    
    @IBAction func subtractingAction(_ sender: UIButton) { initGameSelectionVC(with: .subtract) }

    @IBAction func settingsButtonAction(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ParentalControllController") as! ParentalControllController

        vc.fromSettings = true
        
        self.addChild(vc)
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
    }

    private func initGameSelectionVC(with gameType: GameType) {
        guard let vc = GameSelectionViewController.initWithStoryboard() else { return }

        let games = GameCenter.allGames.filter { $0.type == gameType }
        vc.setGames(games)
        navigationController?.pushViewController(vc, animated: true)
    }

    private func setupUIForPad() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            backgroundImageView.image = UIImage(named: "menuBackgroundPad")

            // middle view

            let padMiddleViewHeight = NSLayoutConstraint(item: middleView!, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.6, constant: 0)
//
            let padPreschoolMathGameImageViewHeightConstraint = NSLayoutConstraint(item: preschoolMathGameImageView!, attribute: .height, relatedBy: .equal, toItem: preschoolMathGameImageView.superview, attribute: .height, multiplier: 0.2, constant: 0)
            let padSpaceViewHeightConstraint = NSLayoutConstraint(item: spaceView!, attribute: .height, relatedBy: .equal, toItem: spaceView.superview, attribute: .height, multiplier: 0.11, constant: 0)
            let padGamesStackViewHeightConstraint = NSLayoutConstraint(item: gamesStackView!, attribute: .height, relatedBy: .equal, toItem: gamesStackView.superview, attribute: .height, multiplier: 0.69, constant: 0)

            middleViewHeight.isActive = false
            middleViewHeight = padMiddleViewHeight
            padMiddleViewHeight.isActive = true

            preschoolMathGameImageViewHeightConstraint.isActive = false
            preschoolMathGameImageViewHeightConstraint = padPreschoolMathGameImageViewHeightConstraint
            padPreschoolMathGameImageViewHeightConstraint.isActive = true

            spaceViewHeightConstraint.isActive = false
            spaceViewHeightConstraint = padSpaceViewHeightConstraint
            padSpaceViewHeightConstraint.isActive = true

            gamesStackViewHeightConstraint.isActive = false
            gamesStackViewHeightConstraint = padGamesStackViewHeightConstraint
            padGamesStackViewHeightConstraint.isActive = true

            //kids

            let padTopLeftImageHeightConstraint = NSLayoutConstraint(item: topLeftImageView!, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.3, constant: 0)
            let padBottomLeftImageHeightConstraint = NSLayoutConstraint(item: bottomLeftImageView!, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.3, constant: 0)
            let padTopRightImageHeightConstraint = NSLayoutConstraint(item: topRightImageView!, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.3, constant: 0)
            let padBottomRightImageHeightConstraint = NSLayoutConstraint(item: bottomRightImageView!, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.3, constant: 0)


            topLeftImageHeightConstraint.isActive = false
            topLeftImageHeightConstraint = padTopLeftImageHeightConstraint
            padTopLeftImageHeightConstraint.isActive = true

            bottomLeftImageHeightConstraint.isActive = false
            bottomLeftImageHeightConstraint = padBottomLeftImageHeightConstraint
            padBottomLeftImageHeightConstraint.isActive = true

            topRightImageHeightConstraint.isActive = false
            topRightImageHeightConstraint = padTopRightImageHeightConstraint
            padTopRightImageHeightConstraint.isActive = true

            bottomRightImageHeightConstraint.isActive = false
            bottomRightImageHeightConstraint = padBottomRightImageHeightConstraint
            padBottomRightImageHeightConstraint.isActive = true
        }
    }
}
