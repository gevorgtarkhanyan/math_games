//
//  Shapes_4ViewController.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 12.07.21.
//

import UIKit

class Shapes_4ViewController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var thirdImageView: UIImageView!
    @IBOutlet weak var fourthImageView: UIImageView!
    @IBOutlet var buttonCollection: [UIButton]!
    @IBOutlet var figurCollection: [UIImageView]!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    @IBOutlet weak var prizContainerView: UIView!
    @IBOutlet weak var prizImageView: UIImageView!
    @IBOutlet weak var gameGroundView: UIView!
    @IBOutlet weak var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerLeftConstraint: NSLayoutConstraint!
    
    //MARK: - Properties
    
    var game: Game!
    
    private var firstCount = 0
    private var secondCount = 0
    private var thirdCount = 0
    private var fourthCount = 0
    
    private var layoutSubviewsCount: Int! = 0
    
    private var touchedButton = false
    
    private let imageArray = ["Asset_1", "Asset_2", "Asset_3", "Asset_4", "Asset_5", "Asset_6", "Asset_7", "home_1", "home_2"]
    
    static func initWithStoryboard() -> Shapes_4ViewController? {
        let storyboard = UIStoryboard(name: "ShapesGames", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: Shapes_4ViewController.name) as? Shapes_4ViewController
    }
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        AnalyticService.shared.setupAmplitude(game: "start_shapes_4")
        
        gameGroundView.layer.borderWidth = 5
        gameGroundView.layer.borderColor = #colorLiteral(red: 0.7490196078, green: 0.1882352941, blue: 0.2156862745, alpha: 1)
        
        //        GamesLimit.shapes_4PrizCount = UserDefaults.standard.value(forKey: UserDefaultsKeys.shapes_4PrizCount) as? Int ?? 0
        
        firstButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        secondButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        thirdButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        fourthButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: .updateShapes_4, object: nil)
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
                for i in self.buttonCollection {
                    if i.tag == self.firstCount {
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
        buttonCollection.forEach({$0.transform = .identity})
        buttonCollection.forEach({$0.alpha = 1})
        figurCollection.forEach({$0.alpha = 1})
        GamesLimit.shapes_4Limit = 0
        baseCount = 0
        drawUI()
    }
    
    private func drawUI() {
        configureImageView()
        setupButtonsImage()
        setAnimatingViews()
        baseCount = 0
        
        touchedButton = false
        
        if GamesLimit.isShowHunt {
            workItem = DispatchWorkItem { self.setFinger() }
            DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: workItem)
        }
    }
    
    private func setAnimatingViews() {
        figurCollection.forEach({$0.changeSizeImageWithAnimate()})
        buttonCollection.animateFromBottom(point: CGPoint(x: 0, y: 120))
    }
    
    private func configureImageView() {
        let shuffle_1 = imageArray.shuffled()
        firstImageView.image = UIImage(named: shuffle_1[0])
        secondImageView.image = UIImage(named: shuffle_1[1])
        thirdImageView.image = UIImage(named: shuffle_1[2])
        fourthImageView.image = UIImage(named: shuffle_1[3])
        
        figurCollection.forEach { image in
            if image.image == UIImage(named: "Asset_1") || image.image == UIImage(named: "Asset_2") {
                image.tag = 0
            } else if image.image == UIImage(named: "Asset_3") || image.image == UIImage(named: "Asset_4") || image.image == UIImage(named: "Asset_7") {
                image.tag = 4
            } else if image.image == UIImage(named: "Asset_5") || image.image == UIImage(named: "Asset_6") {
                image.tag = 3
            } else if image.image == UIImage(named: "home_1") || image.image == UIImage(named: "home_2") {
                image.tag = 5
            }
        }
        
        firstCount = firstImageView.tag
        secondCount = secondImageView.tag
        thirdCount = thirdImageView.tag
        fourthCount = fourthImageView.tag
    }
    
    private func setupButtonsImage() {
        var indexes = [firstCount, secondCount, thirdCount, fourthCount]
        
        indexes = indexes.shuffled()
        
        for i in 0..<indexes.count {
            let number: Int = indexes[i]
            let imageName: String = "img_\(number)"
            let image: UIImage = UIImage(named: imageName)!
            let button = buttonCollection[i]
            button.setImage(image, for: .normal)
            button.tag = number
        }
    }
    
    @objc func gestureButtonAction(gesture: UIPanGestureRecognizer) {
        fourOrMoreButtonPanGesture(gesture: gesture, gamesLimit: GamesLimit.shapes_4Limit , resultSpace: UIImageView(), finalCount: 0, firstView: prizContainerView! as! UIImageView, secondView: prizImageView, gamesType: "Shapes_4ViewController",containerView: UIView(), imageView: UIImageView(), imageCollection: figurCollection, stackViewCollection: [UIStackView](),gamesTypeForLimit: "shapes_4Limit", viewCollection: [UIView]())
        delegate = self
    }
    //MARK: - Actions
    @IBAction func closeAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
extension Shapes_4ViewController:handlePanGestureDelegate {
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
            self.buttonCollection.forEach({$0.transform = .identity})
            self.buttonCollection.forEach({$0.alpha = 1})
            self.figurCollection.forEach({$0.alpha = 1})
            self.baseCount = 0
        }
    }
}
