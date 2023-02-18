//
//  CompareController.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 5/5/21.
//

import UIKit

class CompareController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var gameGroundView: UIView!
    @IBOutlet weak var rightView: CustomView!
    @IBOutlet weak var leftView: CustomView!
    @IBOutlet weak var biggerButton: UIButton!
    @IBOutlet weak var equalButton: UIButton!
    @IBOutlet weak var smallerButton: UIButton!
    @IBOutlet weak var leftValueLabel: UILabel!
    @IBOutlet weak var rightValueLabel: UILabel!
    @IBOutlet weak var resultPlace: UIImageView!
    @IBOutlet weak var buttonsContainerView: UIView!
    @IBOutlet var buttonsCollection: [UIButton]!
    @IBOutlet weak var leftBaseContainer: UIView!
    @IBOutlet weak var rightBaseContainer: UIView!
    @IBOutlet weak var prizContainerView: UIView!
    @IBOutlet weak var prizImageView: UIImageView!
    @IBOutlet weak var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerLeftConstraint: NSLayoutConstraint!
    
    //MARK: - Properties
    
    var game: Game!
    
    private var imageArray = ["apple_image", "basketball_image", "cacke_2_image", "cacke_image", "carrot_image", "fish_image", "fox_blue_image", "fox_red_image", "raket_image", "red_fish_image", "blue_bear_img", "green_bear_img", "kub_home_img", "blue_sumka", "purple_sumka", "cow_img", "blue_chuto", "red_chuto", "blue_puchik", "crar_"]
    
    private var leftImage = UIImage()
    private var rightImage = UIImage()
    private var layoutSubviewsCount = 0
    private var touchedButton = false
    
    static func initWithStoryboard() -> CompareController? {
        let storyboard = UIStoryboard(name: "CompareGame", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: CompareController.name) as? CompareController
    }
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        AnalyticService.shared.setupAmplitude(game: "start_compare")
        
        setBorders()
        
        //        GamesLimit.comparePrizCount = UserDefaults.standard.value(forKey: UserDefaultsKeys.comparePrizCount) as? Int ?? 0
        
        biggerButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleBiggerPanGesture)))
        equalButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleEquallyPanGesture)))
        smallerButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleSmallerPanGesture)))
        biggerButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleBiggerPanGesture)))
        equalButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleEquallyPanGesture)))
        smallerButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSmallerPanGesture)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: .updateCompare, object: nil)
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
    
    //MARK: - Function
    private func setFinger() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
            if !self.touchedButton {
                if self.leftView.subviews.count > self.rightView.subviews.count {
                    let pointX = self.biggerButton.globalFrame.origin.x
                    let pointY = self.biggerButton.globalFrame.origin.y + 30
                    self.setFinger(button: self.biggerButton, pointX: pointX, pointY: pointY, btnWidth: 60, btnHeight: 60)
                    self.removeFinger()
                } else if self.leftView.subviews.count == self.rightView.subviews.count {
                    let pointX = self.equalButton.globalFrame.origin.x
                    let pointY = self.equalButton.globalFrame.origin.y + 30
                    self.setFinger(button: self.equalButton, pointX: pointX, pointY: pointY, btnWidth: 60, btnHeight: 60)
                    self.removeFinger()
                } else if self.leftView.subviews.count < self.rightView.subviews.count {
                    let pointX = self.smallerButton.globalFrame.origin.x
                    let pointY = self.smallerButton.globalFrame.origin.y + 30
                    self.setFinger(button: self.smallerButton, pointX: pointX, pointY: pointY, btnWidth: 60, btnHeight: 60)
                    self.removeFinger()
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
        buttonsCollection.forEach({$0.alpha = 1})
        GamesLimit.compareLimit = 0
        self.biggerButton.transform = .identity
        self.resultPlace.isHidden = false
        drawUI()
    }
    
    private func drawUI() {
        let imageNamesRange = 0..<imageArray.count
        let leftImageNameIndex: Int = Random.getRandomIndex(in: imageNamesRange) ?? 0
        let rightImageNameIndex: Int = Random.getRandomIndex(in: imageNamesRange, ignore: leftImageNameIndex)
        
        leftImage = getImage(with: leftImageNameIndex)
        rightImage = getImage(with: rightImageNameIndex)
        
        leftView.drawImages(image: leftImage, view: leftView)
        rightView.drawImages(image: rightImage, view: rightView)
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: false) { timer in
            self.leftValueLabel.text = String(self.leftView.subviews.count)
            self.rightValueLabel.text = String(self.rightView.subviews.count)
        }
        
        setAnimatingViews()
        
        touchedButton = false
        
        if GamesLimit.isShowHunt {
            workItem = DispatchWorkItem { self.setFinger() }
            DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: workItem)
        }
    }
    
    @objc func handleBiggerPanGesture(gesture: UIPanGestureRecognizer) {
        compareButtonType = "biggerButton"
        fourOrMoreButtonPanGesture(gesture: gesture, gamesLimit: GamesLimit.compareLimit , resultSpace: resultPlace, finalCount: 0, firstView: prizContainerView! as! UIImageView, secondView: prizImageView, gamesType: "CompareController",containerView: UIView(), imageView: UIImageView(), imageCollection: [UIImageView](), stackViewCollection: [UIStackView](),gamesTypeForLimit: "compareLimit", viewCollection: [leftView,rightView])
        delegate = self
    }
    
    @objc func handleEquallyPanGesture(gesture: UIPanGestureRecognizer) {
        compareButtonType = "equalButton"
        fourOrMoreButtonPanGesture(gesture: gesture, gamesLimit: GamesLimit.compareLimit , resultSpace: resultPlace, finalCount: 0, firstView: prizContainerView! as! UIImageView, secondView: prizImageView, gamesType: "CompareController",containerView: UIView(), imageView: UIImageView(), imageCollection: [UIImageView](), stackViewCollection: [UIStackView](),gamesTypeForLimit: "compareLimit", viewCollection: [leftView,rightView])
        delegate = self
    }
    
    
    @objc func handleSmallerPanGesture(gesture: UIPanGestureRecognizer) {
        compareButtonType = "smallerButton"
        fourOrMoreButtonPanGesture(gesture: gesture, gamesLimit: GamesLimit.compareLimit , resultSpace: resultPlace, finalCount: 0, firstView: prizContainerView! as! UIImageView, secondView: prizImageView, gamesType: "CompareController",containerView: UIView(), imageView: UIImageView(), imageCollection: [UIImageView](), stackViewCollection: [UIStackView](),gamesTypeForLimit: "compareLimit", viewCollection: [leftView,rightView])
        delegate = self
    }
    
    
    private func setAnimatingViews() {
        buttonsCollection.animateFromBottom(point: CGPoint(x: 0, y: 120))
        [leftBaseContainer, rightBaseContainer].animateFromBottom(point: CGPoint(x: 0, y: 120))
        resultPlace.animateFromBottom(point: CGPoint(x: 0, y: 120))
    }
    
    private func getImage(with index: Int) -> UIImage {
        
        return UIImage(named: imageArray[index])!
    }
    
    //MARK: - Actions
    @IBAction func closeAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension CompareController:handlePanGestureDelegate {
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
            
            if compareButtonType == "smallerButton" {
                self.smallerButton.alpha = 1
                self.smallerButton.transform = .identity
               
            } else if compareButtonType == "equalButton" {
                self.equalButton.alpha = 1
                self.equalButton.transform = .identity
               
            } else if compareButtonType == "biggerButton" {
                self.biggerButton.alpha = 1
                self.biggerButton.transform = .identity
            }
            self.resultPlace.isHidden = false
        }
    }
}
