//
//  Subtracting_5AdvancedController.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 28.09.21.
//

import UIKit

class Subtracting_5AdvancedController: BaseViewController {

    @IBOutlet weak var firstNum: UILabel!
    @IBOutlet weak var secondNum: UILabel!
    @IBOutlet weak var resultFirstNum: UILabel!
    @IBOutlet weak var resultSecondNum: UILabel!
    @IBOutlet weak var resultThirdNum: UILabel!
    @IBOutlet weak var resultFourthNum: UILabel!
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
    @IBOutlet weak var thirdResultView: UIView!
    @IBOutlet weak var fourthResultView: UIView!
    @IBOutlet var resultLabelCollection: [UILabel]!
    @IBOutlet weak var gameGroundView: UIView!
    @IBOutlet weak var buttonsContainerView: UIView!
    @IBOutlet weak var prizContainerView: UIImageView!
    @IBOutlet weak var prizImageView: UIImageView!
    @IBOutlet weak var containerTopConstraint: NSLayoutConstraint!

    var game: Game!
    private var finalCount = 0
    private var touchedButton = false

    static func initWithStoryboard() -> Subtracting_5AdvancedController? {
        let storyboard = UIStoryboard(name: "SubtractingGames", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: Subtracting_5AdvancedController.name) as? Subtracting_5AdvancedController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setBorder()
        setLabelsCount()
        setupButtons()
        
//        GamesLimit.subtracting_5PrizCount = UserDefaults.standard.value(forKey: UserDefaultsKeys.subtracting_5PrizCount) as? Int ?? 0
        
        firstButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        secondButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        thirdButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        fourthButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        fivethButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        sixethButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: .updateSubtracting_5, object: nil)
        
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
        var lastNumber = 0
        if finalCount >= 1000 {
            lastNumber = result_4
        } else if finalCount >= 100 && finalCount < 1000 {
            lastNumber = result_3
        } else if finalCount >= 10 && finalCount < 100 {
            lastNumber = result_2
        } else if finalCount < 10 {
            lastNumber = result_1
        }
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
            if !self.touchedButton {
                for i in self.buttonsCollection {
                    if i.tag == lastNumber {
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
        GamesLimit.subtracting_5Limit = 0
        updateUI()
    }
    
    private func setLabelsCount() {
        let firstRandomNumber = 1000..<10000
        let firstCounts = Random.getRandomIndex(in: firstRandomNumber)
        firstNum.text = String(firstCounts!)
        
        let secondRandomNumber = 1000..<10000
        let secondCount: Int = Random.getRandomIndex(in: secondRandomNumber)
        secondNum.text = String(secondCount)
        
        if secondCount >= firstCounts! {
            setLabelsCount()
        } else {
            
            finalCount = firstCounts! - secondCount
            
            let string = String(finalCount)
            let digits = string.digits

            if finalCount >= 1000 {
                //Result's first digit
                result_1 = digits[0]
                firstResultView.tag = result_1
                resultFirstNum.text = String(result_1)
                //Result's second digit
                result_2 = digits[1]
                secondResultView.tag = result_2
                resultSecondNum.text = String(result_2)
                //Result's third digit
                result_3 = digits[2]
                thirdResultView.tag = result_3
                resultThirdNum.text = String(result_3)
                //Result's fourth digit
                result_4 = digits[3]
                fourthResultView.tag = result_4
                resultFourthNum.text = String(result_4)
                
                secondResultView.isHidden = false
                thirdResultView.isHidden = false
                fourthResultView.isHidden = false
                
            } else if finalCount >= 100 && finalCount < 1000 {
                result_1 = digits[0]
                firstResultView.tag = result_1
                resultFirstNum.text = String(result_1)
                
                result_2 = digits[1]
                secondResultView.tag = result_2
                resultSecondNum.text = String(result_2)
                
                result_3 = digits[2]
                thirdResultView.tag = result_3
                resultThirdNum.text = String(result_3)
                
                fourthResultView.isHidden = true
                
            } else if finalCount >= 10 && finalCount < 100 {
                result_1 = digits[0]
                firstResultView.tag = result_1
                resultFirstNum.text = String(result_1)
                
                result_2 = digits[1]
                secondResultView.tag = result_2
                resultSecondNum.text = String(result_2)
                
                thirdResultView.isHidden = true
                fourthResultView.isHidden = true
            
            } else if finalCount < 10 {
                result_1 = digits[0]
                firstResultView.tag = result_1
                resultFirstNum.text = String(result_1)
                secondResultView.isHidden = true
                thirdResultView.isHidden = true
                fourthResultView.isHidden = true
            }
        }
    }
    
    private func setupButtons() {
        let max = 9
        var maxRez = 2
        var indexes = [result_1, result_2, result_3, result_4]
        
        if finalCount >= 10000 {
            maxRez = 1
            indexes.append(result_5)
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
        fourOrMoreButtonPanGesture(gesture: gesture, gamesLimit: GamesLimit.subtracting_5Limit, resultSpace: UIImageView(), finalCount: finalCount, firstView: prizContainerView!, secondView: prizImageView, gamesType: "Subtracting_5AdvancedController",containerView: UIView(), imageView: UIImageView(), imageCollection: [UIImageView](), stackViewCollection: [UIStackView](),gamesTypeForLimit: "subtracting_5Limit", viewCollection: resultViews)
        delegate = self
    }
    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension Subtracting_5AdvancedController:handlePanGestureDelegate {
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
