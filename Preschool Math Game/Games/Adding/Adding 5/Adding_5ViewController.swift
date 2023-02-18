//
//  Adding_5ViewController.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 27.09.21.
//

import UIKit

class Adding_5ViewController: BaseViewController {
    
    @IBOutlet weak var firstNum: UILabel!
    @IBOutlet weak var secondNum: UILabel!
    @IBOutlet weak var resultFirstNum: UILabel!
    @IBOutlet weak var resultSecondNum: UILabel!
    @IBOutlet var buttonsCollection: [UIButton]!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    @IBOutlet weak var fivethButton: UIButton!
    @IBOutlet weak var sixethButton: UIButton!
    @IBOutlet var resultViews: [UIView]!
    @IBOutlet weak var firstResultView: UIView!
    @IBOutlet weak var secondResultView: UIView!
    @IBOutlet var resultLabelCollection: [UILabel]!
    @IBOutlet weak var gameGroundView: UIView!
    @IBOutlet weak var buttonsContainerView: UIView!
    @IBOutlet weak var prizContainerView: UIImageView!
    @IBOutlet weak var prizImageView: UIImageView!
    @IBOutlet weak var containerTopConstraint: NSLayoutConstraint!

    var game: Game!
    private var finalCount = 0
    private var touchedButton = false

    static func initWithStoryboard() -> Adding_5ViewController? {
        let storyboard = UIStoryboard(name: "AddingGames", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: Adding_5ViewController.name) as? Adding_5ViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBorder()
        setLabelsCount()
        setupButtons()
        
//        GamesLimit.adding_5PrizCount = UserDefaults.standard.value(forKey: UserDefaultsKeys.adding_5PrizCount) as? Int ?? 0
        
        firstButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        secondButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        thirdButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        fourthButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        fivethButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        sixethButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: .updateAdding_5, object: nil)
        
        touchedButton = false
        
        if GamesLimit.isShowHunt {
            workItem = DispatchWorkItem { self.setFinger() }
            DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: workItem)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.post(name: .closeDifficultControl, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIScreen.main.bounds.height >= 1000 {
            containerTopConstraint.constant = 350
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setFinger() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
            if !self.touchedButton {
                for i in self.buttonsCollection {
                    if i.tag == self.result_2 {
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
    
    private func setBorder() {
        gameGroundView.layer.borderWidth = 5
        gameGroundView.layer.borderColor = #colorLiteral(red: 1, green: 0.7058823529, blue: 0.231372549, alpha: 1)
        buttonsContainerView.layer.borderWidth = 5
        buttonsContainerView.layer.borderColor = #colorLiteral(red: 1, green: 0.7058823529, blue: 0.231372549, alpha: 1)
        
        resultViews.forEach { item in
            
            item.layer.cornerRadius = 5
            item.layer.borderWidth = 3
            item.layer.borderColor = #colorLiteral(red: 1, green: 0.7058823529, blue: 0.231372549, alpha: 1)
        }
    }
    
    @objc func update() {
        GamesLimit.addingSubMixLimit = 0
        updateUI()
    }
    
    private func setLabelsCount() {
        let firstRandomNumber = 10..<100
        let secondRandomNumber = 10..<100
        
        let randomCount: [Int] = Random.getTwoRandomNumbers(firstNum: firstRandomNumber, secondNum: secondRandomNumber)
        
        firstNum.text = String(randomCount[0])
        secondNum.text = String(randomCount[1])
        
        finalCount = randomCount[0] + randomCount[1]
        
        let string = String(finalCount)
        
        let digits = string.digits
        result_1 = digits[0]
        firstResultView.tag = result_1
        result_2 = digits[1]
        secondResultView.tag = result_2
        
        resultFirstNum.text = String(result_1)
        resultSecondNum.text = String(result_2)
    }
    
    private func setupButtons() {
        let max = 9
        var maxRez = 4
        var indexes = [result_1, result_2]
        
        if finalCount >= 100 {
            maxRez = 3
            indexes.append(result_3)
        }
        
        for _ in 0..<maxRez {
            let random: Int = Random.getRandomIndex(in: 0..<max, ignoredIndexes: indexes)
            indexes.append(random)
        }
        
        indexes = indexes.shuffled()
        
        for i in 0..<indexes.count {
            let number: Int = indexes[i]
            let imageName: String = "btn_\(number)"
            let image: UIImage = UIImage(named: imageName)!
            let button = buttonsCollection[i]
            button.setImage(image, for: .normal)
            button.tag = number
        }
    }
    
    private func updateUI() {
        setLabelsCount()
        setupButtons()
        trueCount = 0
        self.audio.playWinSound()
        
        buttonsCollection.forEach({$0.alpha = 1})
        buttonsCollection.forEach({$0.transform = .identity})
        resultLabelCollection.forEach({$0.isHidden = true})
    }
    
    @objc func gestureButtonAction(gesture: UIPanGestureRecognizer) {
        fourOrMoreButtonPanGesture(gesture: gesture, gamesLimit: GamesLimit.adding_5Limit, resultSpace: UIImageView(), finalCount: finalCount, firstView: prizContainerView!, secondView: prizImageView, gamesType: "Adding_5ViewController",containerView: UIView(), imageView: UIImageView(), imageCollection: [UIImageView](), stackViewCollection: [UIStackView](),gamesTypeForLimit: "adding_5Limit", viewCollection: resultViews)
        delegate = self
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
extension Adding_5ViewController:handlePanGestureDelegate {
    func handlePanBools(bool1: Bool, bool2: Bool,bool3:Bool,bool4:Bool) {
        if bool1 {
            touchedButton = true
        }
        if bool2 {
            game.isLocked = true
        }
        if bool3 {
            updateUI()
        }
        if bool4 {
            
        }
    }
}

