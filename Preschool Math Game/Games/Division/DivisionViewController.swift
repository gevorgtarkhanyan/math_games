//
//  DivisionViewController.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 08.07.21.
//

import UIKit

class DivisionViewController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var firstNumberLabel: PaddingLabel!
    @IBOutlet weak var secondNumberLabel: PaddingLabel!
    @IBOutlet weak var resultSpace: UIImageView!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet var collectionButton: [UIButton]!
    @IBOutlet weak var resultContainerView: UIView!
    @IBOutlet weak var prizContainerView: UIView!
    @IBOutlet weak var prizImageView: UIImageView!
    @IBOutlet weak var gameGroundView: UIView!
    @IBOutlet weak var buttonsContainerView: UIView!
    @IBOutlet weak var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerLeftConstraint: NSLayoutConstraint!
    
    //MARK: - Properties

    var game: Game!

    private var layoutSubviewsCount: Int! = 0
    
    private var finalCount: Int = 0
    
    private var touchedButton = false

    static func initWithStoryboard() -> DivisionViewController? {
        let storyboard = UIStoryboard(name: "DivisionGames", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: DivisionViewController.name) as? DivisionViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        AnalyticService.shared.setupAmplitude(game: "start_division")
        
        setBorders()

//        GamesLimit.divisionPrizCount = UserDefaults.standard.value(forKey: UserDefaultsKeys.divisionPrizCount) as? Int ?? 0
        
        firstButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        secondButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        thirdButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        firstButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        secondButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        thirdButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: .updateDivision, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIScreen.main.bounds.height >= 1000 {
            containerTopConstraint.constant = 230
            containerBottomConstraint.constant = 200
            containerLeftConstraint.constant = 100
            containerRightConstraint.constant = 100
        }
        
        if layoutSubviewsCount == 1 {
            drawUI()
        }
        layoutSubviewsCount += 1
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Functions
    private func setFinger() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
            if !self.touchedButton {
                for i in self.collectionButton {
                    if i.tag == self.finalCount {
                        let pointX = i.globalFrame.origin.x
                        let pointY = i.globalFrame.origin.y + 30
                        self.setFinger(button: i, pointX: pointX, pointY: pointY, btnWidth: 60, btnHeight: 60)
                        self.removeFinger()
                    }
                }
            }
            return
        }
    }

    private func removeFinger() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
            self.fingerArray.forEach({$0.removeFromSuperview()})
            self.fingerArray.removeAll()
            if !self.touchedButton {
                self.setFinger()
            }
            return
        }
    }
    
    private func setBorders() {
        gameGroundView.layer.borderWidth = 5
        gameGroundView.layer.borderColor = #colorLiteral(red: 0.7490196078, green: 0.1882352941, blue: 0.2156862745, alpha: 1)
        buttonsContainerView.layer.borderWidth = 5
        buttonsContainerView.layer.borderColor = #colorLiteral(red: 0.7490196078, green: 0.1882352941, blue: 0.2156862745, alpha: 1)
    }
    
    @objc func update() {
        collectionButton.forEach({$0.transform = .identity})
        collectionButton.forEach({$0.alpha = 1})
        GamesLimit.divisionLimit = 0
        self.resultSpace.image = UIImage(named: "questionMark")
        self.drawUI()
    }
    
    private func drawUI() {
        setLabelsCount()
        setupButtonsImage()
        setAnimatingViews()
        
        touchedButton = false
        
        if GamesLimit.isShowHunt {
            workItem = DispatchWorkItem { self.setFinger() }
            DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: workItem)
        }
    }
    
    private func setAnimatingViews() {
        collectionButton.animateFromBottom(point: CGPoint(x: 0, y: 120))
        resultContainerView.animateFromBottom(point: CGPoint(x: 0, y: 150))
    }
    
    private func setLabelsCount() {
        let first = [2, 4, 6, 8, 10].shuffled()
        let _2 = [1, 2].shuffled()
        let _4 = [1, 2, 4].shuffled()
        let _6 = [1, 2, 3, 6].shuffled()
        let _8 = [1, 2, 4, 8].shuffled()
        let _10 = [1, 2, 5, 10].shuffled()
        
        firstNumberLabel.text = String(first[0])
        
        if firstNumberLabel.text == "2" {
            secondNumberLabel.text = String(_2[0])
            
        } else if firstNumberLabel.text == "4" {
            secondNumberLabel.text = String(_4[0])
            
        } else if firstNumberLabel.text == "6" {
            secondNumberLabel.text = String(_6[0])
            
        } else if firstNumberLabel.text == "8" {
            secondNumberLabel.text = String(_8[0])
            
        } else if firstNumberLabel.text == "10" {
            secondNumberLabel.text = String(_10[0])
        }
        
        finalCount = Int(firstNumberLabel.text!)! / Int(secondNumberLabel.text!)!
    }
    
    private func setupButtonsImage() {
        let max = 10
        var indexes = [finalCount]
        for _ in 0..<2 {
            let random: Int = Random.getRandomIndex(in: 0..<max, ignoredIndexes: indexes)
            indexes.append(random)
        }
        
        indexes = indexes.shuffled()
        
        for i in 0..<indexes.count {
            let number: Int = indexes[i]
            let imageName: String = "btn_\(number)"
            let image: UIImage = UIImage(named: imageName)!
            let button = collectionButton[i]
            button.setImage(image, for: .normal)
            button.tag = number
        }
    }
    
    @objc func gestureButtonAction(gesture: UIPanGestureRecognizer) {
        threeButtonPanGesture(gesture: gesture, gamesLimit: GamesLimit.divisionLimit, resultSpace: resultSpace, finalCount: finalCount, firstView: prizContainerView as! UIImageView, secondView: prizImageView, gamesType: "divisionLimit", containerView: UIView())
        delegate = self
    }
    
    //MARK: - Actions
    @IBAction func closeAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

}

extension DivisionViewController:handlePanGestureDelegate {
    
    func handlePanBools(bool1: Bool, bool2: Bool,bool3:Bool,bool4:Bool) {
        if bool1 {
            touchedButton = true
        }
        if bool2 {
            game.isLocked = true
        }
        if bool3 {
            drawUI()
        }
        if bool4 {
//            self.centerView.subviews.forEach({$0.removeFromSuperview()})
        }
    }
    
    
}
