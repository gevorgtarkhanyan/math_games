//
//  Shapes_3ViewController.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 09.07.21.
//

import UIKit

class Shapes_3ViewController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet var figurCollection: [UIImageView]!
    @IBOutlet weak var firstFigurImage: UIImageView!
    @IBOutlet weak var secondFigurImage: UIImageView!
    @IBOutlet weak var thirdFigurImage: UIImageView!
    @IBOutlet weak var fourthFigurImage: UIImageView!
    @IBOutlet weak var fivethFigurImage: UIImageView!
    @IBOutlet weak var sixthFigurImage: UIImageView!
    @IBOutlet weak var seventhFigurImage: UIImageView!
    @IBOutlet weak var eightFigurImage: UIImageView!
    @IBOutlet weak var ninthFigurImage: UIImageView!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var prizContainerView: UIView!
    @IBOutlet weak var prizImageView: UIImageView!
    @IBOutlet var buttonsCollection: [UIButton]!
    @IBOutlet weak var gameGroundView: UIView!
    @IBOutlet weak var buttonsContainerView: UIView!
    @IBOutlet weak var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerLeftConstraint: NSLayoutConstraint!
    
    //MARK: - Properties

    var game: Game!

    private var layoutSubviewsCount: Int! = 0

    private var resultTag: Int!
    private var resultCGPoint: CGPoint!
    
    let imageArray = ["img_3", "image_0", "image_4"]
    
    private var touchedButton = false
    private var image: UIImageView = UIImageView()
    static func initWithStoryboard() -> Shapes_3ViewController? {
        let storyboard = UIStoryboard(name: "ShapesGames", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: Shapes_3ViewController.name) as? Shapes_3ViewController
    }

    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        AnalyticService.shared.setupAmplitude(game: "start_shapes_3")

        setBorder()
        
//        GamesLimit.shapes_3PrizCount = UserDefaults.standard.value(forKey: UserDefaultsKeys.shapes_3PrizCount) as? Int ?? 0
        
        firstButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        secondButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        thirdButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        firstButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        secondButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        thirdButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: .updateShapes_3, object: nil)
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
    
    //MARK: - Fubctions
    private func setFinger() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
            if !self.touchedButton {
                for i in self.buttonsCollection {
                    if i.tag == self.resultTag {
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
        figurCollection.forEach({$0.alpha = 1})
        GamesLimit.shapes_3Limit = 0
        self.drawUI()
    }
    
    private func drawUI() {
        configureImageView()
        self.figurCollection.forEach({$0.alpha = 1})
        
        let shuffle = figurCollection.shuffled()
        image = shuffle[0]
        image.alpha = 0
        resultTag = image.tag
        resultCGPoint = image.globalFrame.origin
        
        setAnimatingViews()
        
        touchedButton = false
        
        if GamesLimit.isShowHunt {
            workItem = DispatchWorkItem { self.setFinger() }
            DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: workItem)
        }
    }
    
    private func setAnimatingViews() {
        buttonsCollection.animateFromBottom(point: CGPoint(x: 0, y: 120))
        figurCollection.forEach({$0.changeSizeImageWithAnimate()})
    }
    
    private func configureImageView() {
        let shuffle_1 = imageArray.shuffled()
        firstFigurImage.image = UIImage(named: shuffle_1[0])
        secondFigurImage.image = UIImage(named: shuffle_1[1])
        thirdFigurImage.image = UIImage(named: shuffle_1[2])
        let shuffle_2 = imageArray.shuffled()
        fourthFigurImage.image = UIImage(named: shuffle_2[0])
        fivethFigurImage.image = UIImage(named: shuffle_2[1])
        sixthFigurImage.image = UIImage(named: shuffle_2[2])
        let shuffle_3 = imageArray.shuffled()
        seventhFigurImage.image = UIImage(named: shuffle_3[0])
        eightFigurImage.image = UIImage(named: shuffle_3[1])
        ninthFigurImage.image = UIImage(named: shuffle_3[2])
        
        figurCollection.forEach { image in
            if image.image == UIImage(named: "img_3") {
                image.tag = 3
            } else if image.image == UIImage(named: "image_4") {
                image.tag = 4
            } else if image.image == UIImage(named: "image_0") {
                image.tag = 0
            }
        }
    }
    @objc func gestureButtonAction(gesture: UIPanGestureRecognizer) {
        threeButtonPanGesture(gesture: gesture, gamesLimit: GamesLimit.shapes_3Limit, resultSpace: image , finalCount: resultTag, firstView: prizContainerView as! UIImageView, secondView: prizImageView, gamesType: "shapes_3Limit",containerView: UIView())
        delegate = self
    }
    
  
    @IBAction func closeAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension Shapes_3ViewController:handlePanGestureDelegate {
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
