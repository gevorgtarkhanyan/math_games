//
//  MultiplicationController.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 07.07.21.
//

import UIKit

class MultiplicationController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var firstNumber: UILabel!
    @IBOutlet weak var secondNumber: UILabel!
    @IBOutlet var buttonsCollection: [UIButton]!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var gameGroundView: UIView!
    @IBOutlet weak var resultContainerView: UIView!
    @IBOutlet weak var buttonsContainerView: UIView!
    @IBOutlet weak var resultSpace: UIImageView!
    @IBOutlet weak var prizContainerView: UIView!
    @IBOutlet weak var prizImageView: UIImageView!
    @IBOutlet weak var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerLeftConstraint: NSLayoutConstraint!
    
    //MARK: - Properties

    var game: Game!

    private var imagesArray = ["ball_image", "bluz_image", "fox_green_image", "gus_image", "squarel_image", "molor_img", "gruzavik_img", "verto_img", "sun_img", "raduga_img", "klubnyak_img", "bananas_img", "kubik_img", "xax_img", "camera_img", "new_image", "bantov_auto"]
    
    private var finalCount: Int = 0
    
    private var centerImage = UIImage()

    private var leftImage = UIImage()
    private var rightImage = UIImage()
    
    private var layoutSubviewsCount: Int! = 0
    
    private var touchedButton = false

    static func initWithStoryboard() -> MultiplicationController? {
        let storyboard = UIStoryboard(name: "MultiplicationGames", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: MultiplicationController.name) as? MultiplicationController
    }

    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        AnalyticService.shared.setupAmplitude(game: "start_multiplication_1")
        
        setBorders()
        
        GamesLimit.multiplicationLimit = UserDefaults.standard.value(forKey: UserDefaultsKeys.multiplicationLimit) as? Int ?? 0
        
        firstButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        secondButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        thirdButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        
        firstButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        secondButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        thirdButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: .updateMultiplication, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
    
    //MARK: - Functions
    private func setFinger() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
            if !self.touchedButton {
                for i in self.buttonsCollection {
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
        self.leftView.subviews.forEach({$0.removeFromSuperview()})
        self.rightView.subviews.forEach({$0.removeFromSuperview()})
        GamesLimit.multiplicationLimit = 0
        buttonsCollection.forEach({$0.transform = .identity})
        buttonsCollection.forEach({$0.alpha = 1})
        self.resultSpace.image = UIImage(named: "questionMark")
        self.drawUI()
    }
    
    private func drawUI() {
        let imageNamesRange = 0..<imagesArray.count
        let leftImageNameIndex: Int = Random.getRandomIndex(in: imageNamesRange) ?? 0
        let rightImageNameIndex : Int = Random.getRandomIndex(in: imageNamesRange, ignore: leftImageNameIndex)
        
        leftImage = getImage(with: leftImageNameIndex)
        rightImage = getImage(with: rightImageNameIndex)
        
        drawImages(image: leftImage, view: leftView)
        drawImages(image: rightImage, view: rightView)
        
        setSubViewCount()
        setupButtonsImage()
        setAnimatingViews()
        
        touchedButton = false
        
        if GamesLimit.isShowHunt {
            workItem = DispatchWorkItem { self.setFinger() }
            DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: workItem)
        }
    }
    @objc func gestureButtonAction(gesture: UIPanGestureRecognizer) {
        threeButtonPanGesture(gesture: gesture, gamesLimit: GamesLimit.multiplicationLimit, resultSpace: resultSpace, finalCount: finalCount, firstView: prizContainerView as! UIImageView, secondView: prizImageView, gamesType: "multiplicationLimit", containerView: UIView())
        delegate = self
    }
    
    private func setAnimatingViews() {
        [leftView, rightView].animateFromBottom(point: CGPoint(x: 0, y: 120))
        buttonsCollection.animateFromBottom(point: CGPoint(x: 0, y: 120))
        resultContainerView.animateFromBottom(point: CGPoint(x: 0, y: 30))
    }
    
    private func setSubViewCount() {
        finalCount = leftView.subviews.count * rightView.subviews.count
        firstNumber.text = String(leftView.subviews.count)
        secondNumber.text = String(rightView.subviews.count)
    }
    
    private func getImage(with index: Int) -> UIImage {
        
        return UIImage(named: imagesArray[index])!
    }
    
    private func setupButtonsImage() {
        let max = 11
        var indexes = [finalCount]
        for _ in 0..<2 {
            let random: Int = Random.getRandomIndex(in: 1..<max, ignoredIndexes: indexes)
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
    
    private func drawImages(image: UIImage, view: UIView) {
        let oneElement = AddingFunPositions.positionForOneElement(view: leftView)
        let twoElement = AddingFunPositions.positionForTwoElement(view: leftView)
        let threeElement = AddingFunPositions.positionForThreeElement(view: leftView)
        let fourElement = AddingFunPositions.positionForFourElement(view: leftView)
        let fiveElement = AddingFunPositions.positionForFiveElement(view: leftView)
        let count: Int = Random.getRandomIndex(in: 1..<4)
                
        if count == 1 {
            view.addImageViews(with: image, at: oneElement, count: count, width: 100, height: 100)
        } else if count == 2 {
            view.addImageViews(with: image, at: twoElement, count: count, width: 80, height: 80)
        } else if count == 3 {
            view.addImageViews(with: image, at: threeElement, count: count, width: 60, height: 60)
        } else if count == 4 {
            view.addImageViews(with: image, at: fourElement, count: count, width: 50, height: 50)
        } else if count == 5 {
            view.addImageViews(with: image, at: fiveElement, count: count, width: 50, height: 50)
        }
    }

    
    @IBAction func closeAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension MultiplicationController:handlePanGestureDelegate {
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
            self.leftView.subviews.forEach({$0.removeFromSuperview()})
            self.rightView.subviews.forEach({$0.removeFromSuperview()})
        }
    }
}
