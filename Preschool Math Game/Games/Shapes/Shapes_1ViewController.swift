//
//  Shapes_1ViewController.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 6/9/21.
//

import UIKit

class Shapes_1ViewController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var gameGroundView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var resultImageView: UIView!
    @IBOutlet var buttonsCollection: [UIButton]!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fouthButton: UIButton!
    @IBOutlet weak var prizContainerView: UIView!
    @IBOutlet weak var prizImageView: UIImageView!
    @IBOutlet weak var equallyIcon: UILabel!
    @IBOutlet weak var resultTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    
    //MARK: - Properties

    var game: Game!

    private var centerImage = UIImage()
    private let touchedView = UIView()
    private var finalCount = 0
    private var layoutSubviewsCount = 0
    private var secondsCount = 0
    private var minuteCount = 0
    private var timeCounting = false
    private var touchedCount = 0
    
    private var imagesArray = ["img_0", "img_3", "img_4", "img_5", "img_6", "img_8", "img_9"]
    
    private var touchedButton = false

    static func initWithStoryboard() -> Shapes_1ViewController? {
        let storyboard = UIStoryboard(name: "ShapesGames", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: Shapes_1ViewController.name) as? Shapes_1ViewController
    }

        
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        AnalyticService.shared.setupAmplitude(game: "start_shapes_1")
        
//        GamesLimit.shapes_1PrizCount = UserDefaults.standard.value(forKey: UserDefaultsKeys.shapes_1PrizCount) as? Int ?? 0
        
        gameGroundView.layer.borderWidth = 5
        gameGroundView.layer.borderColor = #colorLiteral(red: 0.7490196078, green: 0.1882352941, blue: 0.2156862745, alpha: 1)
        
        firstButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        secondButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        thirdButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        fouthButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        firstButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        secondButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        thirdButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        fouthButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gestureButtonAction)))

        NotificationCenter.default.addObserver(self, selector: #selector(update), name: .updateShapes_1, object: nil)
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
    
    @objc func update() {
        self.containerView.subviews.forEach({$0.removeFromSuperview()})
        buttonsCollection.forEach({$0.transform = .identity})
        buttonsCollection.forEach({$0.alpha = 1})
        GamesLimit.shapes_1Limit = 0
        self.resultImageView.isHidden = false
        self.drawUI()
    }
    
    @objc func handleFirstPanGesture(gesture: UIPanGestureRecognizer) {
        guard let button = gesture.view as? UIButton else {
            return
        }
        
        if gesture.state == .began {
            self.touchedButton = true
            self.fingerArray.forEach({$0.removeFromSuperview()})
            self.fingerArray.removeAll()
            
        } else if gesture.state == .changed {
            let translation = gesture.translation(in: self.view)
            button.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
        } else if gesture.state == .ended {
            
            if button.tag != finalCount {
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseIn) {
                    self.audio.playLoseSound()
                    button.transform = .identity
                } completion: { (bool) in
                    print("FALSE!!!")
                }
            } else {
                if let item = workItem {
                    item.cancel()
                }
                let buttonOrigin = button.globalFrame.origin
                
                setCloneButton(button: button, point: buttonOrigin, btnWidth: button.frame.width, btnHeight: button.frame.height)
                
                UIView.animate(withDuration: 0.3) {
                    self.copyButton.frame.origin = CGPoint(x: self.resultImageView.globalFrame.minX - 5, y: self.resultImageView.globalFrame.minY)
                    button.transform = .identity
                }
                
                timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { (timer) in
                    self.resultImageView.isHidden = true
                }

                if !UserDefaults.standard.bool(forKey: UserDefaultsKeys.paymentKey) {
                    if GamesLimit.shapes_1Limit < 4 {
                        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
                            self.containerView.subviews.forEach({$0.removeFromSuperview()})
                            self.finalButtons.forEach({$0.removeFromSuperview()})
                            self.finalButtons = []
                            button.alpha = 1
                            button.transform = .identity
                            self.audio.playWinSound()
                            self.resultImageView.isHidden = false
                            GamesLimit.shapes_1Limit += 1
                            UserDefaults.standard.setValue(GamesLimit.shapes_1Limit, forKey: UserDefaultsKeys.shapes_1Limit)
                            self.drawUI()
                        }
                        
                    } else {
//                        GamesLimit.shapes_1PrizCount += 1
//                        UserDefaults.standard.setValue(GamesLimit.shapes_1PrizCount, forKey: UserDefaultsKeys.shapes_1PrizCount)
                        game.isLocked = true
                        view.bringSubviewToFront(self.prizContainerView)
                        view.bringSubviewToFront(self.prizImageView)
                        self.prizContainerView.isHidden = false
                        self.prizImageView.isHidden = false
                        self.prizImageView.changeSizeImageWithAnimate()
                        
                        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
                            self.prizContainerView.isHidden = true
                            self.prizImageView.isHidden = true
                        }
                        
                        timer = Timer.scheduledTimer(withTimeInterval: 3.1, repeats: false) { (timer) in
                            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ParentalControllController") as! ParentalControllController
                            
                            vc.fromGame = true
                            self.addChild(vc)
                            self.view.addSubview(vc.view)
                            vc.didMove(toParent: self)
                        }
                    }
                } else {
                    if GamesLimit.shapes_1Limit == 4 {
                        GamesLimit.shapes_1Limit = 0
                        UserDefaults.standard.setValue(GamesLimit.shapes_1Limit, forKey: UserDefaultsKeys.shapes_1Limit)
//                        GamesLimit.shapes_1PrizCount += 1
//                        UserDefaults.standard.setValue(GamesLimit.shapes_1PrizCount, forKey: UserDefaultsKeys.shapes_1PrizCount)
                        view.bringSubviewToFront(self.prizContainerView)
                        view.bringSubviewToFront(self.prizImageView)
                        self.prizContainerView.isHidden = false
                        self.prizImageView.isHidden = false
                        self.prizImageView.changeSizeImageWithAnimate()
                        
                        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
                            self.prizContainerView.isHidden = true
                            self.prizImageView.isHidden = true
                        }
                        
                        timer = Timer.scheduledTimer(withTimeInterval: 3.1, repeats: false) { (timer) in
                            self.containerView.subviews.forEach({$0.removeFromSuperview()})
                            self.finalButtons.forEach({$0.removeFromSuperview()})
                            self.finalButtons = []
                            button.alpha = 1
                            button.transform = .identity
                            self.audio.playWinSound()
                            self.resultImageView.isHidden = false
                            self.drawUI()
                        }
                    } else {
                        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
                            self.containerView.subviews.forEach({$0.removeFromSuperview()})
                            self.finalButtons.forEach({$0.removeFromSuperview()})
                            GamesLimit.shapes_1Limit += 1
                            UserDefaults.standard.setValue(GamesLimit.shapes_1Limit, forKey: UserDefaultsKeys.shapes_1Limit)
                            self.finalButtons = []
                            button.alpha = 1
                            button.transform = .identity
                            self.audio.playWinSound()
                            self.resultImageView.isHidden = false
                            self.drawUI()
                        }
                    }
                }
            }
        }
    }
    
    @objc func gestureButtonAction(gesture: UIPanGestureRecognizer) {
        threeButtonPanGesture(gesture: gesture, gamesLimit: GamesLimit.shapes_1Limit, resultSpace: UIImageView() , finalCount: finalCount, firstView: prizContainerView as! UIImageView, secondView: prizImageView, gamesType: "shapes_1Limit",containerView: resultImageView)
        delegate = self
    }
    
    private func drawUI() {
        let imageNamesRange = 0..<imagesArray.count
        let centerImageNameIndex = Random.getRandomIndex(in: imageNamesRange) ?? 0
        
        centerImage = getImage(with: centerImageNameIndex)
        
        drawImages(image: centerImage)
        
        setupButtonsImage()
        
        setAnimatingViews()
        
        touchedButton = false
        
        if GamesLimit.isShowHunt {
            workItem = DispatchWorkItem { self.setFinger() }
            DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: workItem)
        }
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
        let oneWidth = containerView.frame.width / 2
        let oneElement = Shapes_1.positionForOneElement(view: containerView, spacing: oneWidth)
        let count = 1
        containerView.addImageViews(with: image, at: oneElement, count: count, width: oneWidth, height: oneWidth)
        
        if image == UIImage(named: "img_0") {
            finalCount = 0
        } else if image == UIImage(named: "img_3") {
            finalCount = 3
        } else if image == UIImage(named: "img_4") {
            finalCount = 4
        } else if image == UIImage(named: "img_5") {
            finalCount = 5
        } else if image == UIImage(named: "img_6") {
            finalCount = 6
        } else if image == UIImage(named: "img_8") {
            finalCount = 8
        } else if image == UIImage(named: "img_9") {
            finalCount = 9
        }

        addTouchedView(with: touchedView, at: oneElement.first!, width: oneWidth, height: oneWidth)
    }
    
    private func addTouchedView(with view: UIView, at positions: CGPoint, width: CGFloat, height: CGFloat) {
        let view = UIView(frame: CGRect(x: positions.x, y: positions.y, width: width, height: height))
        view.backgroundColor = .clear
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(touched))
        view.addGestureRecognizer(tapGestureRecognizer)
        containerView.addSubview(view)
    }
    
    @objc func touched(recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: view)
        touchedCount += 1
        var fontSize: CGFloat = 50
        let label = UILabel(frame: CGRect(x: location.x, y: location.y - 40, width: 100, height: 100))
        if UIDevice.current.userInterfaceIdiom == .pad {
            fontSize = 80
        }
        label.font = UIFont(name: "Bigfat-Script", size: fontSize)
        label.textColor = #colorLiteral(red: 0.7490196078, green: 0.1882352941, blue: 0.2156862745, alpha: 1)
    
        if finalCount == 0 {
            return
        } else if finalCount == 3 {
            if touchedCount > 3 {
                touchedCount = 1
            }
            label.text = String(touchedCount)
        } else if finalCount == 4 {
            if touchedCount > 4 {
                touchedCount = 1
            }
            label.text = String(touchedCount)
        } else if finalCount == 5 {
            if touchedCount > 5 {
                touchedCount = 1
            }
            label.text = String(touchedCount)
        } else if finalCount == 6 {
            if touchedCount > 6 {
                touchedCount = 1
            }
            label.text = String(touchedCount)
        } else if finalCount == 8 {
            if touchedCount > 8 {
                touchedCount = 1
            }
            label.text = String(touchedCount)
        } else if finalCount == 9 {
            if touchedCount > 9 {
                touchedCount = 1
            }
            label.text = String(touchedCount)
        }
        view.addSubview(label)
        
        label.animateText()
    }
    
    private func setAnimatingViews() {
        buttonsCollection.animateFromBottom(point: CGPoint(x: 0, y: 120))
        equallyIcon.animateFromBottom(point: CGPoint(x: 0, y: 120))
        resultImageView.animateFromBottom(duration: 0.7, point: CGPoint(x: 0, y: 120))
    }
    
    //MARK: - Actions
    @IBAction func closeAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
extension Shapes_1ViewController:handlePanGestureDelegate {
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
