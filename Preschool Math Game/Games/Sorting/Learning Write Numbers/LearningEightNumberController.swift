//
//  LearningEightNumberController.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 18.08.21.
//

import UIKit

class LearningEightNumberController: BaseViewController {

    //MARK: - Outlets
    @IBOutlet weak var drop_pink: UIImageView!
    @IBOutlet weak var firstPoint: UIView!
    @IBOutlet weak var seconPoint: UIView!
    @IBOutlet weak var numberImage: UIImageView!
    @IBOutlet weak var prizContainerView: UIImageView!
    @IBOutlet weak var prizImageView: UIImageView!
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
                
        drop_pink.isUserInteractionEnabled = true
        drop_pink.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(firstPan)))
    }
    
    //MARK: - Functions
    private func findNearestView(to point: CGPoint) -> UIView? {
        let inset: CGFloat = 50
        var nearestView: UIView?
        
        let x = firstPoint.globalFrame.maxX
        let y = firstPoint.globalFrame.minY
        
        if abs(point.x - x) < inset && abs(point.y - y) < inset {
            nearestView = firstPoint
        }
        
        return nearestView
    }
    
    private func setCloneImage(image: UIImageView, point: CGPoint, btnWidth: CGFloat, btnHeight: CGFloat) {
        cloneImage = UIImageView()
        cloneImage.image = UIImage(named: "drop_pink")
        cloneImage.contentMode = .scaleAspectFit
        cloneImage.frame = CGRect(x: point.x, y: point.y, width: btnWidth, height: btnHeight)
        view.addSubview(cloneImage)
        view.bringSubviewToFront(cloneImage)
        finalImage.append(cloneImage)
        image.alpha = 0
        cloneImage.isUserInteractionEnabled = true
        
        cloneImage.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(secondPan)))
    }
    
    @objc func secondPan(gesture: UIPanGestureRecognizer) {
        
        guard let button = gesture.view as? UIImageView else { return }
        
        if gesture.state == .began {
            
        } else if gesture.state == .changed {
            let translation = gesture.translation(in: self.view)
            button.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
            
        } else if gesture.state == .ended {
            let buttonOrigin = button.globalFrame.origin

            if findNearestView(to: buttonOrigin) != nil {
                if index == 1 {
                    self.numberImage.image = UIImage(named: "eight_third")
                    self.finalImage.forEach({$0.isHidden = true})
                    
                    if !UserDefaults.standard.bool(forKey: UserDefaultsKeys.paymentKey) {
                        if GamesLimit.learning_1Limit == 1 && GamesLimit.learning_2Limit == 1 && GamesLimit.learning_3Limit == 1 && GamesLimit.learning_4Limit == 1 && GamesLimit.learning_5Limit == 1 && GamesLimit.learning_6Limit == 1 && GamesLimit.learning_7Limit == 1 && GamesLimit.learning_8Limit == 0 && GamesLimit.learning_9Limit == 1 && GamesLimit.learning_10Limit == 1 {
                            
//                            GamesLimit.learningPrizCount += 1
//                            UserDefaults.standard.setValue(GamesLimit.learningPrizCount, forKey: UserDefaultsKeys.learningPrizCount)
                            
                            GamesLimit.learning_1Limit = 0
                            GamesLimit.learning_2Limit = 0
                            GamesLimit.learning_3Limit = 0
                            GamesLimit.learning_4Limit = 0
                            GamesLimit.learning_5Limit = 0
                            GamesLimit.learning_6Limit = 0
                            GamesLimit.learning_7Limit = 0
                            GamesLimit.learning_8Limit = 0
                            GamesLimit.learning_9Limit = 0
                            GamesLimit.learning_10Limit = 0
                            
                            UserDefaults.standard.setValue(GamesLimit.learning_1Limit, forKey: UserDefaultsKeys.learning_1Limit)
                            UserDefaults.standard.setValue(GamesLimit.learning_2Limit, forKey: UserDefaultsKeys.learning_2Limit)
                            UserDefaults.standard.setValue(GamesLimit.learning_3Limit, forKey: UserDefaultsKeys.learning_3Limit)
                            UserDefaults.standard.setValue(GamesLimit.learning_4Limit, forKey: UserDefaultsKeys.learning_4Limit)
                            UserDefaults.standard.setValue(GamesLimit.learning_5Limit, forKey: UserDefaultsKeys.learning_5Limit)
                            UserDefaults.standard.setValue(GamesLimit.learning_6Limit, forKey: UserDefaultsKeys.learning_6Limit)
                            UserDefaults.standard.setValue(GamesLimit.learning_7Limit, forKey: UserDefaultsKeys.learning_7Limit)
                            UserDefaults.standard.setValue(GamesLimit.learning_8Limit, forKey: UserDefaultsKeys.learning_8Limit)
                            UserDefaults.standard.setValue(GamesLimit.learning_9Limit, forKey: UserDefaultsKeys.learning_9Limit)
                            UserDefaults.standard.setValue(GamesLimit.learning_10Limit, forKey: UserDefaultsKeys.learning_10Limit)
                            
//                            view.bringSubviewToFront(self.prizContainerView)
//                            view.bringSubviewToFront(self.prizImageView)
//                            self.prizContainerView.isHidden = false
//                            self.prizImageView.isHidden = false
//                            self.prizImageView.changeSizeImageWithAnimate()
//
//                            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
//                                self.prizContainerView.isHidden = true
//                                self.prizImageView.isHidden = true
//                            }
//
//                            Timer.scheduledTimer(withTimeInterval: 3.1, repeats: false) { (timer) in
//                                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SubscriptionViewController") as! SubscriptionViewController
//                                vc.fromLimitedGame = true
//                                vc.fromLearningGame = true
//                                self.navigationController?.pushViewController(vc, animated: false)
//                                NotificationCenter.default.post(name: .blockLearning, object: nil)
//                                UserDefaults.standard.setValue(true, forKey: UserDefaultsKeys.isLockLearning)
//                            }
                            GamesLimit.learningLimitEnded = true
                            NotificationCenter.default.post(name: .blockLearning_8, object: nil)
                            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isLockLearning_8)

                            timer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false) { timer in
                                self.navigationController?.popViewController(animated: true)
                            }
                        } else {
                            GamesLimit.learning_8Limit = 1
                            UserDefaults.standard.setValue(GamesLimit.learning_8Limit, forKey: UserDefaultsKeys.learning_8Limit)
                            NotificationCenter.default.post(name: .blockLearning_8, object: nil)
                            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isLockLearning_8)

                            timer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false) { timer in
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    } else {
                        if GamesLimit.learning_1Limit == 1 && GamesLimit.learning_2Limit == 1 && GamesLimit.learning_3Limit == 1 && GamesLimit.learning_4Limit == 1 && GamesLimit.learning_5Limit == 1 && GamesLimit.learning_6Limit == 1 && GamesLimit.learning_7Limit == 1 && GamesLimit.learning_8Limit == 0 && GamesLimit.learning_9Limit == 1 && GamesLimit.learning_10Limit == 1 {
                            
//                            GamesLimit.learningPrizCount += 1
//                            UserDefaults.standard.setValue(GamesLimit.learningPrizCount, forKey: UserDefaultsKeys.learningPrizCount)
                            
                            GamesLimit.learning_1Limit = 0
                            GamesLimit.learning_2Limit = 0
                            GamesLimit.learning_3Limit = 0
                            GamesLimit.learning_4Limit = 0
                            GamesLimit.learning_5Limit = 0
                            GamesLimit.learning_6Limit = 0
                            GamesLimit.learning_7Limit = 0
                            GamesLimit.learning_8Limit = 0
                            GamesLimit.learning_9Limit = 0
                            GamesLimit.learning_10Limit = 0
                            
                            UserDefaults.standard.setValue(GamesLimit.learning_1Limit, forKey: UserDefaultsKeys.learning_1Limit)
                            UserDefaults.standard.setValue(GamesLimit.learning_2Limit, forKey: UserDefaultsKeys.learning_2Limit)
                            UserDefaults.standard.setValue(GamesLimit.learning_3Limit, forKey: UserDefaultsKeys.learning_3Limit)
                            UserDefaults.standard.setValue(GamesLimit.learning_4Limit, forKey: UserDefaultsKeys.learning_4Limit)
                            UserDefaults.standard.setValue(GamesLimit.learning_5Limit, forKey: UserDefaultsKeys.learning_5Limit)
                            UserDefaults.standard.setValue(GamesLimit.learning_6Limit, forKey: UserDefaultsKeys.learning_6Limit)
                            UserDefaults.standard.setValue(GamesLimit.learning_7Limit, forKey: UserDefaultsKeys.learning_7Limit)
                            UserDefaults.standard.setValue(GamesLimit.learning_8Limit, forKey: UserDefaultsKeys.learning_8Limit)
                            UserDefaults.standard.setValue(GamesLimit.learning_9Limit, forKey: UserDefaultsKeys.learning_9Limit)
                            UserDefaults.standard.setValue(GamesLimit.learning_10Limit, forKey: UserDefaultsKeys.learning_10Limit)
                            
                            view.bringSubviewToFront(self.prizContainerView)
                            view.bringSubviewToFront(self.prizImageView)
                            self.prizContainerView.isHidden = false
                            self.prizImageView.isHidden = false
                            self.prizImageView.changeSizeImageWithAnimate()
                            
                            timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
                                self.prizContainerView.isHidden = true
                                self.prizImageView.isHidden = true
                            }
                            
                            timer = Timer.scheduledTimer(withTimeInterval: 3.1, repeats: false) { (timer) in
                                self.navigationController?.popViewController(animated: true)
                            }
                        } else {
                            GamesLimit.learning_8Limit = 1
                            UserDefaults.standard.setValue(GamesLimit.learning_8Limit, forKey: UserDefaultsKeys.learning_8Limit)
                            timer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false) { timer in
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                }
            } else {
                button.transform = .identity
            }
        }
    }
    
    @objc func firstPan(gesture: UIPanGestureRecognizer) {
        
        guard let button = gesture.view as? UIImageView else { return }
        
        if gesture.state == .began {
            
        } else if gesture.state == .changed {
            let translation = gesture.translation(in: self.view)
            button.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
            
        } else if gesture.state == .ended {
            
            let buttonOrigin = button.globalFrame.origin
            
            if findNearestView(to: buttonOrigin) != nil {
                                
                setCloneImage(image: button, point: buttonOrigin, btnWidth: button.frame.width, btnHeight: button.frame.height)
                
                let x = seconPoint.globalFrame.origin.x - 5
                let y = seconPoint.globalFrame.origin.y - 10
                
                UIView.animate(withDuration: 0.3) {
                    self.cloneImage.frame.origin = CGPoint(x: x, y: y)
                    
                    if self.index == 0 {
                        self.numberImage.image = UIImage(named: "eight_second")
                        self.index = 1
                    }
                }
            } else {
                button.transform = .identity
            }
        }
    }
    
    //MARK: - Actions
    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
