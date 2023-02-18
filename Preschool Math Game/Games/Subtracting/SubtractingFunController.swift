//
//  AddingFunController.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 5/5/21.
//

import UIKit

class SubtractingFunController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var firstNumber: UILabel!
    @IBOutlet weak var secondNumber: UILabel!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet var buttonsCollection: [UIButton]!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var gameGroundView: UIView!
    @IBOutlet weak var resultContainerView: UIView!
    @IBOutlet weak var buttonsContainerView: UIView!
    @IBOutlet weak var resultPlace: UIImageView!
    @IBOutlet weak var prizContainerView: UIView!
    @IBOutlet weak var prizImageView: UIImageView!
    @IBOutlet weak var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerLeftConstraint: NSLayoutConstraint!
    
    //MARK: - Properties
    private var imagesArray = ["vertyux", "priz_img_1", "priz_img_5", "priz_img_6", "priz_img_7", "arjuk", "crar", "kanfet", "puchik"]
    
    var game: Game!
    private var finalCount = 0
    private var withoutAlphaCount = 0
    private var withAlphaCount = 0
    private var centerImage = UIImage()
    private var centerImageView = UIView()
    private var layoutSubviewsCount = 0
    private var touchedButton = false
    
    static func initWithStoryboard() -> SubtractingFunController? {
        let storyboard = UIStoryboard(name: "SubtractingGames", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: SubtractingFunController.name) as? SubtractingFunController
    }
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        AnalyticService.shared.setupAmplitude(game: "start_subtracting_1")
        
        setBorders()
        
        //        GamesLimit.subtractingFunPrizCount = UserDefaults.standard.value(forKey: UserDefaultsKeys.subtractingPrizCount) as? Int ?? 0
        
        firstButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        secondButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        thirdButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        firstButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        secondButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        thirdButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: .updateSubtracting, object: nil)
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
        self.centerView.subviews.forEach({$0.removeFromSuperview()})
        GamesLimit.subtractingLimit = 0
        buttonsCollection.forEach({$0.transform = .identity})
        buttonsCollection.forEach({$0.alpha = 1})
        self.resultPlace.image = UIImage(named: "questionMark")
        self.drawUI()
    }
    
    private func drawUI() {
        let imageNamesRange = 0..<imagesArray.count
        let centerImageNameIndex: Int = Random.getRandomIndex(in: imageNamesRange) ?? 0
        let centerViewIndex: Int = Random.getRandomIndex(in: imageNamesRange) ?? 0
        
        centerImage = getImage(with: centerImageNameIndex)
        centerImageView = getView(with: centerViewIndex)
        
        drawImages(image: centerImage)
        drawView(view: centerImageView)
        
        setAnimatingViews()
        
        setSubViewCount()
        setupButtonsImage()
        
        touchedButton = false
        
        if GamesLimit.isShowHunt {
            workItem = DispatchWorkItem { self.setFinger() }
            DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: workItem)
        }
    }
    @objc func gestureButtonAction(gesture: UIPanGestureRecognizer) {
        threeButtonPanGesture(gesture: gesture, gamesLimit: GamesLimit.subtractingLimit, resultSpace: resultPlace, finalCount: finalCount, firstView: prizContainerView as! UIImageView, secondView: prizImageView, gamesType: "subtractingLimit", containerView: UIView())
        delegate = self
    }
    
    private func setAnimatingViews() {
        [centerView].animateFromBottom(point: CGPoint(x: 0, y: 120))
        buttonsCollection.animateFromBottom(point: CGPoint(x: 0, y: 120))
        resultContainerView.animateFromBottom(point: CGPoint(x: 0, y: 30))
    }
    
    private func setSubViewCount() {
        finalCount = withoutAlphaCount - withAlphaCount
        
        firstNumber.text = String(withoutAlphaCount)
        secondNumber.text = String(withAlphaCount)
    }
    
    private func getImage(with index: Int) -> UIImage {
        
        return UIImage(named: imagesArray[index])!
    }
    
    private func getView(with index: Int) -> UIView {
        return UIView()
    }
    
    private func setupButtonsImage() {
        let max = 11
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
            let button = buttonsCollection[i]
            button.setImage(image, for: .normal)
            button.tag = number
        }
    }
    
    //    private func randomImages() {
    //        for i in 0..<imageArray.count {
    //            if Int.random(in: 0...2) == 0 {
    //                let arrayElement = imageArray[0]
    //                imageArray[0] = imageArray[i]
    //                imageArray[i] = arrayElement
    //            }
    //        }
    //    }
    
    private func drawImages(image: UIImage) {
        let count: Int = Random.getRandomIndex(in: 1..<11)
        let oneElement = SubtractingFunPositions.positionForOneElement(view: centerView)
        let twoElement = SubtractingFunPositions.positionForTwoElement(view: centerView)
        let threeElement = SubtractingFunPositions.positionForThreeElement(view: centerView)
        let foureElement = SubtractingFunPositions.positionForFoureElement(view: centerView)
        let fiveElement = SubtractingFunPositions.positionForFiveElement(view: centerView)
        let sixElement = SubtractingFunPositions.positionForSixElement(view: centerView)
        let sevenElement = SubtractingFunPositions.positionForSevenElement(view: centerView)
        let eightElement = SubtractingFunPositions.positionForEightElement(view: centerView)
        let nineElement = SubtractingFunPositions.positionForNineElement(view: centerView)
        let tenElement = SubtractingFunPositions.positionForTenElement(view: centerView)
        if count == 1 {
            centerView.addImageViews(with: image, at: oneElement, count: count, width: 100, height: 100)
            
        } else if count == 2 {
            centerView.addImageViews(with: image, at: twoElement, count: count, width: 100, height: 100)
        } else if count == 3 {
            centerView.addImageViews(with: image, at: threeElement, count: count, width: 100, height: 100)
        } else if count == 4 {
            centerView.addImageViews(with: image, at: foureElement, count: count, width: 100, height: 100)
        } else if count == 5 {
            centerView.addImageViews(with: image, at: fiveElement, count: count, width: 90, height: 90)
        } else if count == 6 {
            centerView.addImageViews(with: image, at: sixElement, count: count, width: 90, height: 90)
        } else if count == 7 {
            centerView.addImageViews(with: image, at: sevenElement, count: count, width: 70, height: 70)
        } else if count == 8 {
            centerView.addImageViews(with: image, at: eightElement, count: count, width: 70, height: 70)
        } else if count == 9 {
            centerView.addImageViews(with: image, at: nineElement, count: count, width: 50, height: 50)
        } else if count == 10 {
            centerView.addImageViews(with: image, at: tenElement, count: count, width: 50, height: 50)
        }
        
        withoutAlphaCount = count
    }
    
    private func drawView(view: UIView) {
        var count = 0
        let oneElement = SubtractingFunPositions.positionForOneElement(view: centerView)
        let twoElement = SubtractingFunPositions.positionForTwoElement(view: centerView)
        let threeElement = SubtractingFunPositions.positionForThreeElement(view: centerView)
        let foureElement = SubtractingFunPositions.positionForFoureElement(view: centerView)
        let fiveElement = SubtractingFunPositions.positionForFiveElement(view: centerView)
        let sixElement = SubtractingFunPositions.positionForSixElement(view: centerView)
        let sevenElement = SubtractingFunPositions.positionForSevenElement(view: centerView)
        let eightElement = SubtractingFunPositions.positionForEightElement(view: centerView)
        let nineElement = SubtractingFunPositions.positionForNineElement(view: centerView)
        let tenElement = SubtractingFunPositions.positionForTenElement(view: centerView)
        let viewWithAlphaCount: Int = Random.getRandomIndex(in: 0..<11)
        if viewWithAlphaCount > withoutAlphaCount {
            firstNumber.text = nil
            secondNumber.text = nil
            centerView.subviews.forEach({$0.removeFromSuperview()})
            drawUI()
            return
        } else {
            count = viewWithAlphaCount
        }
        if withoutAlphaCount == 1 {
            centerView.addView(with: view, at: oneElement, count: count, width: 100, height: 100)
        } else if withoutAlphaCount == 2 {
            centerView.addView(with: view, at: twoElement, count: count, width: 100, height: 100)
        } else if withoutAlphaCount == 3 {
            centerView.addView(with: view, at: threeElement, count: count, width: 100, height: 100)
        } else if withoutAlphaCount == 4 {
            centerView.addView(with: view, at: foureElement, count: count, width: 100, height: 100)
        } else if withoutAlphaCount == 5 {
            centerView.addView(with: view, at: fiveElement, count: count, width: 90, height: 90)
        } else if withoutAlphaCount == 6 {
            centerView.addView(with: view, at: sixElement, count: count, width: 90, height: 90)
        } else if withoutAlphaCount == 7 {
            centerView.addView(with: view, at: sevenElement, count: count, width: 70, height: 80)
        } else if withoutAlphaCount == 8 {
            centerView.addView(with: view, at: eightElement, count: count, width: 70, height: 80)
        } else if withoutAlphaCount == 9 {
            centerView.addView(with: view, at: nineElement, count: count, width: 50, height: 50)
        } else if withoutAlphaCount == 10 {
            centerView.addView(with: view, at: tenElement, count: count, width: 50, height: 50)
        }
        
        withAlphaCount = count
    }
    
    //MARK: - Actions
    @IBAction func closeAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension SubtractingFunController:handlePanGestureDelegate {
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
            self.centerView.subviews.forEach({$0.removeFromSuperview()})
        }
    }
}
