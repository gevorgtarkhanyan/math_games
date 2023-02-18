//
//  Countong_2Controller.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 5/4/21.
//

import UIKit

class Countong_2Controller: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var gameGroundView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var buttonsCollection: [UIButton]!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fouthButton: UIButton!
    @IBOutlet weak var resultImageView: UIView!
    @IBOutlet weak var equallyIcon: UILabel!
    @IBOutlet weak var prizContainerView: UIView!
    @IBOutlet weak var prizImageView: UIImageView!
    @IBOutlet weak var resultTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    
    //MARK: - Properties

    var game: Game!

    private var imagesArray = ["bee_image", "car_image", "chicken_big_image", "delphine_image", "elephant_image", "helicopter_image", "globus_image", "giraffe_big_image", "chuchu_img", "tort_img", "basketball_image"]
    
    private var centerImage = UIImage()
    private var finalCount = 0
    private var layoutSubviewsCount = 0
    private var secondsCount = 0
    private var minuteCount = 0
//    private var timeCounting = false
    private var touchedButton = false

    static func initWithStoryboard() -> Countong_2Controller? {
        let storyboard = UIStoryboard(name: "CountingGames", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: Countong_2Controller.name) as? Countong_2Controller
    }

    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        AnalyticService.shared.setupAmplitude(game: "start_counting_2")
            
        gameGroundView.layer.borderWidth = 5
        gameGroundView.layer.borderColor = #colorLiteral(red: 0.7490196078, green: 0.1882352941, blue: 0.2156862745, alpha: 1)
        
//        GamesLimit.counting_2PrizCount = UserDefaults.standard.value(forKey: UserDefaultsKeys.counting_2PrizCount) as? Int ?? 0
        
//        timeCounting = true
//        timerCounting()
        
        firstButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        secondButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        thirdButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        fouthButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        firstButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        secondButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        thirdButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        fouthButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: .updateCounting_2, object: nil)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIScreen.main.bounds.height >= 1000 {
            resultTopConstraint.constant = 250
            containerTopConstraint.constant = 180
            containerBottomConstraint.constant = 180
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
    
    @objc func update() {
        self.containerView.subviews.forEach({$0.removeFromSuperview()})
        buttonsCollection.forEach({$0.alpha = 1})
        GamesLimit.counting_2Limit = 0
        buttonsCollection.forEach({$0.transform = .identity})
        self.resultImageView.isHidden = false
        self.drawUI()
    }
    
//    @objc func handleFirstPanGesture(gesture: UIPanGestureRecognizer) {
//        guard let button = gesture.view as? UIButton else {
//            return
//        }
//
//        if gesture.state == .began {
//            self.touchedButton = true
//            self.fingerArray.forEach({$0.removeFromSuperview()})
//            self.fingerArray.removeAll()
//
//        } else if gesture.state == .changed {
//            let translation = gesture.translation(in: self.view)
//            button.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
//        } else if gesture.state == .ended {
//            if button.tag != finalCount {
//                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseIn) {
//                    button.transform = .identity
//                    self.audio.playLoseSound()
//                } completion: { (bool) in
//                    print("FALSE!!!")
//                }
//            } else {
//                if let item = workItem {
//                    item.cancel()
//                }
//                let buttonOrigin = button.globalFrame.origin
//
//                setCloneButton(button: button, point: buttonOrigin, btnWidth: button.frame.width, btnHeight: button.frame.height)
//
//                UIView.animate(withDuration: 0.3) {
//                    self.copyButton.frame.origin = CGPoint(x: self.resultImageView.globalFrame.origin.x, y: self.resultImageView.globalFrame.origin.y)
//                    button.transform = .identity
//                }
//
//                timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { (timer) in
//                    self.resultImageView.isHidden = true
//                }
//
//                if !UserDefaults.standard.bool(forKey: UserDefaultsKeys.paymentKey) {
//                    if GamesLimit.counting_2Limit < 4 {
//                        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
//                            self.containerView.subviews.forEach({$0.removeFromSuperview()})
//                            self.finalButtons.forEach({$0.removeFromSuperview()})
//                            self.finalButtons = []
//                            button.alpha = 1
//                            button.transform = .identity
//                            self.resultImageView.isHidden = false
//                            self.audio.playWinSound()
//                            GamesLimit.counting_2Limit += 1
//                            UserDefaults.standard.setValue(GamesLimit.counting_2Limit, forKey: UserDefaultsKeys.counting_2Limit)
//                            self.drawUI()
//                        }
//
//                    } else {
////                        GamesLimit.counting_2PrizCount += 1
////                        UserDefaults.standard.setValue(GamesLimit.counting_2PrizCount, forKey: UserDefaultsKeys.counting_2PrizCount)
//                        view.bringSubviewToFront(self.prizContainerView)
//                        view.bringSubviewToFront(self.prizImageView)
//                        self.prizContainerView.isHidden = false
//                        self.prizImageView.isHidden = false
//                        self.prizImageView.changeSizeImageWithAnimate()
//
//                        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
//                            self.prizContainerView.isHidden = true
//                            self.prizImageView.isHidden = true
//                        }
//
//                        timer = Timer.scheduledTimer(withTimeInterval: 3.1, repeats: false) { (timer) in
//                            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ParentalControllController") as! ParentalControllController
//
//                            vc.fromGame = true
//                            self.addChild(vc)
//                            self.view.addSubview(vc.view)
//                            vc.didMove(toParent: self)
//
////                            NotificationCenter.default.post(name: .blockCounting_2, object: nil)
////                            UserDefaults.standard.setValue(true, forKey: UserDefaultsKeys.isLockCounting_2)
//                        }
//                    }
//                } else {
//                    if GamesLimit.counting_2Limit == 4 {
//                        GamesLimit.counting_2Limit = 0
//                        UserDefaults.standard.setValue(GamesLimit.counting_2Limit, forKey: UserDefaultsKeys.counting_2Limit)
////                        GamesLimit.counting_2PrizCount += 1
////                        UserDefaults.standard.setValue(GamesLimit.counting_2PrizCount, forKey: UserDefaultsKeys.counting_2PrizCount)
//                        view.bringSubviewToFront(self.prizContainerView)
//                        view.bringSubviewToFront(self.prizImageView)
//                        self.prizContainerView.isHidden = false
//                        self.prizImageView.isHidden = false
//                        self.prizImageView.changeSizeImageWithAnimate()
//
//                        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
//                            self.prizContainerView.isHidden = true
//                            self.prizImageView.isHidden = true
//                        }
//
//                        timer = Timer.scheduledTimer(withTimeInterval: 3.1, repeats: false) { (timer) in
//                            self.containerView.subviews.forEach({$0.removeFromSuperview()})
//                            self.finalButtons.forEach({$0.removeFromSuperview()})
//                            self.finalButtons = []
//                            button.alpha = 1
//                            button.transform = .identity
//                            self.resultImageView.isHidden = false
//                            self.audio.playWinSound()
//                            self.drawUI()
//                        }
//                    } else {
//                        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
//                            self.containerView.subviews.forEach({$0.removeFromSuperview()})
//                            self.finalButtons.forEach({$0.removeFromSuperview()})
//                            GamesLimit.counting_2Limit += 1
//                            UserDefaults.standard.setValue(GamesLimit.counting_2Limit, forKey: UserDefaultsKeys.counting_2Limit)
//                            self.finalButtons = []
//                            button.alpha = 1
//                            button.transform = .identity
//                            self.resultImageView.isHidden = false
//                            self.audio.playWinSound()
//                            self.drawUI()
//                        }
//                    }
//                }
//            }
//        }
//    }
//
    @objc func gestureButtonAction(gesture: UIPanGestureRecognizer) {
        threeButtonPanGesture(gesture: gesture, gamesLimit: GamesLimit.counting_2Limit, resultSpace: UIImageView() , finalCount: finalCount, firstView: prizContainerView as! UIImageView, secondView: prizImageView, gamesType: "counting_2Limit",containerView: resultImageView)
        delegate = self
    }
    
    private func timerCounting() {
//        if timeCounting {
//            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeCounter), userInfo: nil, repeats: true)
//
//        } else {
//            timer.invalidate()
//        }
    }
    
    @objc func timeCounter() {
        secondsCount += 1
        
//        if secondsCount <= 9 {
//            timerLabel.text = "0\(minuteCount) : 0\(secondsCount)"
//        } else {
//            timerLabel.text = "0\(minuteCount) : \(secondsCount)"
//        }
//        
//        if secondsCount == 60 {
//            secondsCount = 0
//            minuteCount += 1
//            timerLabel.text = "0\(minuteCount) : 0\(secondsCount)"
//        }
//        
//        if minuteCount >= 9 {
//            timerLabel.text = "\(minuteCount) : 0\(secondsCount)"
//        }
    }
    
    private func drawUI() {
        let imageNamesRange = 0..<imagesArray.count
        let centerImageNameIndex = Random.getRandomIndex(in: imageNamesRange) ?? 0
        
        centerImage = getImage(with: centerImageNameIndex)
        
        drawImages(image: centerImage)
        
        setupButtonsImage()
        
        setAnimatingViews()
        
        touchedButton = false
        
        touchedButton = false
        
        if GamesLimit.isShowHunt {
            workItem = DispatchWorkItem { self.setFinger() }
            DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: workItem)
        }
    }
    
    private func setAnimatingViews() {
        buttonsCollection.animateFromBottom(point: CGPoint(x: 0, y: 120))
        equallyIcon.animateFromBottom(point: CGPoint(x: 0, y: 120))
        resultImageView.animateFromBottom(duration: 0.7, point: CGPoint(x: 0, y: 120))
    }
    
    private func getImage(with index: Int) -> UIImage {
        
        return UIImage(named: imagesArray[index])!
    }
    
    private func setupButtonsImage() {
        let max = 11
        var indexes = [finalCount]
        for _ in 0..<3 {
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
    
    private func drawImages(image: UIImage) {
        let oneElement = Counting_2.positionForOneElement(view: containerView)
        let twoElement = Counting_2.positionForTwoElement(view: containerView)
        let threeElement = Counting_2.positionForThreeElement(view: containerView)
        let foureElement = Counting_2.positionForFoureElement(view: containerView)
        let fiveElement = Counting_2.positionForFiveElement(view: containerView)
        let sixElement = Counting_2.positionForSixElement(view: containerView)
        let sevenElement = Counting_2.positionForSevenElement(view: containerView)
        let eightElement = Counting_2.positionForEightElement(view: containerView)
        let nineElement = Counting_2.positionForNineElement(view: containerView)
        let tenElement = Counting_2.positionForTenElement(view: containerView)
        let count: Int = Random.getRandomIndex(in: 1..<11)
        if count == 1 {
            containerView.addImageViews(with: image, at: oneElement, count: count, width: 100, height: 100)
        } else if count == 2 {
            containerView.addImageViews(with: image, at: twoElement, count: count, width: 100, height: 100)
        } else if count == 3 {
            containerView.addImageViews(with: image, at: threeElement, count: count, width: 90, height: 90)
        } else if count == 4 {
            containerView.addImageViews(with: image, at: foureElement, count: count, width: 70, height: 70)
        } else if count == 5 {
            containerView.addImageViews(with: image, at: fiveElement, count: count, width: 80, height: 80)
        } else if count == 6 {
            containerView.addImageViews(with: image, at: sixElement, count: count, width: 80, height: 80)
        } else if count == 7 {
            containerView.addImageViews(with: image, at: sevenElement, count: count, width: 60, height: 60)
        } else if count == 8 {
            containerView.addImageViews(with: image, at: eightElement, count: count, width: 60, height: 60)
        } else if count == 9 {
            containerView.addImageViews(with: image, at: nineElement, count: count, width: 50, height: 50)
        } else if count == 10 {
            containerView.addImageViews(with: image, at: tenElement, count: count, width: 50, height: 50)
        }
        
        finalCount = count
    }

    //MARK: - Actions
    
    @IBAction func closeAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
extension Countong_2Controller:handlePanGestureDelegate {
    
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
            self.containerView.subviews.forEach({$0.removeFromSuperview()})
        }
    }
}
