//
//  SortingNumbersController.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 13.07.21.
//

import UIKit

class SortingNumbersController: BaseViewController {
    
    @IBOutlet var buttonsCollection: [UIButton]!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var thirdImage: UIImageView!
    @IBOutlet weak var fourthImage: UIImageView!
    @IBOutlet var imageViewCollection: [UIImageView]!
    @IBOutlet weak var prizContainerView: UIView!
    @IBOutlet weak var prizImageView: UIImageView!
    @IBOutlet weak var gameGroundView: UIView!
    @IBOutlet weak var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerLeftConstraint: NSLayoutConstraint!
    
    var game: Game!
    
    private var resultCGPoint: CGPoint!
    private var layoutSubviewsCount: Int! = 0
    private var firstCount = 0
    private var secondCount = 0
    private var thirdCount = 0
    private var fourthCount = 0
    
    private var touchedButton = false
    
    
    
    static func initWithStoryboard() -> SortingNumbersController? {
        let storyboard = UIStoryboard(name: "SortingGames", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: SortingNumbersController.name) as? SortingNumbersController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameGroundView.layer.borderWidth = 5
        gameGroundView.layer.borderColor = #colorLiteral(red: 0.7490196078, green: 0.1882352941, blue: 0.2156862745, alpha: 1)
        
        if isAscending {
            //            GamesLimit.sortingNum_1PrizCount = UserDefaults.standard.value(forKey: UserDefaultsKeys.sortingNum_1PrizCount) as? Int ?? 0
        } else {
            //            GamesLimit.sortingNum_2PrizCount = UserDefaults.standard.value(forKey: UserDefaultsKeys.sortingNum_2PrizCount) as? Int ?? 0
            
            for i in imageViewCollection {
                i.image = UIImage(named: "descending_button")
            }
        }
        
        firstButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        secondButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        thirdButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        fourthButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gestureButtonAction)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: .updateSortingNum_1, object: nil)
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
    
    private func setFinger() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
            if !self.touchedButton {
                for i in self.buttonsCollection {
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
        if isAscending {
            GamesLimit.sortingNum_1Limit = 0
        } else {
            GamesLimit.sortingNum_2Limit = 0
        }
        
        buttonsCollection.forEach({$0.transform = .identity})
        buttonsCollection.forEach({$0.alpha = 1})
        imageViewCollection.forEach({$0.alpha = 1})
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
    
    private func configureImageView() {
        var limit_4Array: [Int] = []
        
        let count: Int = 4
        let minNumber: Int = 0
        let maxNumber: Int = 10
        
        var numbers: [Int] = [Int](minNumber...maxNumber)
        if !isAscending {
            numbers.reverse()
        }
        
        let number: Int = Random.getRandomIndex(in: 0..<(maxNumber - 2))
        
        for i in number..<(number+count) {
            limit_4Array.append(numbers[i])
        }
        print(limit_4Array)
        firstImage.tag = limit_4Array[0]
        firstCount = firstImage.tag
        secondImage.tag = limit_4Array[1]
        secondCount = secondImage.tag
        thirdImage.tag = limit_4Array[2]
        thirdCount = thirdImage.tag
        fourthImage.tag = limit_4Array[3]
        fourthCount = fourthImage.tag
    }
    
    private func setupButtonsImage() {
        var indexes = [firstCount, secondCount, thirdCount, fourthCount]
        
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
    private func setAnimatingViews() {
        imageViewCollection.forEach({$0.changeSizeImageWithAnimate()})
        buttonsCollection.animateFromBottom(point: CGPoint(x: 0, y: 120))
    }
    
    
    @objc func gestureButtonAction(gesture: UIPanGestureRecognizer) {
        fourOrMoreButtonPanGesture(gesture: gesture, gamesLimit: isAscending ? GamesLimit.sortingNum_1Limit : GamesLimit.sortingNum_2Limit , resultSpace: UIImageView(), finalCount: 0, firstView: prizContainerView! as! UIImageView, secondView: prizImageView, gamesType: "SortingNumbersController",containerView: UIView(), imageView: UIImageView(), imageCollection: imageViewCollection, stackViewCollection: [UIStackView](),gamesTypeForLimit: isAscending ? "sortingNum_1Limit" : "sortingNum_2Limit", viewCollection: [UIView]())
        delegate = self
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
extension SortingNumbersController:handlePanGestureDelegate {
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
            self.buttonsCollection.forEach({$0.transform = .identity})
            self.buttonsCollection.forEach({$0.alpha = 1})
            self.imageViewCollection.forEach({$0.alpha = 1})
        }
    }
}
