//
//  AddingFun_2ViewController.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 6/11/21.
//

import UIKit

class AddingFun_2ViewController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var firstNumberLabel: PaddingLabel!
    @IBOutlet weak var secondNumberLabel: PaddingLabel!
    @IBOutlet weak var resultSpace: UIImageView!
    @IBOutlet weak var resultContainerView: UIView!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet var buttonsCollection: [UIButton]!
    @IBOutlet weak var prizContainerView: UIView!
    @IBOutlet weak var prizImageView: UIImageView!
    @IBOutlet weak var gameGroundView: UIView!
    @IBOutlet weak var buttonsContainerView: UIView!
    @IBOutlet weak var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerLeftConstraint: NSLayoutConstraint!
    
    //MARK: - Properties
    
    var game: Game!
    
    private var finalCount: Int = 0
    
    private var layoutSubviewsCount: Int! = 0
    
    private var touchedButton = false
    
    static func initWithStoryboard() -> AddingFun_2ViewController? {
        let storyboard = UIStoryboard(name: "AddingGames", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: AddingFun_2ViewController.name) as? AddingFun_2ViewController
    }
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        AnalyticService.shared.setupAmplitude(game: "start_adding_2")
        
        setBorder()
        
        //        GamesLimit.adding_2PrizCount = UserDefaults.standard.value(forKey: UserDefaultsKeys.adding_2PrizCount) as? Int ?? 0
        
        firstButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        secondButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        thirdButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        firstButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        secondButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        thirdButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: .updateAdding_2, object: nil)
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
    
    private func setBorder() {
        gameGroundView.layer.borderWidth = 5
        gameGroundView.layer.borderColor = #colorLiteral(red: 0.7490196078, green: 0.1882352941, blue: 0.2156862745, alpha: 1)
        buttonsContainerView.layer.borderWidth = 5
        buttonsContainerView.layer.borderColor = #colorLiteral(red: 0.7490196078, green: 0.1882352941, blue: 0.2156862745, alpha: 1)
    }
    
    @objc func update() {
        buttonsCollection.forEach({$0.transform = .identity})
        buttonsCollection.forEach({$0.alpha = 1})
        GamesLimit.adding_2Limit = 0
        self.resultSpace.image = UIImage(named: "questionMark")
        self.drawUI()
    }
    
    private func drawUI() {
        setLabelsCount()
        setupButtonsImage()
        setAnimatingViews()
        
        touchedButton = false
        
        if GamesLimit.isShowHunt {
            workItem = DispatchWorkItem { self.setFinger() }
            DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: workItem)
        }
    }
    
    private func setAnimatingViews() {
        buttonsCollection.animateFromBottom(point: CGPoint(x: 0, y: 120))
        resultContainerView.animateFromBottom(point: CGPoint(x: 0, y: 150))
    }
    
    private func setLabelsCount() {
        let firstRandomNumber = 0..<6
        let firstCount: Int = Random.getRandomIndex(in: firstRandomNumber)
        firstNumberLabel.text = String(firstCount)
        
        let secondRandomNumber = 0..<6
        let secondCount: Int = Random.getRandomIndex(in: secondRandomNumber)
        secondNumberLabel.text = String(secondCount)
        
        finalCount = firstCount + secondCount
    }
    
    private func setupButtonsImage() {
        let max = 10
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
    @objc func gestureButtonAction(gesture: UIPanGestureRecognizer) {
        threeButtonPanGesture(gesture: gesture, gamesLimit: GamesLimit.adding_2Limit, resultSpace: resultSpace, finalCount: finalCount, firstView: prizContainerView as! UIImageView, secondView: prizImageView, gamesType: "adding_2Limit", containerView: UIView())
        delegate = self
    }
    
    //MARK: - Actions
    @IBAction func closeAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension AddingFun_2ViewController:handlePanGestureDelegate {
    
    
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
                
            }
        }
    }

