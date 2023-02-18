//
//  SettingsViewController.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 5/25/21.
//

import UIKit

class ParentalControllController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var baseContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var colorName: UILabel!
    @IBOutlet var colorButtons: [UIButton]!
    
    //MARK: - Properties
    private let colorArray = ["o", "g r", "y e l", "p u r p", "r e d d d", "b l u e e e", "p i n k k k k"]
    private var wordCount = 0
    public var fromSettings = false
    public var fromGame = false

    override var prefersHomeIndicatorAutoHidden: Bool { return false }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return UIRectEdge.bottom
    }
    
    static func initWithStoryboard() -> ParentalControllController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: ParentalControllController.name) as? ParentalControllController
    }
        
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let colors = colorArray.shuffled()
        
        colorName.text = colors[0]
        
        setupButtonsImage()
        setColorName()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        addAnimation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(notification), name: .closeParentalControl, object: nil)
        
        addTapGesture()
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        NotificationCenter.default.removeObserver(self)
//    }
    
    //MARK: - Functions
    @objc func tap() {
        removeAnimation()
    }
    
    @objc func notification() {
        removeAnimation()
    }
                    
    deinit {
        print("ParentalControllController Deinit")
        NotificationCenter.default.removeObserver(self)
    }
    
    private func addTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        baseContainerView.addGestureRecognizer(tapGestureRecognizer)
        view.isUserInteractionEnabled = true
    }
    
    private func addAnimation() {
        self.containerView.transform = CGAffineTransform(translationX: 0, y: self.containerView.frame.height)
        UIView.animate(withDuration: 0.5) {
            self.containerView.transform = .identity
        }
    }
    
    private func removeAnimation() {
        NotificationCenter.default.removeObserver(self)
        UIView.animate(withDuration: 0.2) {
            self.containerView.transform = CGAffineTransform(translationX: 0, y: self.containerView.frame.height + 300)
        } completion: { (complete) in
            self.view.removeFromSuperview()
        }
    }
    
    private func setupButtonsImage() {
        let max = 7
        let components = colorName.text!.components(separatedBy: .whitespacesAndNewlines)
        wordCount = components.count
        
        var indexes = [wordCount]
        for _ in 0..<3 {
            let random: Int = Random.getRandomIndex(in: 1..<max, ignoredIndexes: indexes)
            indexes.append(random)
        }
        
        indexes = indexes.shuffled()
        
        for i in 0..<indexes.count {
            let number: Int = indexes[i]
            let imageName: String = "btnn_\(number)"
            let image: UIImage = UIImage(named: imageName)!
            let button = colorButtons[i]
            button.setImage(image, for: .normal)
            button.tag = number
        }
    }
    
    private func setColorName() {
        if wordCount == 1 {
            colorName.text = "ORANGE"
        } else if wordCount == 2 {
            colorName.text = "GREEN"
        } else if wordCount == 3 {
            colorName.text = "YELLOW"
        } else if wordCount == 4 {
            colorName.text = "PURPLE"
        } else if wordCount == 5 {
            colorName.text = "RED"
        } else if wordCount == 6 {
            colorName.text = "BLUE"
        } else if wordCount == 7 {
            colorName.text = "PINK"
        }
    }
    
    //MARK: - Actions
    @IBAction func buttonsAction(_ sender: UIButton) {
        if sender.tag == wordCount {
            if fromSettings {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
                
                navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SubscriptionViewController") as! SubscriptionViewController
                if fromGame {
                    vc.fromLimitedGame = true
                }
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        } else {
            removeAnimation()
        }
    }

    @IBAction func closeButtonAction(_ sender: UIButton) {
        if fromGame {
            removeAnimation()
            navigationController?.popViewController(animated: true)
        } else {
            removeAnimation()
        }
        self.removeFromParent()
    }
}

