//
//  EvenAndOddViewController.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 08.07.21.
//

import UIKit

final class EvenAndOddViewController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet var buttonsCollection: [UIButton]!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var leftContainerView: UIView!
    @IBOutlet weak var rightContainerView: UIView!
    @IBOutlet weak var oddFirstNumber: UILabel!
    @IBOutlet weak var oddSecondNumber: UILabel!
    @IBOutlet weak var oddThirdNumber: UILabel!
    @IBOutlet weak var oddFourthNumber: UILabel!
    @IBOutlet weak var oddFivethNumber: UILabel!
    @IBOutlet weak var oddSixthNumber: UILabel!
    @IBOutlet weak var oddSeventhNumber: UILabel!
    @IBOutlet weak var oddEightNumber: UILabel!
    @IBOutlet weak var evenFirstNumber: UILabel!
    @IBOutlet weak var evenSecondNumber: UILabel!
    @IBOutlet weak var evenThirdNumber: UILabel!
    @IBOutlet weak var evenFourthNumber: UILabel!
    @IBOutlet weak var evenFivethNumber: UILabel!
    @IBOutlet weak var evenSixthNumber: UILabel!
    @IBOutlet weak var evenSeventhNumber: UILabel!
    @IBOutlet weak var evenEightNumber: UILabel!
    @IBOutlet weak var prizContainerView: UIView!
    @IBOutlet weak var prizImageView: UIImageView!
    @IBOutlet weak var oddView: CustomView!
    @IBOutlet weak var evenView: CustomView!
    @IBOutlet var numbersCollection: [UILabel]!
    @IBOutlet weak var gameGroundView: UIView!
    @IBOutlet weak var buttonsContainerView: UIView!
    @IBOutlet weak var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerLeftConstraint: NSLayoutConstraint!
    
    //MARK: - Properties
    
    var game: Game!
    
    private var layoutSubviewsCount: Int! = 0
    private var allCount = 0
    private var touchedButton = false
    private var gesture = UIPanGestureRecognizer()
    static func initWithStoryboard() -> EvenAndOddViewController? {
        let storyboard = UIStoryboard(name: "CountingGames", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: EvenAndOddViewController.name) as? EvenAndOddViewController
    }
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.touchedButton = true
        
        if GamesLimit.isShowHunt {
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                self.setFinger()
            }
        }
        
        //        AnalyticService.shared.setupAmplitude(game: "start_odd_even")
        
        setBorders()
        
        //        GamesLimit.odd_EvenPrizCount = UserDefaults.standard.value(forKey: UserDefaultsKeys.odd_EvenPrizCount) as? Int ?? 0
        
        firstButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        secondButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        thirdButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: .updateOdd_Even, object: nil)
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
            for i in self.buttonsCollection {
                if i.tag % 2 == 1 {
                    let pointX = i.globalFrame.origin.x - 5
                    let pointY = i.globalFrame.origin.y + 30
                    self.setFingerWithAnimation(button: i, pointX: pointX, pointY: pointY, btnWidth: 60, btnHeight: 60)
                }
            }
        }
    }
    
    func setFingerWithAnimation(button: UIButton, pointX: CGFloat, pointY: CGFloat, btnWidth: CGFloat, btnHeight: CGFloat) {
        fingerImage.image = UIImage(named: "finger")
        fingerImage.frame = CGRect(x: pointX, y: pointY, width: btnWidth, height: btnHeight)
        view.addSubview(fingerImage)
        view.bringSubviewToFront(fingerImage)
        fingerArray.append(fingerImage)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.2, repeats: true) { timer in
            UIView.animate(withDuration: 1, delay: 0) {
                
                let x = self.oddView.globalFrame.minX + self.oddView.frame.width / 4
                let y = self.oddView.globalFrame.origin.y + self.oddView.frame.height / 4
                
                self.fingerImage.frame.origin.x = x
                self.fingerImage.frame.origin.y = y
            }
            
            let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
                for i in self.buttonsCollection {
                    if i.tag % 2 == 1 {
                        self.fingerImage.frame.origin.x = i.globalFrame.origin.x
                        self.fingerImage.frame.origin.y = i.globalFrame.origin.y + i.frame.height / 2
                    }
                }
            }
        }
    }
    
    private func setBorders() {
        gameGroundView.layer.borderWidth = 5
        gameGroundView.layer.borderColor = #colorLiteral(red: 0.7490196078, green: 0.1882352941, blue: 0.2156862745, alpha: 1)
        buttonsContainerView.layer.borderWidth = 5
        buttonsContainerView.layer.borderColor = #colorLiteral(red: 0.7490196078, green: 0.1882352941, blue: 0.2156862745, alpha: 1)
    }
    
    @objc func update() {
        GamesLimit.odd_EvenLimit = 0
        self.drawUI()
    }
    
    private func configureOddView(button: UIButton) {
        if oddCounts == 1 {
            oddFirstNumber.text = String(button.tag)
            oddFirstNumber.alpha = 1
            button.transform = .identity
            setupButtonsImage()
            buttonsCollection.animateFromBottom(point: CGPoint(x: 0, y: 120))
        } else if oddCounts == 2 {
            oddSecondNumber.text = String(button.tag)
            oddSecondNumber.alpha = 1
            button.transform = .identity
            setupButtonsImage()
            buttonsCollection.animateFromBottom(point: CGPoint(x: 0, y: 120))
        } else if oddCounts == 3 {
            oddThirdNumber.text = String(button.tag)
            oddThirdNumber.alpha = 1
            button.transform = .identity
            setupButtonsImage()
            buttonsCollection.animateFromBottom(point: CGPoint(x: 0, y: 120))
        } else if oddCounts == 4 {
            oddFourthNumber.text = String(button.tag)
            oddFourthNumber.alpha = 1
            button.transform = .identity
            setupButtonsImage()
            buttonsCollection.animateFromBottom(point: CGPoint(x: 0, y: 120))
        } else if oddCounts == 5 {
            oddFivethNumber.text = String(button.tag)
            oddFivethNumber.alpha = 1
            button.transform = .identity
            setupButtonsImage()
            buttonsCollection.animateFromBottom(point: CGPoint(x: 0, y: 120))
        } else if oddCounts == 6 {
            oddSixthNumber.text = String(button.tag)
            oddSixthNumber.alpha = 1
            button.transform = .identity
            setupButtonsImage()
            buttonsCollection.animateFromBottom(point: CGPoint(x: 0, y: 120))
        } else if oddCounts == 7 {
            oddSeventhNumber.text = String(button.tag)
            oddSeventhNumber.alpha = 1
            button.transform = .identity
            setupButtonsImage()
            buttonsCollection.animateFromBottom(point: CGPoint(x: 0, y: 120))
        } else if oddCounts == 8 {
            oddEightNumber.text = String(button.tag)
            oddEightNumber.alpha = 1
            button.transform = .identity
            setupButtonsImage()
            buttonsCollection.animateFromBottom(point: CGPoint(x: 0, y: 120))
        }
    }
    
    private func configureEvenView(button: UIButton) {
        if evenCounts == 1 {
            evenFirstNumber.text = String(button.tag)
            evenFirstNumber.alpha = 1
            button.transform = .identity
            setupButtonsImage()
            buttonsCollection.animateFromBottom(point: CGPoint(x: 0, y: 120))
        } else if evenCounts == 2 {
            evenSecondNumber.text = String(button.tag)
            evenSecondNumber.alpha = 1
            button.transform = .identity
            setupButtonsImage()
            buttonsCollection.animateFromBottom(point: CGPoint(x: 0, y: 120))
        } else if evenCounts == 3 {
            evenThirdNumber.text = String(button.tag)
            evenThirdNumber.alpha = 1
            button.transform = .identity
            setupButtonsImage()
            buttonsCollection.animateFromBottom(point: CGPoint(x: 0, y: 120))
        } else if evenCounts == 4 {
            evenFourthNumber.text = String(button.tag)
            evenFourthNumber.alpha = 1
            button.transform = .identity
            setupButtonsImage()
            buttonsCollection.animateFromBottom(point: CGPoint(x: 0, y: 120))
        } else if evenCounts == 5 {
            evenFivethNumber.text = String(button.tag)
            evenFivethNumber.alpha = 1
            button.transform = .identity
            setupButtonsImage()
            buttonsCollection.animateFromBottom(point: CGPoint(x: 0, y: 120))
        } else if evenCounts == 6 {
            evenSixthNumber.text = String(button.tag)
            evenSixthNumber.alpha = 1
            button.transform = .identity
            setupButtonsImage()
            buttonsCollection.animateFromBottom(point: CGPoint(x: 0, y: 120))
        } else if evenCounts == 7 {
            evenSeventhNumber.text = String(button.tag)
            evenSeventhNumber.alpha = 1
            button.transform = .identity
            setupButtonsImage()
            buttonsCollection.animateFromBottom(point: CGPoint(x: 0, y: 120))
        } else if evenCounts == 8 {
            evenEightNumber.text = String(button.tag)
            evenEightNumber.alpha = 1
            button.transform = .identity
            setupButtonsImage()
            buttonsCollection.animateFromBottom(point: CGPoint(x: 0, y: 120))
        }
    }
    
    @objc func gestureButtonAction(gesture: UIPanGestureRecognizer) {
        self.gesture = gesture
        fourOrMoreButtonPanGesture(gesture: gesture, gamesLimit: GamesLimit.odd_EvenLimit , resultSpace: UIImageView(), finalCount: 0, firstView: prizContainerView! as! UIImageView, secondView: prizImageView, gamesType: "EvenAndOddViewController",containerView: UIView(), imageView: UIImageView(), imageCollection: [UIImageView](), stackViewCollection: [UIStackView](),gamesTypeForLimit: "odd_EvenLimit", viewCollection: [oddView,evenView])
        delegate = self
    }
    
    private func drawUI() {
        setupButtonsImage()
        numbersCollection.forEach({$0.alpha = 0})
        buttonsCollection.animateFromBottom(point: CGPoint(x: 0, y: 120))
        [leftContainerView, rightContainerView].animateFromBottom(point: CGPoint(x: 0, y: 120))
        allCount = 0
    }
    
    private func setupButtonsImage() {
        let max = 9
        let even = [2, 4, 6, 8].shuffled()
        let odd = [1, 3, 5, 7, 9].shuffled()
        
        var indexes = [even[0], odd[0]]
        
        for _ in 0..<1 {
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
    
    //MARK: - Actions
    @IBAction func closeAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension EvenAndOddViewController:handlePanGestureDelegate {
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
            guard let button = gesture.view as? UIButton else { return }
            if button.tag % 2 == 0 {
                if oddCounts + evenCounts == 15 && evenCounts != 8 {
                    evenEightNumber.text = String(button.tag)
                    evenEightNumber.alpha = 1
                }
                if evenCounts < 8 {
                    evenCounts += 1
                    configureEvenView(button: button)
                }
            } else if button.tag % 2 == 1 {
                if oddCounts + evenCounts == 15 && oddCounts != 8 {
                    oddEightNumber.text = String(button.tag)
                    oddEightNumber.alpha = 1
                }
                if oddCounts < 8 {
                    oddCounts += 1
                    configureOddView(button: button)
                }
            }
        }
    }
}
