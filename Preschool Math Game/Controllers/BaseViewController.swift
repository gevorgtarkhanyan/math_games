//
//  BaseViewController.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 6/28/21.
//

import UIKit

protocol handlePanGestureDelegate: AnyObject {
    func handlePanBools(bool1:Bool,bool2:Bool,bool3:Bool,bool4:Bool)
}

class BaseViewController: UIViewController {
    
    var gameType: GameDifficulty!
    var audio = GameSounds()
    var defaults = UserDefaults.standard
    var copyButton = UIButton()
    var finalButtons = [UIButton]()
    var fingerImage = UIImageView()
    var fingerArray = [UIImageView]()
    var cloneImage = UIImageView()
    var finalImage = [UIImageView]()
    var index = 0
    let brushWidth: CGFloat = 3
    var lastDrawPoint = CGPoint.zero
    var boundingBox: CGRect?
    var hasSwiped = false
    var isDrawing = false
    var timer = Timer()
    var timerSecond = 0
    var firstFinalCount = 0
    var secondFinalCount = 0
    var thirdFinalCount = 0
    var neuralNet: NeuralNet!
    var gamesCount = 0
    var firstCounts: Int = 0
    var secondCounts: Int = 0
    var thirdCounts: Int = 0
    var fourthCounts: Int = 0
    var fivethCounts: Int = 0
    var sixthCounts: Int = 0
    var workItem: DispatchWorkItem!
    var result_1 = 0
    var result_2 = 0
    var result_3 = 0
    var result_4 = 0
    var result_5 = 0
    var trueCount = 0
    var x:CGFloat = 0
    var y:CGFloat = 0
    weak var delegate: handlePanGestureDelegate?
    private var imageViewCollection:[UIImageView] = []
    private var resultViewCollection:[UIStackView] = []
    private var resultViews:[UIView] = []
    private var gamesType = ""
    var oddCounts = 0
    var evenCounts = 0
    var compareButtonType = ""
    var rightAnswersCount = 0
    var rightAnswers = [Int]()
    var advanceViewArray = [UIView]()
    var baseCount = 0
    var isAscending = true
    override var prefersHomeIndicatorAutoHidden: Bool { return false }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return UIRectEdge.bottom
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundCream
        if UserDefaults.standard.bool(forKey: UserDefaultsKeys.ischangeEfectsSoundStatus) {
            if UserDefaults.standard.bool(forKey: UserDefaultsKeys.efectsSoundIsOn) {
                audio.prepareLoseSound()
                audio.prepareWinSound()
            }
        } else {
            audio.prepareLoseSound()
            audio.prepareWinSound()
        }
    }
    
    func threeButtonPanGesture(gesture: UIPanGestureRecognizer, gamesLimit: Int,resultSpace:UIImageView, finalCount: Int, firstView: UIImageView, secondView: UIImageView, gamesType: String,containerView:UIView) {
        guard let button = gesture.view as? UIButton else {
            return
        }
        if gesture.state == .began {
            delegate?.handlePanBools(bool1: true, bool2: false, bool3: false, bool4: false)
            self.fingerArray.forEach({$0.removeFromSuperview()})
            self.fingerArray.removeAll()
        } else if gesture.state == .changed {
            let translation = gesture.translation(in: self.view)
            button.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
        } else if gesture.state == .ended {
            if button.tag == finalCount {
                var gameTypeLimit: Int { get {
                    UserDefaults.standard.value(forKey: gamesType) as? Int ?? 0
                } set {
                    return UserDefaults.standard.set(newValue, forKey: gamesType)
                }
                }
                if let item = workItem {
                    item.cancel()
                }
                let buttonOrigin = button.globalFrame.origin
                
                if gamesType == "shapes_2Limit" {
                    setCloneButton(button: button, point: buttonOrigin, btnWidth: button.frame.width, btnHeight: button.frame.height)
                    x = (containerView.globalFrame.minX + containerView.frame.width / 2) - button.frame.width / 2
                    y = (containerView.globalFrame.minY + containerView.frame.height / 2) - button.frame.height / 2
                } else if gamesType == "shapes_3Limit" {
                    setCloneButton(button: button, point: buttonOrigin, btnWidth: button.frame.width, btnHeight: button.frame.height)
                    x = resultSpace.globalFrame.origin.x
                    y = resultSpace.globalFrame.origin.y
                } else {
                    setCloneButton(button: button, point: buttonOrigin, btnWidth: button.frame.width, btnHeight: button.frame.height)
                }
                
                UIView.animate(withDuration: 0.3) {
                    if gamesType == "shapes_2Limit" {
                        self.copyButton.frame.origin = CGPoint(x: self.x, y: self.y)
                    } else if gamesType == "shapes_3Limit" {
                        self.copyButton.frame.origin = CGPoint(x: self.x, y: self.y)
                    } else if gamesType == "shapes_1Limit" || gamesType == "counting_2Limit"{
                        self.copyButton.frame.origin = CGPoint(x: containerView.globalFrame.minX , y: containerView.globalFrame.minY)
                    } else {
                        //                        self.copyButton.frame.origin = CGPoint(x: resultSpace.globalFrame.minX, y: resultSpace.globalFrame.minY)
                        self.copyButton.frame = CGRect(x: resultSpace.globalFrame.minX, y: resultSpace.globalFrame.minY, width: resultSpace.frame.width, height: resultSpace.frame.height)
                    }
                    button.transform = .identity
                }
                
                timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { (timer) in
                    if gamesType == "shapes_1Limit" || gamesType == "counting_2Limit" {
                        containerView.isHidden = true
                    } else {
                        resultSpace.image = nil
                    }
                }
                
                if !UserDefaults.standard.bool(forKey: UserDefaultsKeys.paymentKey) {
                    if gamesLimit < 3 {
                        
                        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
                            self.delegate?.handlePanBools(bool1: false, bool2: false, bool3: false, bool4: true)
                            if gamesType == "subtracting_2Limit" || gamesType == "adding_2Limit" || gamesType == "divisionLimit" || gamesType == "multiplication_2Limit" || gamesType == "shapes_3Limit" {
                                button.transform = .identity
                            }
                            self.finalButtons.forEach({$0.removeFromSuperview()})
                            self.finalButtons = []
                            button.alpha = 1
                            self.audio.playWinSound()
                            if gamesType == "shapes_1Limit" || gamesType == "counting_2Limit"{
                                containerView.isHidden = false
                            } else {
                                resultSpace.image = UIImage(named: "questionMark")
                            }
                            gameTypeLimit += 1
                            UserDefaults.standard.setValue(gameTypeLimit, forKey: gamesType)
                            self.delegate?.handlePanBools(bool1: false, bool2: false, bool3: true, bool4: false)
                        }
                    } else {
                        self.delegate?.handlePanBools(bool1: false, bool2: true, bool3: false, bool4: false)
                        view.bringSubviewToFront(firstView)
                        view.bringSubviewToFront(secondView)
                        firstView.isHidden = false
                        secondView.isHidden = false
                        secondView.changeSizeImageWithAnimate()
                        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
                            firstView.isHidden = true
                            secondView.isHidden = true
                        }
                        timer = Timer.scheduledTimer(withTimeInterval: 3.1, repeats: false) { (timer) in
                            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ParentalControllController") as! ParentalControllController
                            vc.fromGame = true
                            self.addChild(vc)
                            self.view.addSubview(vc.view)
                            vc.didMove(toParent: self)
                        }
                    }
                } else {
                    if gamesLimit == 3 {
                        gameTypeLimit = 0
                        UserDefaults.standard.setValue(gameTypeLimit, forKey: gamesType)
                        view.bringSubviewToFront(firstView)
                        view.bringSubviewToFront(secondView)
                        firstView.isHidden = false
                        secondView.isHidden = false
                        secondView.changeSizeImageWithAnimate()
                        
                        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
                            firstView.isHidden = true
                            secondView.isHidden = true
                        }
                        
                        timer = Timer.scheduledTimer(withTimeInterval: 3.1, repeats: false) { (timer) in
                            self.delegate?.handlePanBools(bool1: false, bool2: false, bool3: false, bool4: true)
                            if gamesType == "subtracting_2Limit" || gamesType == "adding_2Limit" || gamesType == "divisionLimit" || gamesType == "multiplication_2Limit" || gamesType == "shapes_3Limit"{
                                button.transform = .identity
                            }
                            self.finalButtons.forEach({$0.removeFromSuperview()})
                            self.finalButtons = []
                            button.alpha = 1
                            self.audio.playWinSound()
                            if gamesType == "shapes_1Limit" || gamesType == "counting_2Limit"{
                                containerView.isHidden = false
                            } else {
                                resultSpace.image = UIImage(named: "questionMark")
                            }
                            self.delegate?.handlePanBools(bool1: false, bool2: false, bool3: true, bool4: false)
                        }
                    } else {
                        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
                            self.delegate?.handlePanBools(bool1: false, bool2: false, bool3: false, bool4: true)
                            if gamesType == "subtracting_2Limit" || gamesType == "adding_2Limit" || gamesType == "divisionLimit" || gamesType == "multiplication_2Limit" || gamesType == "shapes_3Limit" {
                                button.transform = .identity
                            }
                            self.finalButtons.forEach({$0.removeFromSuperview()})
                            gameTypeLimit  += 1
                            UserDefaults.standard.setValue(gameTypeLimit, forKey: gamesType)
                            self.finalButtons = []
                            button.alpha = 1
                            self.audio.playWinSound()
                            if gamesType == "shapes_1Limit" || gamesType == "counting_2Limit" {
                                containerView.isHidden = false
                            } else {
                                resultSpace.image = UIImage(named: "questionMark")
                            }
                            self.delegate?.handlePanBools(bool1: false, bool2: false, bool3: true, bool4: false)
                        }
                    }
                }
            } else {
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseIn) {
                    self.audio.playLoseSound()
                    button.transform = .identity
                } completion: { (bool) in
                    print("FALSE!!!")
                }
            }
        }
    }
    
    private func unlockMath(nearestView: UIView, count: Int) {
        if gameType != .advance {
            for i in resultViewCollection {
                if i.globalFrame.origin == nearestView.globalFrame.origin && i.tag == count {
                    i.subviews.forEach({$0.alpha = 1})
                    baseCount += 1
                }
            }
        } else {
            for i in advanceViewArray {
                if i.globalFrame.origin == nearestView.globalFrame.origin && i.tag == count {
                    i.subviews.forEach({$0.backgroundColor = .red})
                    if let index: Int = advanceViewArray.firstIndex(of: i){
                        let stack = resultViewCollection[index]
                        stack.subviews.forEach({$0.alpha = 1})
                        baseCount += 1
                        return
                    }
                }
            }
        }
    }
    
    private func findNearestImageView(to point: CGPoint) -> UIImageView? {
        var inset: CGFloat = 0
        var nearestView: UIImageView?
        
        inset = 40
        imageViewCollection.forEach { (view) in
            let x = view.globalFrame.origin.x
            let y = view.globalFrame.origin.y
            
            if abs(point.x - x) < inset && abs(point.y - y) < inset {
                nearestView = view
                return
            }
        }
        return nearestView
    }
    
    private func findNearestUiView(to point: CGPoint) -> UIView? {
        let inset: CGFloat = 40
        var nearestView: UIView?
        if gamesType == "Adding_5ViewController"  || gamesType == "Adding_5InterController" || gamesType == "Adding_5AdvancedController" || gamesType == "Subtracting_5Controller" || gamesType == "Subtracting_5InterController" || gamesType == "Subtracting_5AdvancedController" {
            resultViews.forEach { (view) in
                let x = view.globalFrame.minX
                let y = view.globalFrame.minY
                
                if abs(point.x - x) < inset && abs(point.y - y) < inset {
                    nearestView = view
                    return
                }
            }
        } else if gamesType != "Shapes_4ViewController" {
            if gameType != .advance {
                resultViewCollection.forEach { (view) in
                    let x = view.globalFrame.maxX
                    let y = view.globalFrame.minY
                    
                    if abs(point.x - x) < inset && abs(point.y - y) < inset {
                        nearestView = view
                        return
                    }
                }
            } else {
                advanceViewArray.forEach { (view) in
                    let x = view.globalFrame.minX
                    let y = view.globalFrame.minY
                    
                    if abs(point.x - x) < inset && abs(point.y - y) < inset {
                        nearestView = view
                        return
                    }
                }
            }
        }
        return nearestView
    }
    
    func fourOrMoreButtonPanGesture(gesture: UIPanGestureRecognizer, gamesLimit: Int,resultSpace:UIImageView, finalCount: Int, firstView: UIImageView, secondView: UIImageView, gamesType: String,containerView:UIView,imageView:UIImageView,imageCollection: [UIImageView],stackViewCollection: [UIStackView],gamesTypeForLimit : String, viewCollection: [UIView]) {
        self.gamesType = gamesType
        guard let button = gesture.view as? UIButton else {
            return
        }
        if gesture.state == .began {
            delegate?.handlePanBools(bool1: true, bool2: false, bool3: false, bool4: false)
            self.fingerArray.forEach({$0.removeFromSuperview()})
            self.fingerArray.removeAll()
        } else if gesture.state == .changed {
            let translation = gesture.translation(in: self.view)
            button.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
        } else if gesture.state == .ended {
            var gameTypeLimit: Int { get {
                UserDefaults.standard.value(forKey: gamesType) as? Int ?? 0
            } set {
                return UserDefaults.standard.set(newValue, forKey: gamesType)
            }
            }
            let buttonOrigin = button.globalFrame.origin
            let buttonMaxX = button.globalFrame.maxX
            let buttonX = button.globalFrame.origin.x
            
            resultViewCollection = stackViewCollection
            imageViewCollection = imageCollection
            resultViews = viewCollection
            let nearestView = findNearestUiView(to: buttonOrigin) ??  UIView()
            let nerestImageView = findNearestImageView(to: buttonOrigin) ?? UIImageView()
            var buttonTagState: Bool {
                var bool:Bool = false
                if  nearestView == findNearestUiView(to: buttonOrigin) || nerestImageView == findNearestImageView(to: buttonOrigin) {
                    if gamesType == "Adding_3ViewController" || gamesType == "Subtracting_3ViewController" ||  gamesType == "AddingSubMixController"{
                        bool = button.tag == nearestView.tag && nearestView.tag != -1
                    } else if gamesType == "IntermediateFindNumController" || gamesType == "AdvanceFindNumController" {
                        bool = button.tag == nerestImageView.tag && nerestImageView.image == UIImage(named: "nilButton")
                    } else if gamesType == "Adding_5ViewController"  || gamesType == "Adding_5InterController" || gamesType == "Adding_5AdvancedController" || gamesType == "Adding_5AdvancedController" || gamesType == "Subtracting_5Controller" || gamesType == "Subtracting_5InterController" || gamesType == "Subtracting_5AdvancedController"{
                        bool = button.tag == nearestView.tag
                    } else if gamesType == "SortingNumbersController" {
                        bool = button.tag == nerestImageView.tag
                    } else if gamesType == "Shapes_4ViewController" {
                        bool = button.tag == nerestImageView.tag && nerestImageView.tag != -1
                    }
                } else if gamesType == "FindRightNumberController" {
                    bool = button.tag == finalCount
                } else if gamesType == "CompareController" {
                    
                    if compareButtonType == "smallerButton" && viewCollection[0].subviews.count < viewCollection[1].subviews.count {
                        bool = true
                    } else if compareButtonType == "equalButton" && viewCollection[0].subviews.count == viewCollection[1].subviews.count {
                        bool = true
                    } else if compareButtonType == "biggerButton" && viewCollection[0].subviews.count > viewCollection[1].subviews.count{
                        bool = true
                    }
                    
                } else if gamesType == "EvenAndOddViewController" {
                    bool = button.tag % 2 == 1  && buttonMaxX >= viewCollection[0].globalFrame.origin.x && buttonX < viewCollection[0].globalFrame.maxX ? true : button.tag % 2 == 0 && buttonMaxX >= viewCollection[1].globalFrame.origin.x && buttonX < viewCollection[1].globalFrame.maxX ? true : false
                }
                return bool
            }
            
            
            if buttonTagState  {
                if gamesType == "IntermediateFindNumController" {
                    
                    if button.tag == rightAnswers[0] {
                        rightAnswers.remove(at: 0)
                    } else if button.tag == rightAnswers[1] {
                        rightAnswers.remove(at: 1)
                    }
                    
                    delegate?.handlePanBools(bool1: true, bool2: false, bool3: false, bool4: false)
                    rightAnswersCount += 1
                } else if gamesType == "AdvanceFindNumController" {
                    if  nerestImageView == findNearestImageView(to: buttonOrigin), button.tag == nerestImageView.tag {
                        if button.tag == rightAnswers[0] {
                            rightAnswers.remove(at: 0)
                        } else if button.tag == rightAnswers[1] {
                            rightAnswers.remove(at: 1)
                        } else if button.tag == rightAnswers[2] {
                            rightAnswers.remove(at: 2)
                        }
                    }
                    delegate?.handlePanBools(bool1: true, bool2: false, bool3: false, bool4: false)
                    rightAnswersCount += 1
                }
                
                if let item = workItem {
                    item.cancel()
                }
                if gamesType == "Adding_3ViewController" || gamesType == "Subtracting_3ViewController" ||  gamesType == "AddingSubMixController" {
                    unlockMath(nearestView: nearestView, count: nearestView.tag)
                    nearestView.tag = -1
                }
                if gamesType == "Adding_3ViewController" || gamesType == "Subtracting_3ViewController" ||  gamesType == "AddingSubMixController" {
                    setCloneButton(button: button, point: buttonOrigin, btnWidth: 40, btnHeight: 40)
                } else if gamesType == "IntermediateFindNumController" || gamesType == "AdvanceFindNumController"{
                    setCloneButton(button: button, point: buttonOrigin, btnWidth: resultSpace.frame.width, btnHeight: resultSpace.frame.height)
                    x = nerestImageView.globalFrame.origin.x
                    y = nerestImageView.globalFrame.origin.y
                    nerestImageView.alpha = 0
                } else if gamesType == "FindRightNumberController" {
                    setCloneButton(button: button, point: buttonOrigin, btnWidth: resultSpace.frame.width, btnHeight: resultSpace.frame.height)
                    x = imageView.globalFrame.origin.x
                    y = imageView.globalFrame.origin.y
                } else if gamesType == "SortingNumbersController" || gamesType == "Shapes_4ViewController" {
                    setCloneButton(button: button, point: buttonOrigin, btnWidth: button.frame.width, btnHeight: button.frame.height)
                    if gamesType == "Shapes_4ViewController" {
                        nerestImageView.tag = -1
                    }
                    nerestImageView.alpha = 0
                    x = nerestImageView.globalFrame.origin.x
                    y = nerestImageView.globalFrame.origin.y
                    self.baseCount += 1
                    
                } else if gamesType == "CompareController" {
                    setCloneButton(button: button, point: buttonOrigin, btnWidth: button.frame.width, btnHeight: button.frame.height)
                }
                UIView.animate(withDuration: 0.3) {
                    if gamesType == "Adding_3ViewController" || gamesType == "Subtracting_3ViewController" ||  gamesType == "AddingSubMixController" {
                        if self.gameType != .advance {
                            self.copyButton.frame.origin = CGPoint(x: nearestView.globalFrame.maxX + 15, y: nearestView.globalFrame.minY + 2)
                        } else {
                            self.copyButton.frame.origin = CGPoint(x: nearestView.globalFrame.maxX - 40, y: nearestView.globalFrame.minY - 2)
                        }
                    } else if gamesType == "CompareController" {
                        self.copyButton.frame.origin = CGPoint(x: resultSpace.globalFrame.minX, y: resultSpace.globalFrame.minY)
                    } else {
                        self.copyButton.frame.origin = CGPoint(x: self.x, y: self.y)
                        
                    }
                }
                if gamesType == "CompareController" {
                    timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { (timer) in
                        resultSpace.isHidden = true
                    }
                }
                button.transform = .identity
                if gamesType == "Adding_5ViewController"  || gamesType == "Adding_5InterController" || gamesType == "Adding_5AdvancedController" || gamesType == "Subtracting_5Controller" || gamesType == "Subtracting_5InterController" || gamesType == "Subtracting_5AdvancedController"{
                    
                    if  gamesType == "Adding_5ViewController" && finalCount >= 100  {
                        if trueCount != 3 && nearestView.tag != -1 {
                            trueCount += 1
                        }
                        
                    } else if gamesType == "Adding_5ViewController" {
                        if trueCount != 2 && nearestView.tag != -1 {
                            trueCount += 1
                        }
                    }
                    
                    if gamesType == "Adding_5InterController" && finalCount >= 1000  {
                        if trueCount != 4 && nearestView.tag != -1 {
                            trueCount += 1
                        }
                        
                    } else if gamesType == "Adding_5InterController" {
                        if trueCount != 3 && nearestView.tag != -1 {
                            trueCount += 1
                        }
                    }
                    
                    if gamesType == "Adding_5AdvancedController" &&  finalCount >= 10000 {
                        if trueCount != 5 && nearestView.tag != -1 {
                            trueCount += 1
                        }
                    } else if gamesType == "Adding_5AdvancedController" {
                        if trueCount != 4 && nearestView.tag != -1 {
                            trueCount += 1
                        }
                    }
                    
                    if gamesType == "Subtracting_5Controller" {
                        if finalCount >= 10  {
                            if trueCount != 2 && nearestView.tag != -1 {
                                trueCount += 1
                            }
                        } else {
                            if trueCount != 1 && nearestView.tag != -1 {
                                trueCount += 1
                            }
                        }
                    }
                    
                    if gamesType == "Subtracting_5InterController" {
                        if finalCount >= 100 {
                            if trueCount != 3 && nearestView.tag != -1 {
                                trueCount += 1
                            }
                        } else if finalCount < 100 && finalCount >= 10 {
                            if trueCount != 2 && nearestView.tag != -1 {
                                trueCount += 1
                            }
                        } else if finalCount < 10 {
                            if trueCount != 1 && nearestView.tag != -1 {
                                trueCount += 1
                            }
                        }
                    }
                    
                    if gamesType == "Subtracting_5AdvancedController" {
                        if finalCount >= 1000 {
                            if trueCount != 4 && nearestView.tag != -1 {
                                trueCount += 1
                            }
                        } else if finalCount < 1000 && finalCount >= 100 {
                            if trueCount != 3 && nearestView.tag != -1 {
                                trueCount += 1
                            }
                        } else if finalCount < 100 && finalCount >= 10 {
                            if trueCount != 2 && nearestView.tag != -1 {
                                trueCount += 1
                            }
                        } else if finalCount < 10 {
                            if trueCount != 1 && nearestView.tag != -1 {
                                trueCount += 1
                            }
                        }
                    }
                    
                    nearestView.tag = -1
                    
                    let labels = getLabelsInView(view: nearestView)
                    for label in labels {
                        label.isHidden = false
                    }
                    button.alpha = 0
                }
                
                if !UserDefaults.standard.bool(forKey: UserDefaultsKeys.paymentKey) {
                    if  gamesLimit < 3 {
                        if gamesType == "EvenAndOddViewController" {
                            if button.tag % 2 == 1 ? oddCounts + evenCounts == 15 && oddCounts != 8 : button.tag % 2 == 0 ? oddCounts + evenCounts == 15 && evenCounts != 8 : false {
                                if gamesLimit == 2 {
                                    self.delegate?.handlePanBools(bool1: false, bool2: false, bool3: false, bool4: true)
                                    button.transform = .identity
                                    self.audio.playWinSound()
                                    delegate?.handlePanBools(bool1: false, bool2: true, bool3: false, bool4: false)
                                    view.bringSubviewToFront(firstView)
                                    view.bringSubviewToFront(secondView)
                                    firstView.isHidden = false
                                    secondView.isHidden = false
                                    secondView.changeSizeImageWithAnimate()
                                    timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
                                        firstView.isHidden = true
                                        secondView.isHidden = true
                                    }
                                    timer = Timer.scheduledTimer(withTimeInterval: 3.1, repeats: false) { (timer) in
                                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ParentalControllController") as! ParentalControllController
                                        gameTypeLimit = 0
                                        UserDefaults.standard.setValue(gameTypeLimit, forKey: gamesTypeForLimit)
                                        vc.fromGame = true
                                        self.addChild(vc)
                                        self.view.addSubview(vc.view)
                                        vc.didMove(toParent: self)
                                    }
                                } else if button.tag % 2 == 1 ? evenCounts > 7 :  button.tag % 2 == 0 ? oddCounts > 7 : false {
                                    timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
                                        self.oddCounts = 0
                                        self.evenCounts = 0
                                        self.audio.playWinSound()
                                        self.delegate?.handlePanBools(bool1: false, bool2: false, bool3: true, bool4: false)
                                        gameTypeLimit += 1
                                        UserDefaults.standard.setValue(gameTypeLimit, forKey: gamesTypeForLimit)
                                    }
                                }
                            }
                            if button.tag % 2 == 1 ? oddCounts < 8 : button.tag % 2 == 0  ? evenCounts < 8 : false  {
                                self.delegate?.handlePanBools(bool1: false, bool2: false, bool3: false, bool4: true)
                            } else {
                                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseIn) {
                                    button.transform = .identity
                                    self.audio.playLoseSound()
                                } completion: { (bool) in
                                    print("FALSE!!!")
                                }
                            }
                        } else if gamesType == "AddingSubMixController" ?  self.baseCount == 3 : gamesType == "Subtracting_3ViewController" || gamesType == "Adding_3ViewController" ? self.baseCount == 6 : gamesType == "SortingNumbersController" ? self.baseCount == 4 : gamesType == "Shapes_4ViewController" ? self.baseCount == 4 : gamesType == "FindRightNumberController" ? self.baseCount == 0 : gamesType == "IntermediateFindNumController" ? self.rightAnswersCount == 2 : gamesType == "AdvanceFindNumController" ? self.rightAnswersCount == 3 : gamesType == "Adding_5ViewController" ?  finalCount >= 100 && trueCount == 3 || finalCount < 100 && trueCount == 2 : gamesType == "Adding_5InterController" ? finalCount >= 1000 && trueCount == 4 || finalCount < 1000 && trueCount == 3 : gamesType == "Adding_5AdvancedController" ? finalCount >= 10000 && trueCount == 5 || finalCount < 10000 && trueCount == 4 : gamesType == "Subtracting_5Controller" ? finalCount >= 10 && trueCount == 2  || finalCount < 10 && trueCount == 1  : gamesType == "Subtracting_5InterController" ?  finalCount >= 100 && trueCount == 3 || finalCount < 100 && finalCount >= 10 && trueCount == 2 || finalCount < 10 && trueCount == 1 : gamesType == "Subtracting_5AdvancedController" ? finalCount >= 1000 && trueCount == 4 || finalCount < 1000 && finalCount >= 100 && trueCount == 3 || finalCount < 100 && finalCount >= 10 && trueCount == 2 || finalCount < 10 && trueCount == 1 || finalCount >= 1000 && trueCount == 4  : false {
                            gameTypeLimit += 1
                            UserDefaults.standard.setValue(gameTypeLimit, forKey: gamesTypeForLimit)
                            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
                                self.finalButtons.forEach({$0.removeFromSuperview()})
                                self.finalButtons = []
                                self.delegate?.handlePanBools(bool1: false, bool2: false, bool3: false, bool4: true)
                                self.audio.playWinSound()
                                self.delegate?.handlePanBools(bool1: false, bool2: false, bool3: true, bool4: false)
                            }
                        }
                    } else {
                        if gamesType == "IntermediateFindNumController" ? rightAnswersCount == 2 : gamesType == "AdvanceFindNumController" ? rightAnswersCount == 3 : gamesType == "SortingNumbersController" ? self.baseCount == 4 : gamesType == "Shapes_4ViewController" ? self.baseCount == 4 : gamesType == "AddingSubMixController" ?  self.baseCount == 3 : gamesType == "Subtracting_3ViewController" || gamesType == "Adding_3ViewController" ? baseCount == 6 : gamesType == "Adding_5ViewController" ? finalCount >= 100 && trueCount == 3 || finalCount < 100 && trueCount == 2 : gamesType == "Adding_5InterController" ? finalCount >= 1000 && trueCount == 4 || finalCount < 1000 && trueCount == 3 : gamesType == "Adding_5AdvancedController" ? finalCount >= 10000 && trueCount == 5 || finalCount < 10000 && trueCount == 4 : gamesType == "Subtracting_5Controller" ? finalCount >= 10 && trueCount == 2  || finalCount < 10 && trueCount == 1  : gamesType == "Subtracting_5InterController" ?  finalCount >= 100 && trueCount == 3 || finalCount < 100 && finalCount >= 10 && trueCount == 2 || finalCount < 10 && trueCount == 1 : gamesType == "Subtracting_5AdvancedController" ? finalCount >= 1000 && trueCount == 4 || finalCount < 1000 && finalCount >= 100 && trueCount == 3 || finalCount < 100 && finalCount >= 10 && trueCount == 2 || finalCount < 10 && trueCount == 1 || finalCount >= 1000 && trueCount == 4 : rightAnswersCount == 0 {
                            
                            self.delegate?.handlePanBools(bool1: false, bool2: true, bool3: false, bool4: false)
                            view.bringSubviewToFront(firstView)
                            view.bringSubviewToFront(secondView)
                            firstView.isHidden = false
                            secondView.isHidden = false
                            secondView.changeSizeImageWithAnimate()
                            
                            timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
                                firstView.isHidden = true
                                secondView.isHidden = true
                            }
                            timer = Timer.scheduledTimer(withTimeInterval: 3.1, repeats: false) { (timer) in
                                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ParentalControllController") as! ParentalControllController
                                gameTypeLimit = 0
                                UserDefaults.standard.setValue(gameTypeLimit, forKey: gamesTypeForLimit)
                                vc.fromGame = true
                                self.addChild(vc)
                                self.view.addSubview(vc.view)
                                vc.didMove(toParent: self)
                            }
                        }
                    }
                } else {
                    if gamesLimit == 3 {
                        if gamesType == "AddingSubMixController" ?  self.baseCount == 3 : gamesType == "SortingNumbersController" ? self.baseCount == 4 : gamesType == "Shapes_4ViewController" ? self.baseCount == 4 : gamesType == "Subtracting_3ViewController" || gamesType == "Adding_3ViewController" ? self.baseCount == 6 : self.baseCount == 0  {
                            if gamesType == "IntermediateFindNumController" ? rightAnswersCount == 2 : gamesType == "AdvanceFindNumController" ? rightAnswersCount == 3 : gamesType == "Adding_5ViewController" ? finalCount >= 100 && trueCount == 3  || finalCount < 100 && trueCount == 2 : gamesType == "Adding_5InterController" ? finalCount >= 1000 && trueCount == 4 || finalCount < 1000 && trueCount == 3 : gamesType == "Adding_5AdvancedController" ? finalCount >= 10000 && trueCount == 5 || finalCount < 10000 && trueCount == 4 : gamesType == "Subtracting_5Controller" ? finalCount >= 10 && trueCount == 2  || finalCount < 10 && trueCount == 1  : gamesType == "Subtracting_5InterController" ?  finalCount >= 100 && trueCount == 3 || finalCount < 100 && finalCount >= 10 && trueCount == 2 || finalCount < 10 && trueCount == 1 : gamesType == "Subtracting_5AdvancedController" ? finalCount >= 1000 && trueCount == 4 || finalCount < 1000 && finalCount >= 100 && trueCount == 3 || finalCount < 100 && finalCount >= 10 && trueCount == 2 || finalCount < 10 && trueCount == 1 || finalCount >= 1000 && trueCount == 4 : rightAnswersCount == 0 {
                                gameTypeLimit = 0
                                UserDefaults.standard.setValue(gameTypeLimit, forKey: gamesTypeForLimit)
                                view.bringSubviewToFront(firstView)
                                view.bringSubviewToFront(secondView)
                                firstView.isHidden = false
                                secondView.isHidden = false
                                secondView.changeSizeImageWithAnimate()
                                timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
                                    firstView.isHidden = true
                                    secondView.isHidden = true
                                }
                                timer = Timer.scheduledTimer(withTimeInterval: 3.1, repeats: false) { (timer) in
                                    self.finalButtons.forEach({$0.removeFromSuperview()})
                                    self.finalButtons = []
                                    self.audio.playWinSound()
                                    self.delegate?.handlePanBools(bool1: false, bool2: false, bool3: false, bool4: true)
                                    self.delegate?.handlePanBools(bool1: false, bool2: false, bool3: true, bool4: false)
                                    
                                }
                            }
                        }
                    } else {
                        if gamesType == "AddingSubMixController" ?  self.baseCount == 3 : gamesType == "EvenAndOddViewController" ? gamesLimit < 3 : gamesType == "Subtracting_3ViewController" || gamesType == "Adding_3ViewController" ? self.baseCount == 6 : gamesType == "SortingNumbersController" ? self.baseCount == 4 : gamesType == "Shapes_4ViewController" ? self.baseCount == 4 : gamesType == "Adding_5ViewController" ? finalCount >= 100 && trueCount == 3 || finalCount < 100 && trueCount == 2 : gamesType == "Adding_5InterController" ? finalCount >= 1000 && trueCount == 4 || finalCount < 1000 && trueCount == 3 : gamesType == "Adding_5AdvancedController" ? finalCount >= 10000 && trueCount == 5 || finalCount < 10000 && trueCount == 4 : gamesType == "Subtracting_5Controller" ? finalCount >= 10 && trueCount == 2  || finalCount < 10 && trueCount == 1  : gamesType == "Subtracting_5InterController" ?  finalCount >= 100 && trueCount == 3 || finalCount < 100 && finalCount >= 10 && trueCount == 2 || finalCount < 10 && trueCount == 1 : gamesType == "Subtracting_5AdvancedController" ? finalCount >= 1000 && trueCount == 4 || finalCount < 1000 && finalCount >= 100 && trueCount == 3 || finalCount < 100 && finalCount >= 10 && trueCount == 2 || finalCount < 10 && trueCount == 1 || finalCount >= 1000 && trueCount == 4 : self.baseCount == 0 {
                            if gamesType == "EvenAndOddViewController" {
                                if button.tag % 2 == 1 ? oddCounts + evenCounts == 15 && oddCounts != 8 : button.tag % 2 == 0 ? oddCounts + evenCounts == 15 && evenCounts != 8 : false {
                                    if gamesLimit == 2 {
                                        self.delegate?.handlePanBools(bool1: false, bool2: false, bool3: false, bool4: true)
                                        button.transform = .identity
                                        self.audio.playWinSound()
                                        view.bringSubviewToFront(firstView)
                                        view.bringSubviewToFront(secondView)
                                        firstView.isHidden = false
                                        secondView.isHidden = false
                                        secondView.changeSizeImageWithAnimate()
                                        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
                                            firstView.isHidden = true
                                            secondView.isHidden = true
                                            self.oddCounts = 0
                                            self.evenCounts = 0
                                            self.delegate?.handlePanBools(bool1: false, bool2: false, bool3: true, bool4: false)
                                        }
                                        gameTypeLimit = 0
                                        UserDefaults.standard.setValue(gameTypeLimit, forKey: gamesTypeForLimit)
                                    } else if button.tag % 2 == 1 ? evenCounts > 7 :  button.tag % 2 == 0 ? oddCounts > 7 : false {
                                        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
                                            self.oddCounts = 0
                                            self.evenCounts = 0
                                            self.audio.playWinSound()
                                            self.delegate?.handlePanBools(bool1: false, bool2: false, bool3: true, bool4: false)
                                            gameTypeLimit += 1
                                            UserDefaults.standard.setValue(gameTypeLimit, forKey: gamesTypeForLimit)
                                        }
                                    }
                                }
                                if button.tag % 2 == 1 ? oddCounts < 8 : button.tag % 2 == 0  ? evenCounts < 8 : false  {
                                    self.delegate?.handlePanBools(bool1: false, bool2: false, bool3: false, bool4: true)
                                }
                            } else if gamesType == "IntermediateFindNumController" ? rightAnswersCount == 2 : gamesType == "AdvanceFindNumController" ? rightAnswersCount == 3 : rightAnswersCount == 0 {
                                timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
                                    self.finalButtons.forEach({$0.removeFromSuperview()})
                                    gameTypeLimit += 1
                                    UserDefaults.standard.setValue(gameTypeLimit, forKey: gamesTypeForLimit)
                                    self.delegate?.handlePanBools(bool1: false, bool2: false, bool3: false, bool4: true)
                                    self.finalButtons = []
                                    self.audio.playWinSound()
                                    self.delegate?.handlePanBools(bool1: false, bool2: false, bool3: true, bool4: false)
                                }
                            }
                        }
                    }
                }
            } else {
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseIn) {
                    self.audio.playLoseSound()
                    button.transform = .identity
                } completion: { (bool) in
                    print("FALSE!!!")
                }
            }
        }
    }
    
    func setCloneButton(button: UIButton, point: CGPoint, btnWidth: CGFloat, btnHeight: CGFloat) {
        copyButton = UIButton()
        copyButton.tag = button.tag
        copyButton.setImage(button.imageView?.image, for: .normal)
        copyButton.frame = CGRect(x: point.x, y: point.y, width: btnWidth, height: btnHeight)
        view.addSubview(copyButton)
        view.bringSubviewToFront(copyButton)
        finalButtons.append(copyButton)
        button.alpha = 0
    }
    
    func setFinger(button: UIButton, pointX: CGFloat, pointY: CGFloat, btnWidth: CGFloat, btnHeight: CGFloat) {
        fingerImage.image = UIImage(named: "finger")
        fingerImage.frame = CGRect(x: pointX, y: pointY, width: btnWidth, height: btnHeight)
        view.addSubview(fingerImage)
        view.bringSubviewToFront(fingerImage)
        fingerArray.append(fingerImage)
    }
    
    func getLabelsInView(view: UIView) -> [UILabel] {
        var results = [UILabel]()
        for subview in view.subviews as [UIView] {
            if let labelView = subview as? UILabel {
                results += [labelView]
            } else {
                results += getLabelsInView(view: subview)
            }
        }
        return results
    }
    
    func lose(button: UIButton) {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseIn) {
            self.audio.playLoseSound()
            button.transform = .identity
        }
    }
    
    func setCloneButton(button: UIButton, point: CGPoint, btnWidth: CGFloat, btnHeight: CGFloat, imageView: UIImageView) {
        copyButton = UIButton()
        copyButton.tag = button.tag
        copyButton.setImage(button.imageView?.image, for: .normal)
        copyButton.frame = CGRect(x: point.x, y: point.y, width: btnWidth, height: btnHeight)
        imageView.tag = copyButton.tag
        imageView.image = copyButton.currentImage
        finalButtons.append(copyButton)
        button.alpha = 0
        button.isEnabled = false
    }
    
    func setBallLeadingTrailingConstraints(scaleImageView: UIImageView, leftBallView: UIView, rightBallView: UIView) {
        // original scale image height
        let imageWidth: Double = 430
        //original distance from leading/trailing from image to middle of wing
        let middleOfWing = 65.8
        // coefficient for calculating distance depending on new scale image sizes
        let coefficient = middleOfWing / imageWidth
        let ballPlacePoint: Double = scaleImageView.frame.width *  coefficient
        let halfBallSize: Double = Double(leftBallView.frame.width) / 2
        
        let leftBallConstraint = NSLayoutConstraint(item: leftBallView, attribute: .leading, relatedBy: .equal, toItem: scaleImageView, attribute: .leading, multiplier: 1, constant: CGFloat(ballPlacePoint - halfBallSize))
        let rightBallConstraint = NSLayoutConstraint(item: rightBallView, attribute: .trailing, relatedBy: .equal, toItem: scaleImageView, attribute: .trailing, multiplier: 1, constant: CGFloat(-(ballPlacePoint - halfBallSize)))
        
        leftBallConstraint.isActive = true
        rightBallConstraint.isActive = true
    }
    
    func showEndPopUpVC(delegate: EndPopUpViewControllerDelegate? = nil, icon iconName: String, refresh: Bool = false) {
        guard let vc = EndPopUpViewController.initializeWithStoryboard() else { return }
        vc.modalPresentationStyle = .overCurrentContext
        vc.setImage(iconName)
        vc.setRefresh(refresh)
        vc.delegate = delegate
        self.present(vc, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                vc.dismiss(animated: true) {
                    if subscribed {
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        self.showParentalController()
                    }
                }
            }
        }
    }
    
    func presentEndPopUpVC(delegate: EndPopUpViewControllerDelegate? = nil, icon iconName: String, refresh: Bool = false) {
        guard let vc = EndPopUpViewController.initializeWithStoryboard() else { return }
        vc.modalPresentationStyle = .overCurrentContext
        vc.setImage(iconName)
        vc.setRefresh(refresh)
        vc.delegate = delegate
        self.present(vc, animated: true)
    }
    
    func showParentalController(fromGame: Bool = true) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ParentalControllController") as! ParentalControllController
        vc.fromGame = true
        self.addChild(vc)
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
    func showGameStartVC(_ delegate: GameStartDelegate) {
        guard let vc = GameStartViewController.initializeWithStoryboard() else { return }
        vc.delegate = delegate
        self.addChild(vc)
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
    //    func showParentalForLearning() {
    //        Timer.scheduledTimer(withTimeInterval: 3.1, repeats: false) { (timer) in
    //            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ParentalControllController") as! ParentalControllController
    //
    //            UserDefaults.standard.setValue(true, forKey: UserDefaultsKeys.isLockLearning)
    //            self.addChild(vc)
    //            self.view.addSubview(vc.view)
    //            vc.didMove(toParent: self)
    //        }
    //    }
    
}
