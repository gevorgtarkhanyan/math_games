//
//  FindRightNumberController.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 12.07.21.
//

import UIKit

class FindRightNumberController: BaseViewController {
    
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
    @IBOutlet var imageViewCollection: [UIImageView]!
    @IBOutlet weak var prizCountainerView: UIView!
    @IBOutlet weak var prizImageView: UIImageView!
    @IBOutlet weak var gameGroundView: UIView!
    @IBOutlet weak var buttonsContainerView: UIView!
    @IBOutlet weak var containerTopConstraint: NSLayoutConstraint!
    
    //MARK: - Properties

    var game: Game!

    private var resultCGPoint: CGPoint!
    private var layoutSubviewsCount: Int! = 0
    private var finalCount = 0
    private var nilImageArray = [UIImageView]()
    private var image = UIImageView()
    private var touchedButton = false

    static func initWithStoryboard() -> FindRightNumberController? {
        let storyboard = UIStoryboard(name: "CountingGames", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: FindRightNumberController.name) as? FindRightNumberController
    }
       
    //MARK: - ViewDidLoad
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
        firstButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        secondButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        thirdButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        fourthButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        fivethButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        sixthButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        seventhButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: .updateFindNumber, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIScreen.main.bounds.height >= 1000 {
            containerTopConstraint.constant = 330
        }
        
        if layoutSubviewsCount == 1 {
            drawUI()
        }
        layoutSubviewsCount += 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.post(name: .closeDifficultControl, object: nil)
    }
    
    //MARK: - Functions
    @objc func update() {
        buttonsCollection.forEach({$0.transform = .identity})
        buttonsCollection.forEach({$0.alpha = 1})
        imageViewCollection.forEach({$0.alpha = 1})
        GamesLimit.findNumberLimit = 0
        drawUI()
    }
    
    private func setFinger() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
            if !self.touchedButton {
                for i in self.buttonsCollection {
                    if i.tag == self.finalCount {
                        let pointX = i.globalFrame.origin.x - 10
                        let pointY = i.globalFrame.origin.y + 25
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
    
    private func drawUI() {
        configureImageView()
        setupButtonsImage()
        setAnimatingViews()
        
        touchedButton = false
        
        if GamesLimit.isShowHunt {
            workItem = DispatchWorkItem { self.setFinger() }
            DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: workItem)
        }
    }
    
    private func configureImageView() {
        var limit_4Array: [Int] = []
        
        let count: Int = 4
        let minNumber: Int = 0
        let maxNumber: Int = 10
     
        let numbers: [Int] = [Int](minNumber...maxNumber)
        
        let number: Int = Random.getRandomIndex(in: 0..<(maxNumber - 2))
        
        for i in number..<(number+count) {
            limit_4Array.append(numbers[i])
        }
        
        firstImage.image = UIImage(named: "btn_\(limit_4Array[0])")
        firstImage.tag = limit_4Array[0]
        secondImage.image = UIImage(named: "btn_\(limit_4Array[1])")
        secondImage.tag = limit_4Array[1]
        thirdImage.image = UIImage(named: "btn_\(limit_4Array[2])")
        thirdImage.tag = limit_4Array[2]
        fourthImage.image = UIImage(named: "btn_\(limit_4Array[3])")
        fourthImage.tag = limit_4Array[3]
        
        let shuffle = imageViewCollection.shuffled()
        image = shuffle[0]
        finalCount = image.tag
        resultCGPoint = image.globalFrame.origin
        image.image = UIImage(named: "nilButton")
        nilImageArray.append(image)
    }
    
    private func setupButtonsImage() {
        let max = 10
        var indexes = [finalCount]
        for _ in 0..<6 {
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
    
    private func setAnimatingViews() {
        imageViewCollection.forEach({$0.changeSizeImageWithAnimate()})
        buttonsCollection.animateFromBottom(point: CGPoint(x: 0, y: 120))
    }
    @objc func gestureButtonAction(gesture: UIPanGestureRecognizer) {
        fourOrMoreButtonPanGesture(gesture: gesture, gamesLimit: GamesLimit.findNumberLimit, resultSpace: firstImage, finalCount: finalCount, firstView: prizCountainerView as! UIImageView, secondView: prizImageView, gamesType: "FindRightNumberController",containerView: UIView(), imageView: image, imageCollection: [UIImageView](), stackViewCollection: [UIStackView](),gamesTypeForLimit: "findNumberLimit", viewCollection: [UIView]())
        delegate = self
    }
    //MARK: - Actions
    
    
    
    @IBAction func closeAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}
extension FindRightNumberController:handlePanGestureDelegate {
    
    
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
            self.imageViewCollection.forEach({$0.alpha = 1})
        }
    }
}
