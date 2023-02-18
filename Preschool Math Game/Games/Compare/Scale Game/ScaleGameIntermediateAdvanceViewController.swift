//
//  ScaleGameIntermediateAdvanceViewController.swift
//  Preschool Math Game
//
//  Created by Taron Saribekyan on 11.11.22.
//

import UIKit

class ScaleGameIntermediateAdvanceViewController: BaseViewController {

    //MARK: - Subviews and Constraints
    
    @IBOutlet private var backButton: BackButton!
    @IBOutlet private var gameGroundView: UIView!
    @IBOutlet weak var numberButtonsStackView: UIStackView!
    @IBOutlet private var scaleImageView: UIImageView!
    @IBOutlet private var scaleRightUpImageView: UIImageView!
    @IBOutlet private var scaleLeftUpImageView: UIImageView!
    @IBOutlet private var signImageView: UIImageView!
    
    @IBOutlet private var firstButton: UIButton!
    @IBOutlet private var secondButton: UIButton!
    @IBOutlet private var thirdButton: UIButton!
    @IBOutlet private var fourthButton: UIButton!
    @IBOutlet private var fifthButton: UIButton!
    @IBOutlet private var sixthButton: UIButton!
    @IBOutlet private var seventhButton: UIButton!
    @IBOutlet private var buttonsCollection: [UIButton]!
    
    @IBOutlet private var resultsView: UIView!
    @IBOutlet private var rightAnswersLabel: UILabel!
    @IBOutlet private var wrongAnswersLabel: UILabel!
    @IBOutlet private var timerView: UIView!
    @IBOutlet private var timerLabel: UILabel!

    private let leftBallsView = UIView()
    private let rightBallsView = UIView()

    private let leftFirstBallView = UIImageView()
    private let leftSecondBallView = UIImageView()
    private let leftThirdBallView = UIImageView()
    private let rightFirstBallView = UIImageView()
    private let rightSecondBallView = UIImageView()
    private let rightThirdBallView = UIImageView()
    
    private let leftFirstBall = UIButton()
    private let leftSecondBall = UIButton()
    private let leftThirdBall = UIButton()
    private let rightFirstBall = UIButton()
    private let rightSecondBall = UIButton()
    private let rightThirdBall = UIButton()

    private lazy var ballsViewsCollection = [leftFirstBallView, leftSecondBallView, leftThirdBallView, rightFirstBallView, rightSecondBallView, rightThirdBallView]
    private lazy var ballsCollection = [leftFirstBall, leftSecondBall, leftThirdBall, rightFirstBall, rightSecondBall, rightThirdBall]
    
    private lazy var leftBallsViewToScaleConstraint = NSLayoutConstraint(item: leftBallsView, attribute: .bottom, relatedBy: .equal, toItem: scaleImageView, attribute: .top, multiplier: 1, constant: 10)
    private lazy var leftBallsViewToScaleLeftUpConstraint = NSLayoutConstraint(item: leftBallsView, attribute: .bottom, relatedBy: .equal, toItem: scaleLeftUpImageView, attribute: .top, multiplier: 1, constant: 10)
    private lazy var leftBallsViewToScaleRightUpConstraint = NSLayoutConstraint(item: leftBallsView, attribute: .bottom, relatedBy: .equal, toItem: scaleRightUpImageView, attribute: .top, multiplier: 1, constant: topOfScaleDownWing() + 10)
    
    private lazy var rightBallsViewToScaleConstraint = NSLayoutConstraint(item: rightBallsView, attribute: .bottom, relatedBy: .equal, toItem: scaleImageView, attribute: .top, multiplier: 1, constant: 10)
    private lazy var rightBallsViewToScaleRightUpConstraint = NSLayoutConstraint(item: rightBallsView, attribute: .bottom, relatedBy: .equal, toItem: scaleRightUpImageView, attribute: .top, multiplier: 1, constant: 10)
    private lazy var rightBallsViewToScaleLeftUpConstraint = NSLayoutConstraint(item: rightBallsView, attribute: .bottom, relatedBy: .equal, toItem: scaleLeftUpImageView, attribute: .top, multiplier: 1, constant: topOfScaleDownWing() + 10)
    
    //MARK: - Properties
    
    var game: Game!
    var difficulty: GameDifficulty!

    private var hasThreeBalls: Bool?

    private var wrongAnswersCount = 0

    private var currentSignImage: UIImage?

    static func initWithStoryboard() -> ScaleGameIntermediateAdvanceViewController? {
        let storyboard = UIStoryboard(name: "ScaleGame", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: ScaleGameIntermediateAdvanceViewController.name) as? ScaleGameIntermediateAdvanceViewController
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()

        DispatchQueue.main.async {
            self.setBallLeadingTrailingConstraints(scaleImageView: self.scaleImageView, leftBallView: self.leftBallsView, rightBallView: self.rightBallsView)
        }
    }

    //MARK: - View Update Functions
    
    private func setup() {
        rightAnswersLabel.text = "\(RightWrongAnswers.scaleRight)"
        wrongAnswersLabel.text = "\(RightWrongAnswers.scaleWrong)"
        buttonsCollection.forEach { $0.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))) }
        backButton.setNavigation(navigationController)
        gameGroundView.setBorder()
        gameGroundView.setCorner()
        setupBallsConstraints()
        setupViews()
        resultsView.setBorder(color: .borderBlue)
        resultsView.setCorner()
        timerView.setBorder()
        timerView.setCorner()
        timerLabel.textColor = .borderBlue
        rightAnswersLabel.textColor = .borderBlue
        wrongAnswersLabel.textColor = .borderBlue
        timerLabel.adjustsFontSizeToFitWidth = true
        showGameStartVC(self)

        let _ = Timer.scheduledTimer(withTimeInterval: 3.5, repeats: false) { [weak self] _ in
            self?.startTimer()
        }
    }
    
    private func setupViews() {
        setupImages()
        setupScaleView()
        setAnimatingViews()
    }

    private func setupImages() {
        //sign image

        if GamesLimit.scaleLimit == 0 {
            signImageView.image = UIImage(named: "biggerGreen")
        } else if GamesLimit.scaleLimit == 1 {
            signImageView.image = UIImage(named: "smallerPurple")
        } else {
            signImageView.image = UIImage(named: "equalBlue")
        }
        
        currentSignImage = signImageView.image
        
        // number buttons
        
        var numbers = Random.getRandomArray()
        
        for i in 0...6 {
            guard let number = numbers.first else { return }
            guard let image = UIImage(named: "btn_\(number)") else { return }
            let button = buttonsCollection[i]
            button.setImage(image, for: .normal)
            button.tag = number
            numbers.removeFirst()
        }
        
        //balls images
        
        updateBallsImages()
        updateBallsBools()
    }

    private func updateBallsImages() {
        guard let image = UIImage(named: "oneBall") else { return }

        ballsViewsCollection.forEach { ballView in
            ballView.image = image
        }

        ballsCollection.forEach { ball in
            ball.setImage(image, for: .normal)
            ball.tag = 0
            ball.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleBallButtonsPanGesture)))
            ball.isEnabled = false
        }
    }

    private func updateBallsBools() {
        if difficulty == .advance {
            hasThreeBalls = false
            hasThreeBalls = false
        } else {
            hasThreeBalls = nil
            hasThreeBalls = nil
        }
    }
    
    private func setupScaleView() {
        if !scaleLeftUpImageView.isHidden {
            scaleLeftUpImageView.isHidden = true
            leftBallsViewToScaleLeftUpConstraint.isActive = false
            rightBallsViewToScaleLeftUpConstraint.isActive = false
        } else if !scaleRightUpImageView.isHidden {
            scaleRightUpImageView.isHidden = true
            leftBallsViewToScaleRightUpConstraint.isActive = false
            rightBallsViewToScaleRightUpConstraint.isActive = false
        }

        scaleImageView.isHidden = false

        leftBallsViewToScaleConstraint.isActive = true
        rightBallsViewToScaleConstraint.isActive = true
    }

    private func setAnimatingViews() {
        buttonsCollection.animateFromBottom(point: CGPoint(x: 0, y: 120))
        signImageView.animateFromBottom(point: CGPoint(x: 0, y: 120))
    }

    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    @objc func updateTimer() {
        timerSecond += 1
        timerLabel.text = timerSecond.toHoursMinutesSeconds()
    }

    //MARK: - Constraints Functions

    private func setupBallsConstraints() {
        ballsViewsCollection.forEach { ballView in
            ballView.translatesAutoresizingMaskIntoConstraints = false
        }
        ballsCollection.forEach { ball in
            ball.translatesAutoresizingMaskIntoConstraints = false
        }
        leftBallsView.translatesAutoresizingMaskIntoConstraints = false
        rightBallsView.translatesAutoresizingMaskIntoConstraints = false
        
        leftBallsView.addSubview(leftFirstBallView)
        leftBallsView.addSubview(leftFirstBall)

        leftBallsView.addSubview(leftSecondBallView)
        leftBallsView.addSubview(leftSecondBall)

        rightBallsView.addSubview(rightFirstBallView)
        rightBallsView.addSubview(rightFirstBall)

        rightBallsView.addSubview(rightSecondBallView)
        rightBallsView.addSubview(rightSecondBall)

        
        gameGroundView.addSubview(leftBallsView)
        gameGroundView.addSubview(rightBallsView)

        gameGroundView.sendSubviewToBack(leftBallsView)
        gameGroundView.sendSubviewToBack(rightBallsView)
        
        if difficulty == .advance {
            leftThirdBall.translatesAutoresizingMaskIntoConstraints = false
            rightThirdBall.translatesAutoresizingMaskIntoConstraints = false
            
            gameGroundView.addSubview(leftThirdBall)
            gameGroundView.addSubview(leftThirdBallView)

            gameGroundView.addSubview(rightThirdBall)
            gameGroundView.addSubview(rightThirdBallView)

            gameGroundView.sendSubviewToBack(leftThirdBall)
            gameGroundView.sendSubviewToBack(leftThirdBallView)

            gameGroundView.sendSubviewToBack(rightThirdBall)
            gameGroundView.sendSubviewToBack(rightThirdBallView)


            var constant: CGFloat {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    return 14
                } else {
                    return 10
                }
            }

            leftThirdBallView.heightAnchor.constraint(equalTo: firstButton.heightAnchor).isActive = true
            leftThirdBallView.widthAnchor.constraint(equalTo: firstButton.heightAnchor).isActive = true
            leftThirdBallView.centerXAnchor.constraint(equalTo: leftBallsView.centerXAnchor).isActive = true
            leftThirdBallView.bottomAnchor.constraint(equalTo: leftBallsView.topAnchor, constant: constant).isActive = true
            rightThirdBallView.heightAnchor.constraint(equalTo: firstButton.heightAnchor).isActive = true
            rightThirdBallView.widthAnchor.constraint(equalTo: firstButton.heightAnchor).isActive = true
            rightThirdBallView.centerXAnchor.constraint(equalTo: rightBallsView.centerXAnchor).isActive = true
            rightThirdBallView.bottomAnchor.constraint(equalTo: rightBallsView.topAnchor, constant: constant).isActive = true

            leftThirdBall.heightAnchor.constraint(equalTo: firstButton.heightAnchor).isActive = true
            leftThirdBall.widthAnchor.constraint(equalTo: firstButton.heightAnchor).isActive = true
            leftThirdBall.centerXAnchor.constraint(equalTo: leftBallsView.centerXAnchor).isActive = true
            leftThirdBall.bottomAnchor.constraint(equalTo: leftBallsView.topAnchor, constant: constant).isActive = true
            rightThirdBall.heightAnchor.constraint(equalTo: firstButton.heightAnchor).isActive = true
            rightThirdBall.widthAnchor.constraint(equalTo: firstButton.heightAnchor).isActive = true
            rightThirdBall.centerXAnchor.constraint(equalTo: rightBallsView.centerXAnchor).isActive = true
            rightThirdBall.bottomAnchor.constraint(equalTo: rightBallsView.topAnchor, constant: constant).isActive = true
        }

        leftFirstBallView.heightAnchor.constraint(equalTo: firstButton.heightAnchor).isActive = true
        leftFirstBallView.widthAnchor.constraint(equalTo: firstButton.heightAnchor).isActive = true
        leftSecondBallView.heightAnchor.constraint(equalTo: firstButton.heightAnchor).isActive = true
        leftSecondBallView.widthAnchor.constraint(equalTo: firstButton.heightAnchor).isActive = true

        leftFirstBall.heightAnchor.constraint(equalTo: firstButton.heightAnchor).isActive = true
        leftFirstBall.widthAnchor.constraint(equalTo: firstButton.heightAnchor).isActive = true
        leftSecondBall.heightAnchor.constraint(equalTo: firstButton.heightAnchor).isActive = true
        leftSecondBall.widthAnchor.constraint(equalTo: firstButton.heightAnchor).isActive = true

        rightFirstBallView.heightAnchor.constraint(equalTo: firstButton.heightAnchor).isActive = true
        rightFirstBallView.widthAnchor.constraint(equalTo: firstButton.heightAnchor).isActive = true
        rightSecondBallView.heightAnchor.constraint(equalTo: firstButton.heightAnchor).isActive = true
        rightSecondBallView.widthAnchor.constraint(equalTo: firstButton.heightAnchor).isActive = true
        
        rightFirstBall.heightAnchor.constraint(equalTo: firstButton.heightAnchor).isActive = true
        rightFirstBall.widthAnchor.constraint(equalTo: firstButton.heightAnchor).isActive = true
        rightSecondBall.heightAnchor.constraint(equalTo: firstButton.heightAnchor).isActive = true
        rightSecondBall.widthAnchor.constraint(equalTo: firstButton.heightAnchor).isActive = true

        leftFirstBallView.leadingAnchor.constraint(equalTo: leftBallsView.leadingAnchor).isActive = true
        leftFirstBallView.topAnchor.constraint(equalTo: leftBallsView.topAnchor).isActive = true
        leftFirstBallView.bottomAnchor.constraint(equalTo: leftBallsView.bottomAnchor).isActive = true
        leftFirstBallView.trailingAnchor.constraint(equalTo: leftSecondBall.leadingAnchor).isActive = true
        
        leftFirstBall.leadingAnchor.constraint(equalTo: leftBallsView.leadingAnchor).isActive = true
        leftFirstBall.topAnchor.constraint(equalTo: leftBallsView.topAnchor).isActive = true
        leftFirstBall.bottomAnchor.constraint(equalTo: leftBallsView.bottomAnchor).isActive = true
        leftFirstBall.trailingAnchor.constraint(equalTo: leftSecondBall.leadingAnchor).isActive = true

        leftSecondBallView.topAnchor.constraint(equalTo: leftBallsView.topAnchor).isActive = true
        leftSecondBallView.bottomAnchor.constraint(equalTo: leftBallsView.bottomAnchor).isActive = true
        leftSecondBallView.trailingAnchor.constraint(equalTo: leftBallsView.trailingAnchor).isActive = true
        
        leftSecondBall.topAnchor.constraint(equalTo: leftBallsView.topAnchor).isActive = true
        leftSecondBall.bottomAnchor.constraint(equalTo: leftBallsView.bottomAnchor).isActive = true
        leftSecondBall.trailingAnchor.constraint(equalTo: leftBallsView.trailingAnchor).isActive = true

        rightFirstBallView.leadingAnchor.constraint(equalTo: rightBallsView.leadingAnchor).isActive = true
        rightFirstBallView.topAnchor.constraint(equalTo: rightBallsView.topAnchor).isActive = true
        rightFirstBallView.bottomAnchor.constraint(equalTo: rightBallsView.bottomAnchor).isActive = true
        rightFirstBallView.trailingAnchor.constraint(equalTo: rightSecondBall.leadingAnchor).isActive = true
        
        rightFirstBall.leadingAnchor.constraint(equalTo: rightBallsView.leadingAnchor).isActive = true
        rightFirstBall.topAnchor.constraint(equalTo: rightBallsView.topAnchor).isActive = true
        rightFirstBall.bottomAnchor.constraint(equalTo: rightBallsView.bottomAnchor).isActive = true
        rightFirstBall.trailingAnchor.constraint(equalTo: rightSecondBall.leadingAnchor).isActive = true

        rightSecondBallView.topAnchor.constraint(equalTo: rightBallsView.topAnchor).isActive = true
        rightSecondBallView.bottomAnchor.constraint(equalTo: rightBallsView.bottomAnchor).isActive = true
        rightSecondBallView.trailingAnchor.constraint(equalTo: rightBallsView.trailingAnchor).isActive = true
        
        rightSecondBall.topAnchor.constraint(equalTo: rightBallsView.topAnchor).isActive = true
        rightSecondBall.bottomAnchor.constraint(equalTo: rightBallsView.bottomAnchor).isActive = true
        rightSecondBall.trailingAnchor.constraint(equalTo: rightBallsView.trailingAnchor).isActive = true
    }

    //top point of left/right wing of scale Right/Left Up Image
    private func topOfScaleDownWing() -> CGFloat {
        // original scaleLeftUp or scaleRightUp image height
        let imageHeight: Double = 148.69
        // original distance from down wing to scale(LeftUp/RightUp) image top
        let distance: Double = 66.1
        // coefficient for calculating distance depending on new scale(LeftUp/RightUp) sizes
        let coefficient = distance / imageHeight
        
        let newDistance: Double = scaleLeftUpImageView.frame.height *  coefficient
        
        return CGFloat(newDistance)
    }


    //MARK: - Logic Functions

    private func setCloneButton(from button: UIButton, to destination: UIButton) {
        destination.isEnabled = true
        destination.alpha = 1
        destination.tag = button.tag
        destination.setImage(button.currentImage, for: .normal)
        button.transform = .identity
        button.alpha = 0
        button.isEnabled = false
    }

    // when taking button from numbers
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
        } else if gesture.state == .ended {
            let buttonMaxY = button.globalFrame.maxY
            let buttonX = button.globalFrame.origin.x

            if buttonMaxY >= leftBallsView.globalFrame.minY - 50 && buttonX <= leftBallsView.globalFrame.maxX && buttonX >= leftBallsView.globalFrame.minX - 20 {
                if leftFirstBall.isEnabled == false {
                    setCloneButton(from: button, to: leftFirstBall)
                    compareLeftWing()
                    checkAndCompare()
                    return
                } else if leftSecondBall.isEnabled == false {
                    setCloneButton(from: button, to: leftSecondBall)
                    compareLeftWing()
                    checkAndCompare()
                    return
                } else if hasThreeBalls != nil && leftThirdBall.isEnabled == false {
                    setCloneButton(from: button, to: leftThirdBall)
                    compareLeftWing()
                    checkAndCompare()
                    return
                } else {
                    lose(button: button)
                }
            } else if buttonMaxY >= rightBallsView.globalFrame.minY - 50 && buttonX >= rightBallsView.globalFrame.minX - 20 && buttonX <= rightBallsView.globalFrame.maxX {
                if rightFirstBall.isEnabled == false {
                    setCloneButton(from: button, to: rightFirstBall)
                    compareRightWing()
                    checkAndCompare()
                    return
                } else if rightSecondBall.isEnabled == false {
                    setCloneButton(from: button, to: rightSecondBall)
                    compareRightWing()
                    checkAndCompare()
                    return
                } else if hasThreeBalls != nil && rightThirdBall.isEnabled == false {
                    setCloneButton(from: button, to: rightThirdBall)
                    compareRightWing()
                    checkAndCompare()
                    return
                } else {
                    lose(button: button)
                }
            } else {
                lose(button: button)
            }
        }
    }

    // when taking button from scale
    @objc func handleBallButtonsPanGesture(gesture: UIPanGestureRecognizer) {
        guard let button = gesture.view as? UIButton else { return }

        if gesture.state == .began {
            self.fingerArray.forEach({$0.removeFromSuperview()})
            self.fingerArray.removeAll()
        } else if gesture.state == .changed {
            let translation = gesture.translation(in: self.view)
            button.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
        } else if gesture.state == .cancelled {
            lose(button: button)
        } else if gesture.state == .ended {
            let buttonMinY = button.globalFrame.minY

            if buttonMinY <= numberButtonsStackView.globalFrame.maxY + 20 {
                for numberButton in buttonsCollection {
                    if numberButton.isEnabled == false {
                        setCloneButton(from: button, to: numberButton)
                        break
                    }
                }
                button.tag = 0

                if button === leftFirstBall || button === leftSecondBall || button === leftThirdBall {
                    compareLeftWing()
                    return
                } else {
                    compareRightWing()
                }
            } else {
                lose(button: button)
            }
        }
    }

    //when you put some number on scale left side, this function is being called and updates scale view
    private func compareLeftWing() {
        if leftFirstBall.tag + leftSecondBall.tag + leftThirdBall.tag > rightFirstBall.tag + rightSecondBall.tag + rightThirdBall.tag {
            if !scaleImageView.isHidden {
                let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [self] _ in
                    UIView.transition(with: scaleRightUpImageView, duration: 0.1, options: .transitionCrossDissolve) {
                        self.scaleRightUpImageView.isHidden = false
                    }
                    let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                        self.scaleImageView.isHidden = true
                    }
                    leftBallsViewToScaleConstraint.isActive = false
                    rightBallsViewToScaleConstraint.isActive = false
                    leftBallsViewToScaleRightUpConstraint.isActive = true
                    rightBallsViewToScaleRightUpConstraint.isActive = true
                }
            } else if !scaleLeftUpImageView.isHidden {
                let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [self] _ in
                    UIView.transition(with: scaleRightUpImageView, duration: 0.1, options: .transitionCrossDissolve) {
                        self.scaleRightUpImageView.isHidden = false
                        self.scaleImageView.isHidden = false
                    }
                    let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                        self.scaleImageView.isHidden = true
                        self.scaleLeftUpImageView.isHidden = true
                    }
                    leftBallsViewToScaleLeftUpConstraint.isActive = false
                    rightBallsViewToScaleLeftUpConstraint.isActive = false
                    leftBallsViewToScaleRightUpConstraint.isActive = true
                    rightBallsViewToScaleRightUpConstraint.isActive = true
                }
            }
        } else if leftFirstBall.tag + leftSecondBall.tag + leftThirdBall.tag < rightFirstBall.tag + rightSecondBall.tag + rightThirdBall.tag {
            if !scaleRightUpImageView.isHidden {
                let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [self] _ in
                    UIView.transition(with: scaleLeftUpImageView, duration: 0.1, options: .transitionCrossDissolve) {
                        self.scaleLeftUpImageView.isHidden = false
                        self.scaleImageView.isHidden = false
                    }
                    let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                        self.scaleImageView.isHidden = true
                        self.scaleRightUpImageView.isHidden = true
                    }
                    leftBallsViewToScaleRightUpConstraint.isActive = false
                    rightBallsViewToScaleRightUpConstraint.isActive = false
                    leftBallsViewToScaleLeftUpConstraint.isActive = true
                    rightBallsViewToScaleLeftUpConstraint.isActive = true
                }
            } else if !scaleImageView.isHidden {
                let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [self] _ in
                    UIView.transition(with: scaleLeftUpImageView, duration: 0.1, options: .transitionCrossDissolve) {
                        self.scaleLeftUpImageView.isHidden = false
                    }
                    let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                        self.scaleImageView.isHidden = true
                    }
                    leftBallsViewToScaleConstraint.isActive = false
                    rightBallsViewToScaleConstraint.isActive = false
                    leftBallsViewToScaleLeftUpConstraint.isActive = true
                    rightBallsViewToScaleLeftUpConstraint.isActive = true
                }
            }
        } else if leftFirstBall.tag + leftSecondBall.tag + leftThirdBall.tag == rightFirstBall.tag + rightSecondBall.tag + rightThirdBall.tag {
            if scaleImageView.isHidden {
                let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [self] _ in
                    UIView.transition(with: scaleImageView, duration: 0.1, options: .transitionCrossDissolve) {
                        self.scaleImageView.isHidden = false
                    }
                    let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                        self.scaleLeftUpImageView.isHidden = true
                        self.scaleRightUpImageView.isHidden = true
                    }
                    leftBallsViewToScaleLeftUpConstraint.isActive = false
                    rightBallsViewToScaleLeftUpConstraint.isActive = false
                    leftBallsViewToScaleRightUpConstraint.isActive = false
                    rightBallsViewToScaleRightUpConstraint.isActive = false
                    leftBallsViewToScaleConstraint.isActive = true
                    rightBallsViewToScaleConstraint.isActive = true
                }
            }
        }
    }

    //when you put some number on scale right side, this function is being called and updates scale view
    private func compareRightWing() {
        if rightFirstBall.tag + rightSecondBall.tag + rightThirdBall.tag > leftFirstBall.tag + leftSecondBall.tag + leftThirdBall.tag {
            if !scaleImageView.isHidden {
                let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [self] _ in
                    UIView.transition(with: scaleLeftUpImageView, duration: 0.1, options: .transitionCrossDissolve) {
                        self.scaleLeftUpImageView.isHidden = false
                    }
                    let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                        self.scaleImageView.isHidden = true
                    }
                    leftBallsViewToScaleConstraint.isActive = false
                    rightBallsViewToScaleConstraint.isActive = false
                    leftBallsViewToScaleLeftUpConstraint.isActive = true
                    rightBallsViewToScaleLeftUpConstraint.isActive = true
                }
            } else if !scaleRightUpImageView.isHidden {
                let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [self] _ in
                    UIView.transition(with: scaleLeftUpImageView, duration: 0.1, options: .transitionCrossDissolve) {
                        self.scaleLeftUpImageView.isHidden = false
                        self.scaleImageView.isHidden = false
                    }
                    let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                        self.scaleImageView.isHidden = true
                        self.scaleRightUpImageView.isHidden = true
                    }
                    leftBallsViewToScaleRightUpConstraint.isActive = false
                    rightBallsViewToScaleRightUpConstraint.isActive = false
                    leftBallsViewToScaleLeftUpConstraint.isActive = true
                    rightBallsViewToScaleLeftUpConstraint.isActive = true
                }
            }
        } else if rightFirstBall.tag + rightSecondBall.tag + rightThirdBall.tag < leftFirstBall.tag + leftSecondBall.tag + leftThirdBall.tag {
            if !scaleLeftUpImageView.isHidden {
                let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [self] _ in
                    UIView.transition(with: scaleRightUpImageView, duration: 0.1, options: .transitionCrossDissolve) {
                        self.scaleRightUpImageView.isHidden = false
                        self.scaleImageView.isHidden = false
                    }
                    let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                        self.scaleLeftUpImageView.isHidden = true
                        self.scaleImageView.isHidden = true
                    }
                    leftBallsViewToScaleLeftUpConstraint.isActive = false
                    rightBallsViewToScaleLeftUpConstraint.isActive = false
                    leftBallsViewToScaleRightUpConstraint.isActive = true
                    rightBallsViewToScaleRightUpConstraint.isActive = true
                }
            } else if !scaleImageView.isHidden {
                let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [self] _ in
                    UIView.transition(with: scaleRightUpImageView, duration: 0.1, options: .transitionCrossDissolve) {
                        self.scaleRightUpImageView.isHidden = false
                    }
                    let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                        self.scaleImageView.isHidden = true
                    }
                    leftBallsViewToScaleConstraint.isActive = false
                    rightBallsViewToScaleConstraint.isActive = false
                    leftBallsViewToScaleRightUpConstraint.isActive = true
                    rightBallsViewToScaleRightUpConstraint.isActive = true
                }
            }
        }   else if rightFirstBall.tag + rightSecondBall.tag + rightThirdBall.tag == leftFirstBall.tag + leftSecondBall.tag + leftThirdBall.tag {
            if scaleImageView.isHidden {
                let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [self] _ in
                    UIView.transition(with: scaleImageView, duration: 0.1, options: .transitionCrossDissolve) {
                        self.scaleImageView.isHidden = false
                    }
                    let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                        self.scaleRightUpImageView.isHidden = true
                        self.scaleLeftUpImageView.isHidden = true
                    }
                    leftBallsViewToScaleRightUpConstraint.isActive = false
                    rightBallsViewToScaleRightUpConstraint.isActive = false
                    leftBallsViewToScaleLeftUpConstraint.isActive = false
                    rightBallsViewToScaleLeftUpConstraint.isActive = false
                    leftBallsViewToScaleConstraint.isActive = true
                    rightBallsViewToScaleConstraint.isActive = true
                }
            }
        }
    }

    private func checkAndCompare() {
        if difficulty != .advance {
            if leftFirstBall.isEnabled == true && leftSecondBall.isEnabled == true && rightFirstBall.isEnabled == true && rightSecondBall.isEnabled == true {
                checkEquality()
            }
        } else {
            if leftFirstBall.isEnabled == true && leftSecondBall.isEnabled == true && leftThirdBall.isEnabled == true && rightFirstBall.isEnabled == true && rightSecondBall.isEnabled == true && rightThirdBall.isEnabled == true {
                checkEquality()
            }
        }
    }

    private func checkEquality() {
        if signImageView.image == UIImage(named: "smallerPurple") {
            if leftFirstBall.tag + leftSecondBall.tag + leftThirdBall.tag < rightFirstBall.tag + rightSecondBall.tag + rightThirdBall.tag {
                roundEnded()
                newRound()
            } else {
                updateViewsWhenWrong()
            }
        } else if signImageView.image == UIImage(named: "biggerGreen") {
            if leftFirstBall.tag + leftSecondBall.tag + leftThirdBall.tag > rightFirstBall.tag + rightSecondBall.tag + rightThirdBall.tag {
                roundEnded()
                newRound()
            } else {
                updateViewsWhenWrong()
            }
        } else {
            if leftFirstBall.tag + leftSecondBall.tag + leftThirdBall.tag == rightFirstBall.tag + rightSecondBall.tag + rightThirdBall.tag {
                roundEnded()
                newRound()
            } else {
                updateViewsWhenWrong()
            }
        }
    }


    //when scale is full with numbers and result is wrong(depending on sign), this function is being called and resets the view
    private func updateViewsWhenWrong() {
        let _ = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [self] _ in
            audio.playLoseSound()
            RightWrongAnswers.scaleWrong += 1
            UserDefaults.standard.setValue(RightWrongAnswers.scaleWrong, forKey: UserDefaultsKeys.scaleWrongAnswers)
            wrongAnswersCount = UserDefaults.standard.value(forKey: UserDefaultsKeys.scaleWrongAnswers) as? Int ?? 0
            wrongAnswersLabel.text = "\(wrongAnswersCount)"

            var image: UIImage {
                if signImageView.image == UIImage(named: "smallerPurple") {
                    return UIImage(named: "smallerRed")!
                } else if signImageView.image == UIImage(named: "biggerGreen") {
                    return UIImage(named: "biggerRed")!
                } else {
                    return UIImage(named: "equalRed")!
                }
            }
            signImageView.image = image
            signImageView.animateWithShakeLonger()
            ballsCollection.forEach { button in
                button.isUserInteractionEnabled = false
            }
        }

        let _ = Timer.scheduledTimer(withTimeInterval: 2.6, repeats: false) { [self] _ in
            updateBallsImages()
            ballsCollection.forEach { button in
                button.isUserInteractionEnabled = true
            }
            buttonsCollection.forEach { button in
                button.alpha = 1
                button.isEnabled = true
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseIn) {
                    button.transform = .identity
                    self.signImageView.image = self.currentSignImage
                }
            }
            setupScaleView()
        }
    }

    private func roundEnded() {
        timerSecond = 0
        timer.invalidate()
        RightWrongAnswers.scaleRight += 1
        UserDefaults.standard.setValue(RightWrongAnswers.scaleRight, forKey: UserDefaultsKeys.scaleRightAnswers)
        rightAnswersCount = UserDefaults.standard.value(forKey: UserDefaultsKeys.scaleRightAnswers) as? Int ?? 0
        rightAnswersLabel.text = "\(rightAnswersCount)"
        GamesLimit.scaleLimit += 1
        UserDefaults.standard.setValue(GamesLimit.scaleLimit, forKey: UserDefaultsKeys.scaleLimit)
        audio.playWinSound()
    }

    private func newRound() {
        if GamesLimit.scaleLimit < 5 {
            let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] _ in
                self?.startTimer()
            }
            let _ = Timer.scheduledTimer(withTimeInterval: 1.2, repeats: false) { [weak self] _ in
                self?.buttonsCollection.forEach { button in
                    button.alpha = 1
                    button.isEnabled = true
                }
                self?.setupViews()
            }
        } else {
            if !subscribed {
                game.isLocked = true
            }
            GamesLimit.scaleLimit = 0
            UserDefaults.standard.setValue(GamesLimit.scaleLimit, forKey: UserDefaultsKeys.scaleLimit)

            let _ = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false) { [weak self] _ in
                self?.presentEndPopUpVC(delegate: self, icon: "crar", refresh: true)
                self?.view.bringSubviewToFront(self!.backButton)
            }
        }
    }
}

//MARK: - Extensions

extension ScaleGameIntermediateAdvanceViewController: EndPopUpViewControllerDelegate {
    func backTapped() { backButton.tapped() }
    
    func refreshTapped() {
        if subscribed {
            newRound()
        } else {
            ballsCollection.forEach { ball in
                ball.isUserInteractionEnabled = false
            }
            showParentalController()
        }
    }
}

extension ScaleGameIntermediateAdvanceViewController: GameStartDelegate {
    func start() {
        print("Game Started")
    }

    func setNavigationIndexes(_ indexes: [Int]) {
        print("")
    }
}
