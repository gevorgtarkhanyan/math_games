//
//  ScaleGameViewController.swift
//  Preschool Math Game
//
//  Created by Taron Saribekyan on 26.10.22.
//

import UIKit

class ScaleGameViewController: BaseViewController {

    //MARK: - Outlets
    
    @IBOutlet private var backButton: BackButton!
    @IBOutlet private var gameGroundView: UIView!

    @IBOutlet private var scaleImageView: UIImageView!
    @IBOutlet private var scaleRightUpImageView: UIImageView!
    @IBOutlet private var scaleLeftUpImageView: UIImageView!
    @IBOutlet private var signImageView: UIImageView!

    @IBOutlet private var leftBallImageView: UIImageView!
    @IBOutlet private var leftBallToScaleConstraint: NSLayoutConstraint!
    @IBOutlet private var leftBallToScaleLeftUpConstraint: NSLayoutConstraint!
    @IBOutlet private var leftBallToScaleRightUpConstraint: NSLayoutConstraint!

    @IBOutlet private var rightBallImageView: UIImageView!
    @IBOutlet private var rightBallToScaleConstraint: NSLayoutConstraint!
    @IBOutlet private var rightBallToScaleLeftUpConstraint: NSLayoutConstraint!
    @IBOutlet private var rightBallToScaleRightUpConstraint: NSLayoutConstraint!

    @IBOutlet private var buttonsCollection: [UIButton]!
    @IBOutlet private var firstButton: UIButton!
    @IBOutlet private var secondButton: UIButton!
    @IBOutlet private var thirdButton: UIButton!
    @IBOutlet private var fourthButton: UIButton!
    @IBOutlet private var fifthButton: UIButton!

    //MARK: - Properties

    var game: Game!
    private var buttonNumbers = [Int]()
    private var leftHasBall = false
    private var rightHasBall = false
    private var smallestNumber = 0
    private var biggestNumber = 0

    static func initWithStoryboard() -> ScaleGameViewController? {
        let storyboard = UIStoryboard(name: "ScaleGame", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: ScaleGameViewController.name) as? ScaleGameViewController
    }

    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()

        DispatchQueue.main.async {
            self.setBallLeadingTrailingConstraints(scaleImageView: self.scaleImageView, leftBallView: self.leftBallImageView, rightBallView: self.rightBallImageView)
        }
    }

    deinit {
        print("Deinit")
    }

    //MARK: - Setup Views

    private func setup() {
        buttonsCollection.forEach { $0.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))) }

        backButton.setNavigation(navigationController)
        gameGroundView.setBorder()
        gameGroundView.setCorner()
        setupViews()
        showGameStartVC(self)
    }

    private func setupViews() {
        setupImages()
        setupScaleView()
        setAnimatingViews()
    }

    private func setAnimatingViews() {
        buttonsCollection.animateFromBottom(point: CGPoint(x: 0, y: 120))
        signImageView.animateFromBottom(point: CGPoint(x: 0, y: 120))
    }

    private func setupImages() {
        // number buttons
        var numbers = (0...10).shuffled()
        for i in 0...4 {
            guard let number = numbers.first else { return }
            guard let image = UIImage(named: "btn_\(number)") else { return }
            let button = buttonsCollection[i]
            button.setImage(image, for: .normal)
            button.tag = number
            buttonNumbers.append(number)
            numbers.removeFirst()
            biggestNumber = buttonNumbers.max() ?? 0
            smallestNumber = buttonNumbers.min()  ?? 0
        }

        //sign image

        signImageView.image = UIImage(named: ["bigger", "smaller"].randomElement()!)

        //balls images

        leftBallImageView.image = UIImage(named: "oneBall")
        leftBallImageView.tag = 0
        rightBallImageView.image = UIImage(named: "oneBall")
        rightBallImageView.tag = 0
    }

    private func setupScaleView() {
        scaleLeftUpImageView.isHidden = true
        scaleRightUpImageView.isHidden = true
        scaleImageView.isHidden = false
        leftBallToScaleRightUpConstraint.isActive = false
        leftBallToScaleLeftUpConstraint.isActive = false
        rightBallToScaleLeftUpConstraint.isActive = false
        rightBallToScaleRightUpConstraint.isActive = false
        leftBallToScaleConstraint.isActive = true
        rightBallToScaleConstraint.isActive = true
    }


    //MARK: - Game Logic

    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        guard let button = gesture.view as? UIButton else { return }

        if gesture.state == .began {
            self.fingerArray.forEach({$0.removeFromSuperview()})
            self.fingerArray.removeAll()
        } else if gesture.state == .changed {
            let translation = gesture.translation(in: self.view)
            button.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
        } else if gesture.state == .cancelled {
            lose(button: button)
        }  else if gesture.state == .ended {
            let buttonOrigin = button.globalFrame.origin
            let buttonMaxX = button.globalFrame.maxX
            let buttonX = button.globalFrame.origin.x

            if buttonMaxX >= leftBallImageView.globalFrame.origin.x && buttonX < leftBallImageView.globalFrame.maxX {

                if (signImageView.image == UIImage(named: "smaller") && button.tag != biggestNumber && leftHasBall == false) || (signImageView.image == UIImage(named: "bigger") && button.tag != smallestNumber && leftHasBall == false) {

                    if rightHasBall == false {
                        setCloneButton(button: button, point: buttonOrigin, btnWidth: button.frame.width, btnHeight: button.frame.height, imageView: leftBallImageView)
                        leftHasBall = true

                        if button.tag != 0 {
                            let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [self] _ in
                                UIView.transition(with: scaleRightUpImageView, duration: 0.1, options: .transitionCrossDissolve) {
                                    self.scaleRightUpImageView.isHidden = false
                                }
                                let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                                    self.scaleImageView.isHidden = true
                                }
                                leftBallToScaleConstraint.isActive = false
                                rightBallToScaleConstraint.isActive = false
                                leftBallToScaleRightUpConstraint.isActive = true
                                rightBallToScaleRightUpConstraint.isActive = true
                            }
                        }
                    } else {

                        if signImageView.image == UIImage(named: "smaller") {

                            if button.tag <= rightBallImageView.tag {
                                setCloneButton(button: button, point: buttonOrigin, btnWidth: button.frame.width, btnHeight: button.frame.height, imageView: leftBallImageView)
                                roundEnded()
                                newRound()
                            } else {
                                lose(button: button)
                            }
                        } else {

                            if button.tag >= rightBallImageView.tag {
                                setCloneButton(button: button, point: buttonOrigin, btnWidth: button.frame.width, btnHeight: button.frame.height, imageView: leftBallImageView)

                                if rightBallImageView.tag != 0 {
                                    let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [self] _ in
                                        UIView.transition(with: scaleRightUpImageView, duration: 0.1, options: .transitionCrossDissolve) {
                                            self.scaleRightUpImageView.isHidden = false
                                            self.scaleImageView.isHidden = false
                                        }
                                        let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                                            self.scaleImageView.isHidden = true
                                            self.scaleLeftUpImageView.isHidden = true
                                        }
                                        leftBallToScaleLeftUpConstraint.isActive = false
                                        rightBallToScaleLeftUpConstraint.isActive = false
                                        leftBallToScaleRightUpConstraint.isActive = true
                                        rightBallToScaleRightUpConstraint.isActive = true
                                    }
                                } else {
                                    let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [self] _ in
                                        UIView.transition(with: scaleRightUpImageView, duration: 0.1, options: .transitionCrossDissolve) {
                                            self.scaleRightUpImageView.isHidden = false
                                        }
                                        let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                                            self.scaleImageView.isHidden = true
                                        }
                                        leftBallToScaleConstraint.isActive = false
                                        rightBallToScaleConstraint.isActive = false
                                        leftBallToScaleRightUpConstraint.isActive = true
                                        rightBallToScaleRightUpConstraint.isActive = true
                                    }
                                }
                                let _ = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { _ in
                                    self.roundEnded()
                                    self.newRound()
                                }
                            } else {
                                lose(button: button)
                            }
                        }
                    }
                } else {
                    lose(button: button)
                }
            } else if buttonMaxX >= rightBallImageView.globalFrame.origin.x && buttonX < rightBallImageView.globalFrame.maxX {
                
                if (signImageView.image == UIImage(named: "bigger") && button.tag != biggestNumber && rightHasBall == false) || (signImageView.image == UIImage(named: "smaller") && button.tag != smallestNumber && rightHasBall == false) {

                    if leftHasBall == false {
                        setCloneButton(button: button, point: buttonOrigin, btnWidth: button.frame.width, btnHeight: button.frame.height, imageView: rightBallImageView)
                        rightHasBall = true

                        if button.tag != 0 {
                            let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [self] _ in
                                UIView.transition(with: scaleLeftUpImageView, duration: 0.1, options: .transitionCrossDissolve) {
                                    self.scaleLeftUpImageView.isHidden = false
                                }
                                let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                                    self.scaleImageView.isHidden = true
                                }
                                leftBallToScaleConstraint.isActive = false
                                rightBallToScaleConstraint.isActive = false
                                leftBallToScaleLeftUpConstraint.isActive = true
                                rightBallToScaleLeftUpConstraint.isActive = true
                            }
                        }
                    } else {

                        if signImageView.image == UIImage(named: "smaller") {

                            if button.tag >= leftBallImageView.tag {
                                setCloneButton(button: button, point: buttonOrigin, btnWidth: button.frame.width, btnHeight: button.frame.height, imageView: rightBallImageView)

                                if leftBallImageView.tag != 0 {
                                    let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [self] _ in
                                        UIView.transition(with: scaleLeftUpImageView, duration: 0.1, options: .transitionCrossDissolve) {
                                            self.scaleLeftUpImageView.isHidden = false
                                            self.scaleImageView.isHidden = false
                                        }
                                        let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                                            self.scaleImageView.isHidden = true
                                            self.scaleRightUpImageView.isHidden = true
                                        }
                                        leftBallToScaleRightUpConstraint.isActive = false
                                        rightBallToScaleRightUpConstraint.isActive = false
                                        leftBallToScaleLeftUpConstraint.isActive = true
                                        rightBallToScaleLeftUpConstraint.isActive = true
                                    }
                                } else {
                                    let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [self] _ in
                                        UIView.transition(with: scaleLeftUpImageView, duration: 0.1, options: .transitionCrossDissolve) {
                                            self.scaleLeftUpImageView.isHidden = false
                                        }
                                        let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                                            self.scaleImageView.isHidden = true
                                        }
                                        leftBallToScaleConstraint.isActive = false
                                        rightBallToScaleConstraint.isActive = false
                                        leftBallToScaleLeftUpConstraint.isActive = true
                                        rightBallToScaleLeftUpConstraint.isActive = true
                                    }
                                }
                                let _ = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { _ in
                                    self.roundEnded()
                                    self.newRound()
                                }
                            } else {
                                lose(button: button)
                            }
                        } else {
                            if button.tag <= leftBallImageView.tag {
                                setCloneButton(button: button, point: buttonOrigin, btnWidth: button.frame.width, btnHeight: button.frame.height, imageView: rightBallImageView)
                                roundEnded()
                                newRound()
                            } else {
                                lose(button: button)
                            }
                        }
                    }
                } else {
                    lose(button: button)
                }
            } else {
                lose(button: button)
            }
        }
    }

    private func roundEnded() {
        GamesLimit.scaleLimit += 1
        UserDefaults.standard.setValue(GamesLimit.scaleLimit, forKey: UserDefaultsKeys.scaleLimit)
        audio.playWinSound()
    }

    private func newRound() {
        if GamesLimit.scaleLimit < 5 {
            let _ = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false) { [self] _ in
                buttonsCollection.forEach { button in
                    button.alpha = 1
                    button.isEnabled = true
                }
                buttonNumbers = []
                leftBallImageView.tag = 0
                rightBallImageView.tag = 0
                leftHasBall = false
                rightHasBall = false
                setupViews()
            }
        } else {
            if !subscribed {
                game.isLocked = true
            }
            GamesLimit.scaleLimit = 0
            UserDefaults.standard.setValue(GamesLimit.scaleLimit, forKey: UserDefaultsKeys.scaleLimit)

            let _ = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false) { _ in
                self.presentEndPopUpVC(delegate: self, icon: "crar", refresh: true)
                self.view.bringSubviewToFront(self.backButton)
            }
        }
    }
}

//MARK: - Extensions

extension ScaleGameViewController: GameStartDelegate {
    func start() { print("Game Started") }
    func setNavigationIndexes(_ indexes: [Int]) { }
}

extension ScaleGameViewController: EndPopUpViewControllerDelegate {
    func backTapped() { backButton.tapped() }

    func refreshTapped() {
        if subscribed {
            newRound()
        } else { showParentalController() }
    }
}
