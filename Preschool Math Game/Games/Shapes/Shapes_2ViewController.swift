//
//  Shapes_2ViewController.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 6/9/21.
//

import UIKit

class Shapes_2ViewController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var buttonsContainerView: UIView!
    @IBOutlet var buttonsCollection: [UIButton]!
    @IBOutlet weak var prizContainerView: UIView!
    @IBOutlet weak var prizImageView: UIImageView!
    @IBOutlet weak var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerLeftConstraint: NSLayoutConstraint!
    
    //MARK: - Properties

    var game: Game!

    private var centerImage = UIImage()
    private var finalCount = 0
    private var layoutSubviewsCount = 0
    private var secondsCount = 0
    private var minuteCount = 0
    private var timeCounting = false
    private var touchedButton = false
    
    private var imagesArray = ["star_1", "star_2", "star_3", "star_4", "triangle_1", "round_1", "square_1"]
    
//    private var x: CGFloat!
//    private var y: CGFloat!

    static func initWithStoryboard() -> Shapes_2ViewController? {
        let storyboard = UIStoryboard(name: "ShapesGames", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: Shapes_2ViewController.name) as? Shapes_2ViewController
    }
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        AnalyticService.shared.setupAmplitude(game: "start_shapes_2")
        
        setBorders()
        
//        GamesLimit.shapes_2PrizCount = UserDefaults.standard.value(forKey: UserDefaultsKeys.shapes_2PrizCount) as? Int ?? 0
        
        firstButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        secondButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        thirdButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        firstButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        secondButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        thirdButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: .updateShapes_2, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIScreen.main.bounds.height >= 1000 {
            containerTopConstraint.constant = 200
            containerBottomConstraint.constant = 170
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
        containerView.layer.borderWidth = 5
        containerView.layer.borderColor = #colorLiteral(red: 0.7490196078, green: 0.1882352941, blue: 0.2156862745, alpha: 1)
        buttonsContainerView.layer.borderWidth = 5
        buttonsContainerView.layer.borderColor = #colorLiteral(red: 0.7490196078, green: 0.1882352941, blue: 0.2156862745, alpha: 1)
    }
    
    @objc func update() {
        self.containerView.subviews.forEach({$0.removeFromSuperview()})
        buttonsCollection.forEach({$0.transform = .identity})
        buttonsCollection.forEach({$0.alpha = 1})
        GamesLimit.shapes_2Limit = 0
        self.drawUI()
    }
    
    @objc func gestureButtonAction(gesture: UIPanGestureRecognizer) {
        threeButtonPanGesture(gesture: gesture, gamesLimit: GamesLimit.shapes_2Limit, resultSpace: UIImageView(image: UIImage(named: "")) , finalCount: finalCount, firstView: prizContainerView as! UIImageView, secondView: prizImageView, gamesType: "shapes_2Limit",containerView: containerView)
        delegate = self
    }
    
    private func drawUI() {
        let centerImageNameIndex = Random.getRandomIndex(in: 0..<imagesArray.count) ?? 0
        
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
        guard let image = UIImage(named: imagesArray[index]) else { fatalError() }
        return image
    }
    
    private func setupButtonsImage() {
        let max = 7
        var indexes = [finalCount]
        for _ in 0..<2 {
            let random: Int = Random.getRandomIndex(in: 1..<max+1, ignoredIndexes: indexes)
            indexes.append(random)
        }
        
        indexes = indexes.shuffled()
        
        for i in 0..<indexes.count {
            let number = indexes[i]
            let imageName = "button_\(number)"
            let image = UIImage(named: imageName)!
            let button = buttonsCollection[i]
            button.setImage(image, for: .normal)
            button.tag = number
        }
    }
    
    private func drawImages(image: UIImage) {
        let oneWidth = containerView.frame.width / 1.5
        let oneElement = Shapes_1.positionForOneElement(view: containerView, spacing: oneWidth)
        let count = 1
        containerView.addImageViews(with: image, at: oneElement, count: count, width: oneWidth, height: oneWidth)
        
        if image == UIImage(named: "star_1") {
            finalCount = 7
        } else if image == UIImage(named: "triangle_1") {
            finalCount = 1
        } else if image == UIImage(named: "round_1") {
            finalCount = 5
        } else if image == UIImage(named: "square_1") {
            finalCount = 6
        } else if image == UIImage(named: "star_2") {
            finalCount = 2
        } else if image == UIImage(named: "star_3") {
            finalCount = 3
        } else if image == UIImage(named: "star_4") {
            finalCount = 4
        }
    }
    
    private func setAnimatingViews() {
        buttonsCollection.animateFromBottom(point: CGPoint(x: 0, y: 60))
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension Shapes_2ViewController:handlePanGestureDelegate {
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
