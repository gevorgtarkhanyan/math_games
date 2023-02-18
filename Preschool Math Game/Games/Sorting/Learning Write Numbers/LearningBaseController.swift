//
//  LearningBaseController.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 17.08.21.
//

import UIKit

class LearningBaseController: BaseViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var buttonsCollection: [UIButton]!
    @IBOutlet weak var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerRightConstraint: NSLayoutConstraint!

    var game: Game!
    private var date = Date()
    private var viewIsFirstLoaded = true
    //    private var didAppear = false

    static func initWithStoryboard() -> LearningBaseController? {
        let storyboard = UIStoryboard(name: "SortingGames", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: LearningBaseController.name) as? LearningBaseController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        GamesLimit.learningPrizCount = UserDefaults.standard.value(forKey: UserDefaultsKeys.learningPrizCount) as? Int ?? 0
        addObservers()
        setBorder()
        buttonsCollection.forEach({$0.layer.cornerRadius = 10})
        TimesCheking.shared.dateNow = date
        TimesCheking.shared.game = .sortingLearning
        TimesCheking.shared.checking()
        checkBlockGame()

        GamesLimit.learning_1Limit = UserDefaults.standard.value(forKey: UserDefaultsKeys.learning_1Limit) as? Int ?? 0
        GamesLimit.learning_2Limit = UserDefaults.standard.value(forKey: UserDefaultsKeys.learning_2Limit) as? Int ?? 0
        GamesLimit.learning_3Limit = UserDefaults.standard.value(forKey: UserDefaultsKeys.learning_3Limit) as? Int ?? 0
        GamesLimit.learning_4Limit = UserDefaults.standard.value(forKey: UserDefaultsKeys.learning_4Limit) as? Int ?? 0
        GamesLimit.learning_5Limit = UserDefaults.standard.value(forKey: UserDefaultsKeys.learning_5Limit) as? Int ?? 0
        GamesLimit.learning_6Limit = UserDefaults.standard.value(forKey: UserDefaultsKeys.learning_6Limit) as? Int ?? 0
        GamesLimit.learning_7Limit = UserDefaults.standard.value(forKey: UserDefaultsKeys.learning_7Limit) as? Int ?? 0
        GamesLimit.learning_8Limit = UserDefaults.standard.value(forKey: UserDefaultsKeys.learning_8Limit) as? Int ?? 0
        GamesLimit.learning_9Limit = UserDefaults.standard.value(forKey: UserDefaultsKeys.learning_9Limit) as? Int ?? 0
        GamesLimit.learning_10Limit = UserDefaults.standard.value(forKey: UserDefaultsKeys.learning_10Limit) as? Int ?? 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        guard !didAppear else { return }
        //        didAppear = true
        checkBlockGame()

        if GamesLimit.learningLimitEnded && !viewIsFirstLoaded {
            game.isLocked = true
            DispatchQueue.main.async {
                self.showEndPopUpVC(icon: "priz_img_8")
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //        didAppear = false
        viewIsFirstLoaded = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIScreen.main.bounds.height >= 1000 {
            containerTopConstraint.constant = 230
            containerBottomConstraint.constant = 200
            containerLeftConstraint.constant = 250
            containerRightConstraint.constant = 250
        }
    }
    
    deinit { NotificationCenter.default.removeObserver(self) }

    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(blockLearning_1), name: .blockLearning_1, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(unblockLearning_1), name: .unblockLearning_1, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(blockLearning_2), name: .blockLearning_2, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(unblockLearning_2), name: .unblockLearning_2, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(blockLearning_3), name: .blockLearning_3, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(unblockLearning_3), name: .unblockLearning_3, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(blockLearning_4), name: .blockLearning_4, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(unblockLearning_4), name: .unblockLearning_4, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(blockLearning_5), name: .blockLearning_5, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(unblockLearning_5), name: .unblockLearning_5, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(blockLearning_6), name: .blockLearning_6, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(unblockLearning_6), name: .unblockLearning_6, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(blockLearning_7), name: .blockLearning_7, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(unblockLearning_7), name: .unblockLearning_7, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(blockLearning_8), name: .blockLearning_8, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(unblockLearning_8), name: .unblockLearning_8, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(blockLearning_9), name: .blockLearning_9, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(unblockLearning_9), name: .unblockLearning_9, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(blockLearning_10), name: .blockLearning_10, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(unblockLearning_10), name: .unblockLearning_10, object: nil)
    }

    @objc func blockLearning_1() {
        UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.learning_1Date)
        buttonsCollection[0].isEnabled = false
    }
    @objc func unblockLearning_1() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.learning_1Limit)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.learning_1Date)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isLockLearning_1)
        buttonsCollection[0].isEnabled = true
    }

    @objc func blockLearning_2() {
        UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.learning_2Date)
        buttonsCollection[1].isEnabled = false
    }
    @objc func unblockLearning_2() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.learning_2Limit)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.learning_2Date)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isLockLearning_2)
        buttonsCollection[1].isEnabled = true
    }

    @objc func blockLearning_3() {
        UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.learning_3Date)
        buttonsCollection[2].isEnabled = false
    }
    @objc func unblockLearning_3() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.learning_3Limit)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.learning_3Date)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isLockLearning_3)
        buttonsCollection[2].isEnabled = true
    }

    @objc func blockLearning_4() {
        UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.learning_4Date)
        buttonsCollection[3].isEnabled = false
    }
    @objc func unblockLearning_4() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.learning_4Limit)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.learning_4Date)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isLockLearning_4)
        buttonsCollection[3].isEnabled = true
    }

    @objc func blockLearning_5() {
        UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.learning_5Date)
        buttonsCollection[4].isEnabled = false
    }
    @objc func unblockLearning_5() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.learning_5Limit)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.learning_5Date)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isLockLearning_5)
        buttonsCollection[4].isEnabled = true
    }

    @objc func blockLearning_6() {
        UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.learning_6Date)
        buttonsCollection[5].isEnabled = false
    }
    @objc func unblockLearning_6() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.learning_6Limit)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.learning_6Date)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isLockLearning_6)
        buttonsCollection[5].isEnabled = true
    }

    @objc func blockLearning_7() {
        UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.learning_7Date)
        buttonsCollection[6].isEnabled = false
    }
    @objc func unblockLearning_7() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.learning_7Limit)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.learning_7Date)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isLockLearning_7)
        buttonsCollection[6].isEnabled = true
    }

    @objc func blockLearning_8() {
        UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.learning_8Date)
        buttonsCollection[7].isEnabled = false
    }
    @objc func unblockLearning_8() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.learning_8Limit)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.learning_8Date)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isLockLearning_8)
        buttonsCollection[7].isEnabled = true
    }

    @objc func blockLearning_9() {
        UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.learning_9Date)
        buttonsCollection[8].isEnabled = false
    }
    @objc func unblockLearning_9() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.learning_9Limit)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.learning_9Date)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isLockLearning_9)
        buttonsCollection[8].isEnabled = true
    }

    @objc func blockLearning_10() {
        UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.learning_10Date)
        buttonsCollection[9].isEnabled = false
    }
    @objc func unblockLearning_10() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.learning_10Limit)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.learning_10Date)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isLockLearning_10)
        buttonsCollection[9].isEnabled = true
    }


    private func checkBlockGame() {
        if !UserDefaults.standard.bool(forKey: UserDefaultsKeys.paymentKey) {

            if UserDefaults.standard.bool(forKey: UserDefaultsKeys.isLockLearning_1) {
                buttonsCollection[0].backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                buttonsCollection[0].isEnabled = false
            } else {
                buttonsCollection[0].backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.4509803922, blue: 0, alpha: 1)
                buttonsCollection[0].isEnabled = true
            }

            if UserDefaults.standard.bool(forKey: UserDefaultsKeys.isLockLearning_2) {
                buttonsCollection[1].backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                buttonsCollection[1].isEnabled = false
            } else {
                buttonsCollection[1].backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.4509803922, blue: 0, alpha: 1)
                buttonsCollection[1].isEnabled = true
            }

            if UserDefaults.standard.bool(forKey: UserDefaultsKeys.isLockLearning_3) {
                buttonsCollection[2].backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                buttonsCollection[2].isEnabled = false
            } else {
                buttonsCollection[2].backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.4509803922, blue: 0, alpha: 1)
                buttonsCollection[2].isEnabled = true
            }

            if UserDefaults.standard.bool(forKey: UserDefaultsKeys.isLockLearning_4) {
                buttonsCollection[3].backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                buttonsCollection[3].isEnabled = false
            } else {
                buttonsCollection[3].backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.4509803922, blue: 0, alpha: 1)
                buttonsCollection[3].isEnabled = true
            }

            if UserDefaults.standard.bool(forKey: UserDefaultsKeys.isLockLearning_5) {
                buttonsCollection[4].backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                buttonsCollection[4].isEnabled = false
            } else {
                buttonsCollection[4].backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.4509803922, blue: 0, alpha: 1)
                buttonsCollection[4].isEnabled = true
            }

            if UserDefaults.standard.bool(forKey: UserDefaultsKeys.isLockLearning_6) {
                buttonsCollection[5].backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                buttonsCollection[5].isEnabled = false
            } else {
                buttonsCollection[5].backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.4509803922, blue: 0, alpha: 1)
                buttonsCollection[5].isEnabled = true
            }

            if UserDefaults.standard.bool(forKey: UserDefaultsKeys.isLockLearning_7) {
                buttonsCollection[6].backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                buttonsCollection[6].isEnabled = false
            } else {
                buttonsCollection[6].backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.4509803922, blue: 0, alpha: 1)
                buttonsCollection[6].isEnabled = true
            }

            if UserDefaults.standard.bool(forKey: UserDefaultsKeys.isLockLearning_8) {
                buttonsCollection[7].backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                buttonsCollection[7].isEnabled = false
            } else {
                buttonsCollection[7].backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.4509803922, blue: 0, alpha: 1)
                buttonsCollection[7].isEnabled = true
            }

            if UserDefaults.standard.bool(forKey: UserDefaultsKeys.isLockLearning_9) {
                buttonsCollection[8].backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                buttonsCollection[8].isEnabled = false
            } else {
                buttonsCollection[8].backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.4509803922, blue: 0, alpha: 1)
                buttonsCollection[8].isEnabled = true
            }

            if UserDefaults.standard.bool(forKey: UserDefaultsKeys.isLockLearning_10) {
                buttonsCollection[9].backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                buttonsCollection[9].isEnabled = false
            } else {
                buttonsCollection[9].backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.4509803922, blue: 0, alpha: 1)
                buttonsCollection[9].isEnabled = true
            }
        } else {
            buttonsCollection.forEach({$0.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.4509803922, blue: 0, alpha: 1)})
            buttonsCollection[0].isEnabled = true
            buttonsCollection[1].isEnabled = true
            buttonsCollection[2].isEnabled = true
            buttonsCollection[3].isEnabled = true
            buttonsCollection[4].isEnabled = true
            buttonsCollection[5].isEnabled = true
            buttonsCollection[6].isEnabled = true
            buttonsCollection[7].isEnabled = true
            buttonsCollection[8].isEnabled = true
            buttonsCollection[9].isEnabled = true
        }
    }

    private func setBorder() {
        containerView.layer.cornerRadius = 15
        containerView.layer.borderWidth = 5
        containerView.layer.borderColor = #colorLiteral(red: 0.8509803922, green: 0.2431372549, blue: 0.3098039216, alpha: 1)
    }

    @IBAction func one_Action(_ sender: UIButton) {
        let vc = UIStoryboard(name: "SortingGames", bundle: nil).instantiateViewController(withIdentifier: "LearningOneNumberController") as! LearningOneNumberController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func two_Action(_ sender: UIButton) {
        let vc = UIStoryboard(name: "SortingGames", bundle: nil).instantiateViewController(withIdentifier: "LearningSecondNumberController") as! LearningSecondNumberController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func three_Action(_ sender: UIButton) {
        let vc = UIStoryboard(name: "SortingGames", bundle: nil).instantiateViewController(withIdentifier: "LearningThirdNumberController") as! LearningThirdNumberController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func four_Action(_ sender: UIButton) {
        let vc = UIStoryboard(name: "SortingGames", bundle: nil).instantiateViewController(withIdentifier: "LearningFourthNumberController") as! LearningFourthNumberController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func five_Action(_ sender: UIButton) {
        let vc = UIStoryboard(name: "SortingGames", bundle: nil).instantiateViewController(withIdentifier: "LearningFivethNumberController") as! LearningFivethNumberController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func six_Action(_ sender: UIButton) {
        let vc = UIStoryboard(name: "SortingGames", bundle: nil).instantiateViewController(withIdentifier: "LearningSixthNumberController") as! LearningSixthNumberController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func seven_Action(_ sender: UIButton) {
        let vc = UIStoryboard(name: "SortingGames", bundle: nil).instantiateViewController(withIdentifier: "LearningSeventhNumberController") as! LearningSeventhNumberController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func eight_Action(_ sender: UIButton) {
        let vc = UIStoryboard(name: "SortingGames", bundle: nil).instantiateViewController(withIdentifier: "LearningEightNumberController") as! LearningEightNumberController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func nine_Action(_ sender: UIButton) {
        let vc = UIStoryboard(name: "SortingGames", bundle: nil).instantiateViewController(withIdentifier: "LearningNinethNumberController") as! LearningNinethNumberController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func ten_Action(_ sender: UIButton) {
        let vc = UIStoryboard(name: "SortingGames", bundle: nil).instantiateViewController(withIdentifier: "LearningTenthNumberController") as! LearningTenthNumberController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
