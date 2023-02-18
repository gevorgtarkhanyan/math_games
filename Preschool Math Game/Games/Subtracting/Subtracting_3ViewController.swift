//
//  Subtracting_3ViewController.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 6/17/21.
//

import UIKit

class Subtracting_3ViewController: BaseViewController {

    //MARK: - Outlets
    @IBOutlet weak var firstNum_1: UILabel!
    @IBOutlet weak var firstNum_2: UILabel!
    @IBOutlet weak var firstNum_3: UILabel!
    @IBOutlet weak var secondNum_1: UILabel!
    @IBOutlet weak var secondNum_2: UILabel!
    @IBOutlet weak var secondNum_3: UILabel!
    @IBOutlet weak var thirdNum_1: UILabel!
    @IBOutlet weak var thirdNum_2: UILabel!
    @IBOutlet weak var thirdNum_3: UILabel!
    @IBOutlet weak var fourthNum_1: UILabel!
    @IBOutlet weak var fourthNum_2: UILabel!
    @IBOutlet weak var fourthNum_3: UILabel!
    @IBOutlet weak var fivethNum_1: UILabel!
    @IBOutlet weak var fivethNum_2: UILabel!
    @IBOutlet weak var fivethNum_3: UILabel!
    @IBOutlet weak var sixthNum_1: UILabel!
    @IBOutlet weak var sixthNum_2: UILabel!
    @IBOutlet weak var sixthNum_3: UILabel!
    @IBOutlet var buttonsCollection: [UIButton]!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    @IBOutlet weak var fivethButton: UIButton!
    @IBOutlet weak var sixthButton: UIButton!
    @IBOutlet weak var seventhButton: UIButton!
    @IBOutlet var firstLabelsCollection: [UILabel]!
    @IBOutlet var secondLabelsCollection: [UILabel]!
    @IBOutlet var thirdLabelsCollection: [UILabel]!
    @IBOutlet var foruthLabelsCollection: [UILabel]!
    @IBOutlet var fivethLabelsCollection: [UILabel]!
    @IBOutlet var sixthLabelsCollection: [UILabel]!
    @IBOutlet weak var gameGroundView: UIView!
    @IBOutlet var resultsLabelCollection: [UILabel]!
    @IBOutlet weak var buttonsContainerView: UIView!
    @IBOutlet var resultViewCollection: [UIStackView]!
    @IBOutlet weak var leftStackRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightStackRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftStackLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var righStackLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var prizContainerView: UIView!
    @IBOutlet weak var prizImageView: UIImageView!
    @IBOutlet weak var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!

    //MARK: - Properties

    var game: Game!
   
    private var firstfinalCount = 0
    private var secondfinalCount = 0
    private var thirdfinalCount = 0
    private var fourthfinalCount = 0
    private var fivethfinalCount = 0
    private var sixthfinalCount = 0
    private var countsArray = [Int]()
    
    private var layoutSubviewsCount: Int! = 0
    private var finalImages: [UIImage] = []
    
    private var image = UIImageView()
    private var allArray = [[UILabel]]()
    private var touchedButton = false
    private var finalCount: Int?

    static func initWithStoryboard() -> Subtracting_3ViewController? {
        let storyboard = UIStoryboard(name: "SubtractingGames", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: Subtracting_3ViewController.name) as? Subtracting_3ViewController
    }
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        setBorder()

//        GamesLimit.subtractingFun_3PrizCount = UserDefaults.standard.value(forKey: UserDefaultsKeys.subtracting_3PrizCount) as? Int ?? 0

        resultsLabelCollection.forEach { (label) in
            if gameType == .advance {
                label.isHidden = false
            } else {
                label.isHidden = true
            }
        }

        firstButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        secondButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        thirdButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        fourthButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        fivethButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        sixthButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        seventhButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))

        NotificationCenter.default.addObserver(self, selector: #selector(update), name: .updateSubtracting_3, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        NotificationCenter.default.post(name: .closeDifficultControl, object: nil)
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
        if gameType != .advance {
            finalCount = firstfinalCount
        } else {
            finalCount = advanceViewArray.first?.tag
        }

        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
            if !self.touchedButton {
                for i in self.buttonsCollection {
                    if i.tag == self.finalCount {
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
        gameGroundView.layer.borderColor = #colorLiteral(red: 1, green: 0.7058823529, blue: 0.231372549, alpha: 1)
        buttonsContainerView.layer.borderWidth = 5
        buttonsContainerView.layer.borderColor = #colorLiteral(red: 1, green: 0.7058823529, blue: 0.231372549, alpha: 1)
    }

    @objc func update() {
        GamesLimit.subtracting_3Limit = 0
        if gameType != .advance {
            self.finalButtons.forEach({$0.removeFromSuperview()})
            self.finalButtons = []
            self.buttonsCollection.forEach({$0.alpha = 1})
            self.drawUI()
            self.buttonsCollection.forEach({$0.transform = .identity})
        } else {
            self.allArray.forEach { (label) in
                label.forEach({$0.textColor = .white})
            }
            self.finalButtons.forEach({$0.removeFromSuperview()})
            self.advanceViewArray.forEach({$0.removeFromSuperview()})
            self.advanceViewArray = []
            self.finalButtons = []
            self.buttonsCollection.forEach({$0.alpha = 1})
            self.drawUI()
            self.buttonsCollection.forEach({$0.transform = .identity})
        }
    }

    private func drawUI() {

        var index: Range<Int>
        if gameType == .beginner {
            index = 0..<6
        } else {
            index = 0..<11
        }

        setFirstLabelsCount(randomIndex: index)
        setSecondLabelsCount(randomIndex: index)
        setThirdLabelsCount(randomIndex: index)
        setFourthLabelsCount(randomIndex: index)
        setFivethLabelsCount(randomIndex: index)
        setSixthLabelsCount(randomIndex: index)

        if gameType == .advance {
            allArray = [firstLabelsCollection, secondLabelsCollection, thirdLabelsCollection, foruthLabelsCollection, fivethLabelsCollection, sixthLabelsCollection]

            for element in allArray {
                let shuffle = element.shuffled()
                let label = shuffle[0]
                label.textColor = .clear
                setInterrogativeView(labelNum: label.tag, label: label)
            }
        }
        setupButtonsImage()
        setupResultViewCount()
        setAnimatingViews()
        baseCount = 0
        
        for i in resultViewCollection {
            i.subviews.forEach({$0.alpha = 0.6})
        }

        if gameType != .advance {
            if leftStackRightConstraint != nil && rightStackRightConstraint != nil {
                leftStackRightConstraint.isActive = false
                rightStackRightConstraint.isActive = false
                leftStackLeftConstraint.constant = 20
                righStackLeftConstraint.constant = 20
                resultViewCollection.forEach({$0.distribution = .equalSpacing})
                resultViewCollection.forEach({$0.spacing = 25})
            } else {
                return
            }
        }

        touchedButton = false

        if GamesLimit.isShowHunt {
            workItem = DispatchWorkItem { self.setFinger() }
            DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: workItem)
        }
    }

    private func updateRandomIndex() {
        var index = 0..<1
        if gameType == .beginner {
            index = 0..<6
        } else {
            index = 0..<11
        }
        setFirstLabelsCount(randomIndex: index)
    }

    private func setupButtonsImage() {
        var max = 0
        if gameType == .beginner {
            max = 6
        } else {
            max = 11
        }
        var indexes = [Int]()

        if gameType != .advance {
            indexes = [firstfinalCount, secondfinalCount, thirdfinalCount, fourthfinalCount, fivethfinalCount, sixthfinalCount]
        } else {
            for i in advanceViewArray {
                indexes.append(i.tag)
            }
        }

        for _ in 0..<1 {
            let random: Int = Random.getRandomIndex(in: 1..<max, ignoredIndexes: indexes)
            indexes.append(random)
        }

        indexes = indexes.shuffled()

        for i in 0..<indexes.count {
            let number = indexes[i]
            let imageName = "btn_\(number)"
            let image = UIImage(named: imageName)!
            let button = buttonsCollection[i]
            button.alpha = 1
            button.setImage(image, for: .normal)
            button.tag = number
        }
    }

    private func setupResultViewCount() {
        var indexes = [Int]()
        if gameType != .advance {
            indexes = [firstfinalCount, secondfinalCount, thirdfinalCount, fourthfinalCount, fivethfinalCount, sixthfinalCount]

        } else {
            for i in advanceViewArray {
                indexes.append(i.tag)
            }
        }

        for i in 0..<indexes.count {
            let number = indexes[i]
            let resultView = resultViewCollection[i]
            resultView.tag = number
            
        }
    }

    private func setInterrogativeView(labelNum: Int, label: UILabel) {
        image = UIImageView()
        image.tag = labelNum
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "voprositelni_znak")
        image.frame = CGRect(x: (label.frame.width - 30) / 2, y: (label.frame.height - 30) / 2, width: 35, height: 35)
        label.addSubview(image)
        advanceViewArray.append(image)
    }

    private func setAnimatingViews() {
        buttonsCollection.animateFromBottom(point: CGPoint(x: 0, y: 120))
    }

    private func setFirstLabelsCount(randomIndex: Range<Int>) {
        //Math - 1
        firstCounts = Random.getRandomIndex(in: randomIndex)
        firstNum_1.text = String(firstCounts)
        firstNum_1.tag = firstCounts

        let first_2Count: Int = Random.getRandomIndex(in: randomIndex)
        firstNum_2.text = String(first_2Count)
        firstNum_2.tag = first_2Count
        firstNum_3.text = String(firstCounts - first_2Count)
        firstNum_3.tag = firstCounts - first_2Count

        if firstCounts < first_2Count {
            var index = 0..<1
            if gameType == .beginner {
                index = 0..<6
            } else {
                index = 0..<11
            }
            setFirstLabelsCount(randomIndex: index)
        } else {
            firstfinalCount = firstCounts - first_2Count
        }
    }

    private func setSecondLabelsCount(randomIndex: Range<Int>) {
        //Math - 2
        secondCounts = Random.getRandomIndex(in: randomIndex, ignore: firstCounts)
        secondNum_1.text = String(secondCounts)
        secondNum_1.tag = secondCounts

        let second_2Count: Int = Random.getRandomIndex(in: randomIndex)
        secondNum_2.text = String(second_2Count)
        secondNum_2.tag = second_2Count
        secondNum_3.text = String(secondCounts - second_2Count)
        secondNum_3.tag = secondCounts - second_2Count

        if secondCounts < second_2Count {
            var index = 0..<1
            if gameType == .beginner {
                index = 0..<6
            } else {
                index = 0..<11
            }
            setSecondLabelsCount(randomIndex: index)
        } else {
            secondfinalCount = secondCounts - second_2Count
        }
    }

    private func setThirdLabelsCount(randomIndex: Range<Int>) {
        //Math - 3
        thirdCounts = Random.getRandomIndex(in: randomIndex, ignoredIndexes: [firstCounts, secondCounts])
        thirdNum_1.text = String(thirdCounts)
        thirdNum_1.tag = thirdCounts

        let third_2Count: Int = Random.getRandomIndex(in: randomIndex)
        thirdNum_2.text = String(third_2Count)
        thirdNum_2.tag = third_2Count
        thirdNum_3.text = String(thirdCounts - third_2Count)
        thirdNum_3.tag = thirdCounts - third_2Count

        if thirdCounts < third_2Count {
            var index = 0..<1
            if gameType == .beginner {
                index = 0..<6
            } else {
                index = 0..<11
            }
            setThirdLabelsCount(randomIndex: index)
        } else {
            thirdfinalCount = thirdCounts - third_2Count
        }
    }

    private func setFourthLabelsCount(randomIndex: Range<Int>) {
        //Math - 4
        fourthCounts = Random.getRandomIndex(in: randomIndex, ignoredIndexes: [firstCounts, secondCounts, thirdCounts])
        fourthNum_1.text = String(fourthCounts)
        fourthNum_1.tag = fourthCounts

        let fourth_2Count: Int = Random.getRandomIndex(in: randomIndex)
        fourthNum_2.text = String(fourth_2Count)
        fourthNum_2.tag = fourth_2Count
        fourthNum_3.text = String(fourthCounts - fourth_2Count)
        fourthNum_3.tag = fourthCounts - fourth_2Count

        if fourthCounts < fourth_2Count {
            var index = 0..<1
            if gameType == .beginner {
                index = 0..<6
            } else {
                index = 0..<11
            }
            setFourthLabelsCount(randomIndex: index)
        } else {
            fourthfinalCount = fourthCounts - fourth_2Count
        }
    }

    private func setFivethLabelsCount(randomIndex: Range<Int>) {
        //Math - 5
        fivethCounts = Random.getRandomIndex(in: randomIndex, ignoredIndexes: [firstCounts, secondCounts, thirdCounts, fourthCounts])
        fivethNum_1.text = String(fivethCounts)
        fivethNum_1.tag = fivethCounts

        let fiveth_2Count: Int = Random.getRandomIndex(in: randomIndex)
        fivethNum_2.text = String(fiveth_2Count)
        fivethNum_2.tag = fiveth_2Count
        fivethNum_3.text = String(fivethCounts - fiveth_2Count)
        fivethNum_3.tag = fivethCounts - fiveth_2Count

        if fivethCounts < fiveth_2Count {
            var index = 0..<1
            if gameType == .beginner {
                index = 0..<6
            } else {
                index = 0..<11
            }
            setFivethLabelsCount(randomIndex: index)
        } else {
            fivethfinalCount = fivethCounts - fiveth_2Count
        }
    }

    private func setSixthLabelsCount(randomIndex: Range<Int>) {
        //Math - 6
        sixthCounts = Random.getRandomIndex(in: randomIndex, ignoredIndexes: [firstCounts, secondCounts, thirdCounts, fourthCounts, fivethCounts])
        sixthNum_1.text = String(sixthCounts)
        sixthNum_1.tag = sixthCounts

        let sixth_2Count: Int = Random.getRandomIndex(in: randomIndex)
        sixthNum_2.text = String(sixth_2Count)
        sixthNum_2.tag = sixth_2Count
        sixthNum_3.text = String(sixthCounts - sixth_2Count)
        sixthNum_3.tag = sixthCounts - sixth_2Count

        if sixthCounts < sixth_2Count {
            var index = 0..<1
            if gameType == .beginner {
                index = 0..<6
            } else {
                index = 0..<11
            }
            setSixthLabelsCount(randomIndex: index)
        } else {
            sixthfinalCount = sixthCounts - sixth_2Count
        }
    }

    
    @objc func gestureButtonAction(gesture: UIPanGestureRecognizer) {
        fourOrMoreButtonPanGesture(gesture: gesture, gamesLimit: GamesLimit.subtracting_3Limit, resultSpace: UIImageView(), finalCount: 0, firstView: prizContainerView as! UIImageView, secondView: prizImageView, gamesType: "Subtracting_3ViewController",containerView: UIView(), imageView: UIImageView(), imageCollection: [UIImageView](), stackViewCollection: resultViewCollection,gamesTypeForLimit: "subtracting_3Limit", viewCollection: [UIView]())
        delegate = self
    }

    //MARK: - Actions
    @IBAction func closeAction(_ sender: UIButton) {

        navigationController?.popViewController(animated: true)
    }
}
extension Subtracting_3ViewController:handlePanGestureDelegate {
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
            if gameType == .advance {
                self.allArray.forEach { (label) in
                    label.forEach({$0.textColor = .white})
                }
                self.advanceViewArray.forEach({$0.removeFromSuperview()})
                self.advanceViewArray = []
                self.buttonsCollection.forEach({$0.transform = .identity})
                self.buttonsCollection.forEach({$0.alpha = 1})
            } else {
                self.buttonsCollection.forEach({$0.transform = .identity})
                self.buttonsCollection.forEach({$0.alpha = 1})
            }
        }
    }
}
