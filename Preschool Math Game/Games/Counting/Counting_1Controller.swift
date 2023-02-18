//
//  Counting_1Controller.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 5/4/21.
//

import UIKit

class Counting_1Controller: BaseViewController {

    //MARK: - Outlets
    @IBOutlet weak var gameGround: UIView!
    @IBOutlet weak var firstView: BorderView!
    @IBOutlet weak var secondView: BorderView!
    @IBOutlet weak var thirdView: BorderView!
    @IBOutlet weak var fourthView: BorderView!
    @IBOutlet var buttonsCollection: [UIButton]!
    @IBOutlet weak var viewsStack: UIStackView!
    @IBOutlet weak var drawingPathView: DrawingWithPath!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    @IBOutlet weak var prizContainerView: UIView!
    @IBOutlet weak var prizImageView: UIImageView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    // MARK: - Properties

    var game: Game!

    private var imagesArray = ["star_image", "meduza_image", "rak_image", "orange_dinuzavr", "nav_img", "orange_car", "hourse_img", "gray_koala", "orange_koala", "green_kria", "maloj", "gortik", "mishka", "asminog"]

    private var firstImage = UIImage()
    private var secondImage = UIImage()
    private var thirdImage = UIImage()
    private var fourthImage = UIImage()

    private var firstCount = 0
    private var secondCount = 0
    private var thirdCount = 0
    private var fouthCount = 0
    
    private var rightAnswerArray = [Int]()
    private var layoutSubviewsCount = 0
    private var float: CGFloat!
    private var guessed = false
    private var updated  = false

    private var sound = GameSounds()

    static func initWithStoryboard() -> Counting_1Controller? {
        let storyboard = UIStoryboard(name: "CountingGames", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: Counting_1Controller.name) as? Counting_1Controller
    }

    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        self.guessed = false

        //        AnalyticService.shared.setupAmplitude(game: "start_counting_1")

        //        GamesLimit.counting_1PrizCount = UserDefaults.standard.value(forKey: UserDefaultsKeys.counting_1PrizCount) as? Int ?? 0

        gameGround.layer.borderWidth = 5
        gameGround.layer.borderColor = #colorLiteral(red: 0.7490196078, green: 0.1882352941, blue: 0.2156862745, alpha: 1)

        buttonsCollection.forEach({$0.isUserInteractionEnabled = false})

        drawingPathView.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(changeUpdate), name: .updateCounting_1, object: nil)

        if GamesLimit.isShowHunt {
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) { self.setFinger() }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard updated else { return }
        updated = false
        update()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if UIScreen.main.bounds.height >= 1000 {
            topConstraint.constant = 200
            bottomConstraint.constant = 200
        }

        if layoutSubviewsCount == 1 { drawUI() }
        layoutSubviewsCount += 1
    }

    deinit { NotificationCenter.default.removeObserver(self) }

    // MARK: - Fucntions
    private func setFinger() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
            if !self.guessed {
                switch self.rightAnswersCount {
                case 0:
                    self.check(with: self.firstButton)
                case 1:
                    if !self.rightAnswerArray.contains(self.secondButton.tag) {
                        self.check(with: self.secondButton)
                    } else { self.check(with: self.firstButton) }
                case 2:
                    if !self.rightAnswerArray.contains(self.thirdButton.tag) {
                        self.check(with: self.thirdButton)
                    } else {
                        if !self.rightAnswerArray.contains(self.firstButton.tag) {
                            self.check(with: self.firstButton)
                        } else if !self.rightAnswerArray.contains(self.secondButton.tag) {
                            self.check(with: self.secondButton)
                        } else if !self.rightAnswerArray.contains(self.fourthButton.tag) {
                            self.check(with: self.fourthButton)
                        }
                    }
                case 3:
                    if !self.rightAnswerArray.contains(self.fourthButton.tag) {
                        self.check(with: self.fourthButton)
                    } else {
                        if !self.rightAnswerArray.contains(self.firstButton.tag) {
                            self.check(with: self.firstButton)
                        } else if !self.rightAnswerArray.contains(self.secondButton.tag) {
                            self.check(with: self.secondButton)
                        } else if !self.rightAnswerArray.contains(self.thirdButton.tag) {
                            self.check(with: self.thirdButton)
                        }
                    }
                default:
                    break
                }
            }
        }
    }

    private func check(with button: UIButton) {
        if button.tag == self.firstCount {
            let pointX = button.globalFrame.origin.x
            let pointY = button.globalFrame.origin.y + button.frame.height / 2
            self.setFingerWithAnimation(button: button, pointX: pointX, pointY: pointY, btnWidth: 60, btnHeight: 60)
        } else  if button.tag == self.secondCount {
            let pointX = button.globalFrame.origin.x
            let pointY = button.globalFrame.origin.y + button.frame.height / 2
            self.setFingerWithAnimation(button: button, pointX: pointX, pointY: pointY, btnWidth: 60, btnHeight: 60)
        } else if button.tag == self.thirdCount {
            let pointX = button.globalFrame.origin.x
            let pointY = button.globalFrame.origin.y + button.frame.height / 2
            self.setFingerWithAnimation(button: button, pointX: pointX, pointY: pointY, btnWidth: 60, btnHeight: 60)
        }  else if button.tag == self.fouthCount {
            let pointX = button.globalFrame.origin.x
            let pointY = button.globalFrame.origin.y + button.frame.height / 2
            self.setFingerWithAnimation(button: button, pointX: pointX, pointY: pointY, btnWidth: 60, btnHeight: 60)
        }
    }

    func setFingerWithAnimation(button: UIButton, pointX: CGFloat, pointY: CGFloat, btnWidth: CGFloat, btnHeight: CGFloat) {
        fingerImage.image = UIImage(named: "finger")
        fingerImage.frame = CGRect(x: pointX, y: pointY, width: btnWidth, height: btnHeight)
        view.addSubview(fingerImage)
        view.bringSubviewToFront(fingerImage)
        fingerArray.append(fingerImage)

        timer = Timer.scheduledTimer(withTimeInterval: 1.2, repeats: false) { timer in
            if !self.guessed {
                if button.tag == self.firstCount {
                    UIView.animate(withDuration: 1) {
                        let x = self.firstView.globalFrame.maxX - self.fingerImage.frame.width / 1.5
                        let y = self.firstView.globalFrame.origin.y + self.firstView.frame.height / 2
                        self.fingerImage.frame.origin.x = x
                        self.fingerImage.frame.origin.y = y
                    } completion: { bool in
                        if button.tag == self.firstCount {
                            self.fingerImage.frame.origin.x = button.globalFrame.origin.x
                            self.fingerImage.frame.origin.y = button.globalFrame.origin.y + button.frame.height / 2
                        }
                    }
                } else if button.tag == self.secondCount {
                    UIView.animate(withDuration: 1) {
                        let x = self.secondView.globalFrame.maxX - self.fingerImage.frame.width / 1.5
                        let y = self.secondView.globalFrame.origin.y + self.secondView.frame.height / 2
                        self.fingerImage.frame.origin.x = x
                        self.fingerImage.frame.origin.y = y
                    } completion: { bool in
                        if button.tag == self.secondCount {
                            self.fingerImage.frame.origin.x = button.globalFrame.origin.x
                            self.fingerImage.frame.origin.y = button.globalFrame.origin.y + button.frame.height / 2
                        }
                    }
                } else if button.tag == self.thirdCount {
                    UIView.animate(withDuration: 1) {
                        let x = self.thirdView.globalFrame.maxX - self.fingerImage.frame.width / 1.5
                        let y = self.thirdView.globalFrame.origin.y + self.thirdView.frame.height / 2
                        self.fingerImage.frame.origin.x = x
                        self.fingerImage.frame.origin.y = y
                    } completion: { bool in
                        if button.tag == self.thirdCount {
                            self.fingerImage.frame.origin.x = button.globalFrame.origin.x
                            self.fingerImage.frame.origin.y = button.globalFrame.origin.y + button.frame.height / 2
                        }
                    }
                } else if button.tag == self.fouthCount {
                    UIView.animate(withDuration: 1) {
                        let x = self.fourthView.globalFrame.maxX - self.fingerImage.frame.width / 1.5
                        let y = self.fourthView.globalFrame.origin.y + self.fourthView.frame.height / 2
                        self.fingerImage.frame.origin.x = x
                        self.fingerImage.frame.origin.y = y
                    } completion: { bool in
                        if button.tag == self.fouthCount {
                            self.fingerImage.frame.origin.x = button.globalFrame.origin.x
                            self.fingerImage.frame.origin.y = button.globalFrame.origin.y + button.frame.height / 2
                        }
                    }

                }
            }
        }
    }

    @objc func changeUpdate() { updated = true }

    private func update() {
        self.drawingPathView.removePath()
        self.firstView.subviews.forEach({$0.removeFromSuperview()})
        self.secondView.subviews.forEach({$0.removeFromSuperview()})
        self.thirdView.subviews.forEach({$0.removeFromSuperview()})
        self.fourthView.subviews.forEach({$0.removeFromSuperview()})
        GamesLimit.counting_1Limit = 0
        self.rightAnswersCount = 0
        self.drawingPathView.layer.sublayers = nil
        self.drawingPathView.setNeedsDisplay()
        self.rightAnswerArray.removeAll()
        self.drawUI()
    }

    private func drawUI() {
        let imageNamesRange = 0..<imagesArray.count
        var firstImageNameIndex = 0
        var secondImageNameIndex = 0
        var thirdImageNameIndex = 0
        var fourthImageNameIndex = 0

        firstImageNameIndex = Random.getRandomIndex(in: imageNamesRange ,ignoredIndexes: [secondImageNameIndex, thirdImageNameIndex, fourthImageNameIndex])
        secondImageNameIndex = Random.getRandomIndex(in: imageNamesRange, ignoredIndexes: [firstImageNameIndex, thirdImageNameIndex, fourthImageNameIndex])
        thirdImageNameIndex = Random.getRandomIndex(in: imageNamesRange, ignoredIndexes: [firstImageNameIndex, secondImageNameIndex, fourthImageNameIndex])
        fourthImageNameIndex = Random.getRandomIndex(in: imageNamesRange, ignoredIndexes: [firstImageNameIndex, secondImageNameIndex, thirdImageNameIndex])

        firstImage = getImage(with: firstImageNameIndex)
        secondImage = getImage(with: secondImageNameIndex)
        thirdImage = getImage(with: thirdImageNameIndex)
        fourthImage = getImage(with: fourthImageNameIndex)

        firstView.drawImages(image: firstImage, imagesCount: [secondView.subviews.count, thirdView.subviews.count, fourthView.subviews.count], view: firstView)
        secondView.drawImages(image: secondImage, imagesCount: [firstView.subviews.count, thirdView.subviews.count, fourthView.subviews.count], view: secondView)
        thirdView.drawImages(image: thirdImage, imagesCount: [firstView.subviews.count, secondView.subviews.count, fourthView.subviews.count], view: thirdView)
        fourthView.drawImages(image: fourthImage, imagesCount: [firstView.subviews.count, secondView.subviews.count, thirdView.subviews.count], view: fourthView)

        setSubViewCount()
        setupButtonsImage()
        animateViews()
    }

    private func getImage(with index: Int) -> UIImage { return UIImage(named: imagesArray[index])! }

    private func setSubViewCount() {
        firstCount = firstView.subviews.count
        secondCount = secondView.subviews.count
        thirdCount = thirdView.subviews.count
        fouthCount = fourthView.subviews.count
    }

    private func setupButtonsImage() {
        var indexes = [firstCount, secondCount, thirdCount, fouthCount]

        indexes = indexes.shuffled()

        for i in 0..<indexes.count {
            let number = indexes[i]
            let imageName = "btn_\(number)"
            let image = UIImage(named: imageName)!
            let button = buttonsCollection[i]
            button.setImage(image, for: .normal)
            button.tag = number
        }
    }

    private func animateViews() {
        [firstView, secondView, thirdView, fourthView].animateFromBottom(point: CGPoint(x: 0, y: 120))
        buttonsCollection.animateFromBottom(point: CGPoint(x: 0, y: 120))
    }

    // MARK: - Actions
    @IBAction func closeAction(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
}

// MARK: - Extension
extension Counting_1Controller: DrawingWithPathDelegate {
    func drawingWithPathDidDraw(_ view: DrawingWithPath, fromIndex: Int, toIndex: Int, isFromRightToLeft: Bool) {

        var first = 0
        var last = 0

        let leftArray = [firstCount, secondCount, thirdCount, fouthCount]
        let rightArray: [UIButton] = buttonsCollection

        guard toIndex < 4, leftArray.indices.contains(toIndex), rightArray.indices.contains(fromIndex) else { return }

        if isFromRightToLeft {
            first = rightArray[fromIndex].tag
            last = leftArray[toIndex]
        } else {
            first = leftArray[fromIndex]
            last = rightArray[toIndex].tag
        }

        if first == last {
            self.guessed = true
            self.fingerArray.forEach({$0.removeFromSuperview()})
            self.fingerArray.removeAll()

            if rightAnswerArray.contains(last) { return }
            rightAnswerArray.append(last)

            view.drawStraightLine()
            rightAnswersCount += 1

            if GamesLimit.isShowHunt {
                guessed = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) { self.setFinger() }
            }

            if !UserDefaults.standard.bool(forKey: UserDefaultsKeys.paymentKey) {
                timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { (timer) in
                    if GamesLimit.counting_1Limit < 4 {
                        if self.rightAnswersCount == 4 {
                            self.firstView.subviews.forEach({$0.removeFromSuperview()})
                            self.secondView.subviews.forEach({$0.removeFromSuperview()})
                            self.thirdView.subviews.forEach({$0.removeFromSuperview()})
                            self.fourthView.subviews.forEach({$0.removeFromSuperview()})
                            self.rightAnswersCount = 0
                            view.path.removeAllPoints()
                            self.audio.playWinSound()
                            self.drawingPathView.removePath()
                            self.rightAnswerArray.removeAll()
                            GamesLimit.counting_1Limit += 1
                            UserDefaults.standard.setValue(GamesLimit.counting_1Limit, forKey: UserDefaultsKeys.counting_1Limit)
                            self.drawUI()
                        }
                    } else {
                        if self.rightAnswersCount == 4 {
                            //                            GamesLimit.counting_1PrizCount += 1
//                            UserDefaults.standard.setValue(GamesLimit.counting_1PrizCount, forKey: UserDefaultsKeys.counting_1PrizCount)
                            self.game.isLocked = true
                            view.bringSubviewToFront(self.prizContainerView)
                            view.bringSubviewToFront(self.prizImageView)
                            self.prizContainerView.isHidden = false
                            self.prizImageView.isHidden = false
                            self.prizImageView.changeSizeImageWithAnimate()

                            let _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
                                self.prizContainerView.isHidden = true
                                self.prizImageView.isHidden = true
                            }

                            let _ = Timer.scheduledTimer(withTimeInterval: 3.1, repeats: false) { (timer) in
                                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ParentalControllController") as! ParentalControllController

                                vc.fromGame = true
                                self.addChild(vc)
                                self.view.addSubview(vc.view)
                                vc.didMove(toParent: self)
                            }
                        }
                    }
                }
            } else {
                if GamesLimit.counting_1Limit == 4 {
                    if self.rightAnswersCount == 4 {
                        GamesLimit.counting_1Limit = 0
                        UserDefaults.standard.setValue(GamesLimit.counting_1Limit, forKey: UserDefaultsKeys.counting_1Limit)
//                        GamesLimit.counting_1PrizCount += 1
//                        UserDefaults.standard.setValue(GamesLimit.counting_1PrizCount, forKey: UserDefaultsKeys.counting_1PrizCount)
                        view.bringSubviewToFront(prizContainerView)
                        view.bringSubviewToFront(prizImageView)
                        prizContainerView.isHidden = false
                        prizImageView.isHidden = false
                        prizImageView.changeSizeImageWithAnimate()

                        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
                            self.prizContainerView.isHidden = true
                            self.prizImageView.isHidden = true
                        }

                        timer = Timer.scheduledTimer(withTimeInterval: 3.1, repeats: false) { (timer) in
                            self.firstView.subviews.forEach({$0.removeFromSuperview()})
                            self.secondView.subviews.forEach({$0.removeFromSuperview()})
                            self.thirdView.subviews.forEach({$0.removeFromSuperview()})
                            self.fourthView.subviews.forEach({$0.removeFromSuperview()})
                            self.rightAnswersCount = 0
                            self.audio.playWinSound()
                            view.path.removeAllPoints()
                            self.drawingPathView.removePath()
                            self.rightAnswerArray.removeAll()
                            self.drawUI()
                        }
                    }
                } else {
                    if self.rightAnswersCount == 4 {
                        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
                            self.firstView.subviews.forEach({$0.removeFromSuperview()})
                            self.secondView.subviews.forEach({$0.removeFromSuperview()})
                            self.thirdView.subviews.forEach({$0.removeFromSuperview()})
                            self.fourthView.subviews.forEach({$0.removeFromSuperview()})
                            GamesLimit.counting_1Limit += 1
                            UserDefaults.standard.setValue(GamesLimit.counting_1Limit, forKey: UserDefaultsKeys.counting_1Limit)
                            self.rightAnswersCount = 0
                            self.audio.playWinSound()
                            view.path.removeAllPoints()
                            self.drawingPathView.removePath()
                            self.rightAnswerArray.removeAll()
                            self.drawUI()
                        }
                    }
                }
            }
        } else {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseIn) {
                rightArray.forEach { (button) in
                    if isFromRightToLeft {
                        if button.tag == first {
                            button.transform = CGAffineTransform(translationX: -5, y: 0)
                        }
                    } else {
                        if button.tag == last {
                            button.transform = CGAffineTransform(translationX: -5, y: 0)
                        }
                    }
                }
                self.audio.playLoseSound()
            } completion: { (bool) in
                rightArray.forEach({$0.transform = .identity})
            }
        }
    }
}
