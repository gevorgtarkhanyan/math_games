//
//  Adding_3ViewController.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 6/11/21.
//

import UIKit

class Adding_3ViewController: BaseViewController {
    
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
    
    @IBOutlet var secondPartCollection: [UILabel]!
    @IBOutlet var thirdPartCollection: [UILabel]!
    @IBOutlet var fourthPartCollection: [UILabel]!
    @IBOutlet var fivethPartCollection: [UILabel]!
    @IBOutlet var sixthPartCollection: [UILabel]!
    
    @IBOutlet var firstLabelsCollection: [UILabel]!
    @IBOutlet var secondLabelsCollection: [UILabel]!
    @IBOutlet var thirdLabelsCollection: [UILabel]!
    @IBOutlet var fourthLabelsCollection: [UILabel]!
    @IBOutlet var fivethLabelsCollection: [UILabel]!
    @IBOutlet var sixthLabelsCollection: [UILabel]!
    
    @IBOutlet var resultsLabelCollection: [UILabel]!
    
    @IBOutlet weak var gameGroundView: UIView!
    @IBOutlet weak var buttonsContainerView: UIView!
    @IBOutlet var resultViewCollection: [UIStackView]!
    @IBOutlet weak var leftStackRightConstaint: NSLayoutConstraint!
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
    //    private var countsArray = [Int]()
    
    private var layoutSubviewsCount: Int! = 0
    
    private var addedView = UIView()
    private var image = UIImageView()
    private var allArray = [[UILabel]]()
    private var touchedButton = false
    private var finalCount: Int?

    static func initWithStoryboard() -> Adding_3ViewController? {
        let storyboard = UIStoryboard(name: "AddingGames", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: Adding_3ViewController.name) as? Adding_3ViewController
    }
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        AnalyticService.shared.setupAmplitude(game: "start_adding_3")
        
        setBorder()
        
//        GamesLimit.adding_3PrizCount = UserDefaults.standard.value(forKey: UserDefaultsKeys.adding_3PrizCount) as? Int ?? 0
        
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: .updateAdding_3, object: nil)
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
        gameGroundView.layer.borderColor = #colorLiteral(red: 0.9647058824, green: 0.4509803922, blue: 0, alpha: 1)
        buttonsContainerView.layer.borderWidth = 5
        buttonsContainerView.layer.borderColor = #colorLiteral(red: 0.9647058824, green: 0.4509803922, blue: 0, alpha: 1)
    }
    
    @objc func update() {
        GamesLimit.adding_3Limit = 0
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
        
        setLabelsCount(randomIndex: index)
        
        if gameType == .advance {
            allArray = [firstLabelsCollection, secondLabelsCollection, thirdLabelsCollection, fourthLabelsCollection, fivethLabelsCollection, sixthLabelsCollection]
            
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
            if leftStackRightConstaint != nil && rightStackRightConstraint != nil {
                leftStackRightConstaint.isActive = false
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
    
    private func setAnimatingViews() {
        buttonsCollection.animateFromBottom(point: CGPoint(x: 0, y: 120))
        buttonsContainerView.clipsToBounds = false
    }
    
    private func setLabelsCount(randomIndex: Range<Int>) {
        //Math - 1
        let first_1Count: Int = Random.getRandomIndex(in: randomIndex)
        firstNum_1.text = String(first_1Count)
        firstNum_1.tag = first_1Count
        
        let first_2Count: Int = Random.getRandomIndex(in: randomIndex)
        firstNum_2.text = String(first_2Count)
        firstNum_2.tag = first_2Count
        firstfinalCount = first_1Count + first_2Count
        firstNum_3.text = String(firstfinalCount)
        firstNum_3.tag = firstfinalCount
        
        //Math - 2
        let second_1Count: Int = Random.getRandomIndex(in: randomIndex)
        secondNum_1.text = String(second_1Count)
        secondNum_1.tag = second_1Count
        
        let second_2Count: Int = Random.getRandomIndex(in: randomIndex)
        secondNum_2.text = String(second_2Count)
        secondNum_2.tag = second_2Count
        secondfinalCount = second_1Count + second_2Count
        secondNum_3.text = String(secondfinalCount)
        secondNum_3.tag = secondfinalCount
        
        //Math - 3
        let third_1Count: Int = Random.getRandomIndex(in: randomIndex)
        thirdNum_1.text = String(third_1Count)
        thirdNum_1.tag = third_1Count
        
        let third_2Count: Int = Random.getRandomIndex(in: randomIndex)
        thirdNum_2.text = String(third_2Count)
        thirdNum_2.tag = third_2Count
        thirdfinalCount = third_1Count + third_2Count
        thirdNum_3.text = String(thirdfinalCount)
        thirdNum_3.tag = thirdfinalCount
        
        //Math - 4
        let fourth_1Count: Int = Random.getRandomIndex(in: randomIndex)
        fourthNum_1.text = String(fourth_1Count)
        fourthNum_1.tag = fourth_1Count
        
        let fourth_2Count: Int = Random.getRandomIndex(in: randomIndex)
        fourthNum_2.text = String(fourth_2Count)
        fourthNum_2.tag = fourth_2Count
        fourthfinalCount = fourth_1Count + fourth_2Count
        fourthNum_3.text = String(fourthfinalCount)
        fourthNum_3.tag = fourthfinalCount
        
        //Math - 5
        let fiveth_1Count: Int = Random.getRandomIndex(in: randomIndex)
        fivethNum_1.text = String(fiveth_1Count)
        fivethNum_1.tag = fiveth_1Count
        
        let fiveth_2Count: Int = Random.getRandomIndex(in: randomIndex)
        fivethNum_2.text = String(fiveth_2Count)
        fivethNum_2.tag = fiveth_2Count
        fivethfinalCount = fiveth_1Count + fiveth_2Count
        fivethNum_3.text = String(fivethfinalCount)
        fivethNum_3.tag = fivethfinalCount
        
        //Math - 6
        let sixth_1Count: Int = Random.getRandomIndex(in: randomIndex)
        sixthNum_1.text = String(sixth_1Count)
        sixthNum_1.tag = sixth_1Count
        
        let sixth_2Count: Int = Random.getRandomIndex(in: randomIndex)
        sixthNum_2.text = String(sixth_2Count)
        sixthNum_2.tag = sixth_2Count
        sixthfinalCount = sixth_1Count + sixth_2Count
        sixthNum_3.text = String(sixthfinalCount)
        sixthNum_3.tag = sixthfinalCount
    }
    
    private func setupButtonsImage() {
        var max = 0
        if gameType == .beginner {
            max = 11
        } else {
            max = 21
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
    
    @objc func gestureButtonAction(gesture: UIPanGestureRecognizer) {
        fourOrMoreButtonPanGesture(gesture: gesture, gamesLimit: GamesLimit.adding_3Limit, resultSpace: UIImageView(), finalCount: 0, firstView: prizContainerView as! UIImageView, secondView: prizImageView, gamesType: "Adding_3ViewController",containerView: UIView(), imageView: UIImageView(), imageCollection: [UIImageView](), stackViewCollection: resultViewCollection,gamesTypeForLimit: "adding_3Limit", viewCollection: [UIView]())
        delegate = self
    }

    //MARK: - Actions
    @IBAction func closeAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
extension Adding_3ViewController:handlePanGestureDelegate {
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
