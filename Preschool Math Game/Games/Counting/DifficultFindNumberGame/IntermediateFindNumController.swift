//
//  IntermediateFindNumController.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 14.07.21.
//

import UIKit

class IntermediateFindNumController: BaseViewController {
    //MARK: - Outlets

    @IBOutlet var buttonsCollection: [UIButton]!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    @IBOutlet weak var fivethButton: UIButton!
    @IBOutlet weak var sixthButton: UIButton!
    @IBOutlet weak var seventhButton: UIButton!
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var thirdImage: UIImageView!
    @IBOutlet weak var fourthImage: UIImageView!
    @IBOutlet weak var fivethImage: UIImageView!
    @IBOutlet weak var sixthImage: UIImageView!
    @IBOutlet weak var seventhImage: UIImageView!
    @IBOutlet weak var eighthImage: UIImageView!
    @IBOutlet var imageViewCollection: [UIImageView]!
    @IBOutlet weak var prizCountainerView: UIView!
    @IBOutlet weak var prizImageView: UIImageView!
    @IBOutlet weak var gameGroundView: UIView!
    @IBOutlet weak var buttonsContainerView: UIView!
    @IBOutlet var firstNumbersGroup: [UIImageView]!
    @IBOutlet var secondNumbersGroup: [UIImageView]!
    @IBOutlet weak var containerTopConstraint: NSLayoutConstraint!
    
    //MARK: - Properties

    var game: Game!

    private var resultCGPoint: CGPoint!
    private var layoutSubviewsCount: Int! = 0
    private var finalCounts = [Int]()
    private var allArray = [[UIImageView]]()
    private var guessed = false { didSet {
        if guessed == true {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [self] _ in
                guessed = false
                if GamesLimit.isShowHunt {
                    workItem = DispatchWorkItem { self.setFinger() }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: workItem)
                }
            }
        }
    }
    }

    static func initWithStoryboard() -> IntermediateFindNumController? {
        let storyboard = UIStoryboard(name: "CountingGames", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: IntermediateFindNumController.name) as? IntermediateFindNumController
    }
    
    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        gameGroundView.layer.borderWidth = 5
        gameGroundView.layer.borderColor = #colorLiteral(red: 0.4980392157, green: 0.2823529412, blue: 0.7647058824, alpha: 1)
        buttonsContainerView.layer.borderWidth = 5
        buttonsContainerView.layer.borderColor = #colorLiteral(red: 0.4980392157, green: 0.2823529412, blue: 0.7647058824, alpha: 1)
        
//        GamesLimit.findNumberPrizCount = UserDefaults.standard.value(forKey: UserDefaultsKeys.findNumberPrizCount) as? Int ?? 0
        
        firstButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        secondButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        thirdButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        fourthButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        fivethButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        sixthButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        seventhButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: .updateFindNumber, object: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if UIScreen.main.bounds.height >= 1000 {
            containerTopConstraint.constant = 320
        }
        
        if layoutSubviewsCount == 1 { drawUI() }

        layoutSubviewsCount += 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.post(name: .closeDifficultControl, object: nil)
    }
    
    //MARK: - Functions

    private func setFinger() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [self] _ in
            if !guessed {
                for button in buttonsCollection {
                    if !rightAnswers.isEmpty {
                        if button.tag == rightAnswers[0] {
                            let pointX = button.globalFrame.origin.x - 10
                            let pointY = button.globalFrame.origin.y + 25
                            setFinger(button: button, pointX: pointX, pointY: pointY, btnWidth: 60, btnHeight: 60)
                            removeFinger()
                        } else { continue }
                    }
                }
            } else { return }
        }
    }

    private func removeFinger() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [self] _ in
            fingerArray.forEach({$0.removeFromSuperview()})
            fingerArray.removeAll()
            if !guessed { setFinger() }
            return
        }
    }
    
    @objc func update() {
        buttonsCollection.forEach({$0.transform = .identity})
        buttonsCollection.forEach({$0.alpha = 1})
        imageViewCollection.forEach({$0.alpha = 1})
        GamesLimit.findNumberLimit = 0
        drawUI()
    }
    
    private func drawUI() {
        configureImageView()
        setupButtonsImage()
        setAnimatingViews()
        rightAnswersCount = 0
        guessed = false
        if let item = workItem { item.cancel() }
        
        if GamesLimit.isShowHunt {
            workItem = DispatchWorkItem { self.setFinger() }
            DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: workItem)
        }
    }
    
    private func configureImageView() {
        var FirstLimit_4Array: [Int] = []
        var secondLimit_4Array: [Int] = []
        
        let count: Int = 4
        let minNumber: Int = 0
        let maxNumber: Int = 10
        
        let numbers: [Int] = [Int](minNumber...maxNumber)
        
        let firstNumber: Int = Random.getRandomIndex(in: 0..<(maxNumber - 2))
        let secondNumber: Int = Random.getRandomIndex(in: 0..<(maxNumber - 2), ignore: firstNumber)
        
        for i in firstNumber..<(firstNumber + count) {
            FirstLimit_4Array.append(numbers[i])
        }
        for i in secondNumber..<(secondNumber + count) {
            secondLimit_4Array.append(numbers[i])
        }
        
        firstImage.image = UIImage(named: "btn_\(FirstLimit_4Array[0])")
        firstImage.tag = FirstLimit_4Array[0]
        secondImage.image = UIImage(named: "btn_\(FirstLimit_4Array[1])")
        secondImage.tag = FirstLimit_4Array[1]
        thirdImage.image = UIImage(named: "btn_\(FirstLimit_4Array[2])")
        thirdImage.tag = FirstLimit_4Array[2]
        fourthImage.image = UIImage(named: "btn_\(FirstLimit_4Array[3])")
        fourthImage.tag = FirstLimit_4Array[3]
        
        fivethImage.image = UIImage(named: "btn_\(secondLimit_4Array[0])")
        fivethImage.tag = secondLimit_4Array[0]
        sixthImage.image = UIImage(named: "btn_\(secondLimit_4Array[1])")
        sixthImage.tag = secondLimit_4Array[1]
        seventhImage.image = UIImage(named: "btn_\(secondLimit_4Array[2])")
        seventhImage.tag = secondLimit_4Array[2]
        eighthImage.image = UIImage(named: "btn_\(secondLimit_4Array[3])")
        eighthImage.tag = secondLimit_4Array[3]
        
        allArray = [firstNumbersGroup, secondNumbersGroup]
        for imagesArray in allArray {
            let shuffle = imagesArray.shuffled()
            let img = shuffle[0]
            img.image = UIImage(named: "nilButton")
            finalCounts.append(img.tag)
        }
    }
    
    private func setupButtonsImage() {
        let max = 10
        var indexes = finalCounts
        for _ in 0..<5 {
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
        rightAnswers.removeAll()
        rightAnswers.append(finalCounts[0])
        rightAnswers.append(finalCounts[1])
        finalCounts.removeAll()
    }
    
    
    private func setAnimatingViews() {
        imageViewCollection.forEach({$0.changeSizeImageWithAnimate()})
        buttonsCollection.animateFromBottom(point: CGPoint(x: 0, y: 120))
    }
    @objc func gestureButtonAction(gesture: UIPanGestureRecognizer) {
        fourOrMoreButtonPanGesture(gesture: gesture, gamesLimit: GamesLimit.findNumberLimit, resultSpace: firstImage, finalCount: 0, firstView: prizCountainerView as! UIImageView, secondView: prizImageView, gamesType: "IntermediateFindNumController",containerView: UIView(), imageView: UIImageView(), imageCollection: imageViewCollection, stackViewCollection: [UIStackView](),gamesTypeForLimit: "findNumberLimit", viewCollection: [UIView]())
        delegate = self
    }
    //MARK: - Actions

    @IBAction func closeAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
extension IntermediateFindNumController:handlePanGestureDelegate {
    func handlePanBools(bool1: Bool, bool2: Bool,bool3:Bool,bool4:Bool) {
        if bool1 {
            guessed = true
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
            self.imageViewCollection.forEach({$0.alpha = 1})
        }
    }
}
