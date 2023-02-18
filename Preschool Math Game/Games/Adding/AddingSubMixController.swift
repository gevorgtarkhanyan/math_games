//
//  AddingSubMixController.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 6/24/21.
//

import UIKit

class AddingSubMixController: BaseViewController {

    //MARK: - Outlets
    @IBOutlet var resultViewCollection: [UIStackView]!
    @IBOutlet weak var firstNum_1: UILabel!
    @IBOutlet weak var firstNum_2: UILabel!
    @IBOutlet weak var firstNum_3: UILabel!
    @IBOutlet weak var firstOperation_1: UILabel!
    @IBOutlet weak var firstOperation_2: UILabel!
    @IBOutlet weak var secondNum_1: UILabel!
    @IBOutlet weak var secondNum_2: UILabel!
    @IBOutlet weak var secondNum_3: UILabel!
    @IBOutlet weak var secondOperation_1: UILabel!
    @IBOutlet weak var secondOperation_2: UILabel!
    @IBOutlet weak var thirdNum_1: UILabel!
    @IBOutlet weak var thirdNum_2: UILabel!
    @IBOutlet weak var thirdNum_3: UILabel!
    @IBOutlet weak var thirdOperation_1: UILabel!
    @IBOutlet weak var thirdOperation_2: UILabel!
    @IBOutlet var buttonsCollection: [UIButton]!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    @IBOutlet weak var fivethButton: UIButton!
    @IBOutlet weak var sixthButton: UIButton!
    @IBOutlet weak var firstResultView: UIStackView!
    @IBOutlet weak var secondResultView: UIStackView!
    @IBOutlet weak var thirdResultView: UIStackView!
    @IBOutlet weak var gameGroundView: UIView!
    @IBOutlet weak var butonsContainerView: UIView!
    @IBOutlet weak var prizContainerView: UIView!
    @IBOutlet weak var prizImageView: UIImageView!
    @IBOutlet weak var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!

    //MARK: - Properties
    var game: Game!
    private var layoutSubviewsCount: Int! = 0
   
    private var firstfinalCount = 0
    private var secondfinalCount = 0
    private var thirdfinalCount = 0
    private var touchedButton = false

    static func initWithStoryboard() -> AddingSubMixController? {
        let storyboard = UIStoryboard(name: "AddingGames", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: AddingSubMixController.name) as? AddingSubMixController
    }

    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        //        AnalyticService.shared.setupAmplitude(game: "start_addingMix")
        setBorder()

//        GamesLimit.addingSubMixPrizCount = UserDefaults.standard.value(forKey: UserDefaultsKeys.addingSubMixPrizCount) as? Int ?? 0

        firstButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        secondButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        thirdButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        fourthButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        fivethButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        sixthButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))

        NotificationCenter.default.addObserver(self, selector: #selector(update), name: .updateAddingSubMix, object: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if UIScreen.main.bounds.height >= 1000 {
            containerTopConstraint.constant = 300
            containerBottomConstraint.constant = 250
        }

        if layoutSubviewsCount == 1 {
            drawUI()
        }
        layoutSubviewsCount += 1
    }

    deinit { NotificationCenter.default.removeObserver(self) }
    
    //MARK: - Functions
    private func setFinger() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
            if !self.touchedButton {
                for i in self.buttonsCollection {
                    if i.tag == self.firstfinalCount {
                        let pointX = i.globalFrame.origin.x - 5
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
        gameGroundView.layer.borderColor = #colorLiteral(red: 0.9647058824, green: 0.4509803922, blue: 0, alpha: 1)
        butonsContainerView.layer.borderWidth = 5
        butonsContainerView.layer.borderColor = #colorLiteral(red: 0.9647058824, green: 0.4509803922, blue: 0, alpha: 1)
    }

    @objc func update() {
        self.finalButtons.forEach({$0.removeFromSuperview()})
        GamesLimit.addingSubMixLimit = 0
        self.finalButtons = []
        self.buttonsCollection.forEach({$0.alpha = 1})
        self.drawUI()
        self.buttonsCollection.forEach({$0.transform = .identity})
    }
    
    @objc func gestureButtonAction(gesture: UIPanGestureRecognizer) {
        fourOrMoreButtonPanGesture(gesture: gesture, gamesLimit: GamesLimit.addingSubMixLimit, resultSpace: UIImageView(), finalCount: 0, firstView: prizContainerView as! UIImageView, secondView: prizImageView, gamesType: "AddingSubMixController",containerView: UIView(), imageView: UIImageView(), imageCollection: [UIImageView](), stackViewCollection: resultViewCollection,gamesTypeForLimit: "addingSubMixLimit", viewCollection: [UIView]())
        delegate = self
    }

    private func drawUI() {
        firstOperation_1.operations(secondOperation: firstOperation_2)
        secondOperation_1.operations(secondOperation: secondOperation_2)
        thirdOperation_1.operations(secondOperation: thirdOperation_2)
        setFirstLabelsCount()
        setSecondLabelsCount()
        setThirdLabelsCount()
        setupButtonsImage()
        buttonsCollection.animateFromBottom(point: CGPoint(x: 0, y: 120))
        baseCount = 0
        
        for i in resultViewCollection {
            i.subviews.forEach({$0.alpha = 0.6})
        }

        touchedButton = false

        if GamesLimit.isShowHunt {
            workItem = DispatchWorkItem { self.setFinger() }
            DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: workItem)
        }
    }

    private func setupButtonsImage() {
        let max = 20
        var indexes = [firstfinalCount, secondfinalCount, thirdfinalCount]
        for _ in 0..<3 {
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

    private func setFirstLabelsCount() {
        //Math - 1
        let index = 0..<10
        //        let index = 0..<3
        let first_1Count: Int = Random.getRandomIndex(in: index)
        firstNum_1.text = String(first_1Count)
        firstNum_1.tag = first_1Count

        let first_2Count: Int = Random.getRandomIndex(in: index)
        firstNum_2.text = String(first_2Count)
        firstNum_2.tag = first_2Count

        let first_3Count: Int = Random.getRandomIndex(in: index)
        firstNum_3.text = String(first_3Count)
        firstNum_3.tag = first_3Count

        if firstOperation_1.tag == 0 {
            if first_2Count + first_3Count > first_1Count {
                setFirstLabelsCount()
            } else {
                firstResultView.tag = (first_1Count - first_2Count) + first_3Count
            }
        } else {
            if first_1Count + first_2Count < first_3Count {
                setFirstLabelsCount()
            } else {
                firstResultView.tag = (first_1Count + first_2Count) - first_3Count
            }
        }
        firstfinalCount = firstResultView.tag
    }

    private func setSecondLabelsCount() {
        //Math - 2
        let index = 0..<10
        //        let index = 0..<3
        let second_1Count: Int = Random.getRandomIndex(in: index)
        secondNum_1.text = String(second_1Count)
        secondNum_1.tag = second_1Count
        
        let second_2Count: Int = Random.getRandomIndex(in: index)
        secondNum_2.text = String(second_2Count)
        secondNum_2.tag = second_2Count

        let second_3Count: Int = Random.getRandomIndex(in: index)
        secondNum_3.text = String(second_3Count)
        secondNum_3.tag = second_3Count

        if secondOperation_1.tag == 0 {
            if second_2Count + second_3Count > second_1Count {
                setSecondLabelsCount()
            } else {
                secondResultView.tag = (second_1Count - second_2Count) + second_3Count
            }
        } else {
            if second_1Count + second_2Count < second_3Count {
                setSecondLabelsCount()
            } else {
                secondResultView.tag = (second_1Count + second_2Count) - second_3Count
            }
        }
        secondfinalCount = secondResultView.tag
    }

    private func setThirdLabelsCount() {
        //Math - 3
        let index = 0..<10
        //        let index = 0..<3
        let third_1Count: Int = Random.getRandomIndex(in: index)
        thirdNum_1.text = String(third_1Count)
        thirdNum_1.tag = third_1Count
        
        let third_2Count: Int = Random.getRandomIndex(in: index)
        thirdNum_2.text = String(third_2Count)
        thirdNum_2.tag = third_2Count
        
        let third_3Count: Int = Random.getRandomIndex(in: index)
        thirdNum_3.text = String(third_3Count)
        thirdNum_3.tag = third_3Count

        if thirdOperation_1.tag == 0 {
            if third_2Count + third_3Count > third_1Count {
                setThirdLabelsCount()
            } else {
                thirdResultView.tag = (third_1Count - third_2Count) + third_3Count
            }
        } else {
            if third_1Count + third_2Count < third_3Count {
                setThirdLabelsCount()
            } else {
                thirdResultView.tag = (third_1Count + third_2Count) - third_3Count
            }
        }
        thirdfinalCount = thirdResultView.tag
    }


    //MARK: - Actions
    @IBAction func closeAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
extension AddingSubMixController:handlePanGestureDelegate {
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
                self.buttonsCollection.forEach({$0.transform = .identity})
                self.buttonsCollection.forEach({$0.alpha = 1})
            
        }
    }
}
