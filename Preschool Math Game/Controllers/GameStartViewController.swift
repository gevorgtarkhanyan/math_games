//
//  GameStartViewController.swift
//  Preschool Math Game
//
//  Created by Armen Gasparyan on 07.03.22.
//

import UIKit

protocol GameStartDelegate: BackButtonDelegate {
    func start()
    func setNavigationIndexes(_ indexes: [Int])
}

extension GameStartViewController {
    static func initializeWithStoryboard() -> GameStartViewController? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: GameStartViewController.name) as? GameStartViewController
    }
}

class GameStartViewController: UIViewController {

    @IBOutlet weak var backButton: BackButton!
    @IBOutlet weak var numberImageView: UIImageView!
    
    weak var delegate: GameStartDelegate?
    
    private var timer: Timer?
    private var second = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backButton.delegate = self
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }

    @objc func timerAction() {
        second -= 1
        numberImageView.image = UIImage(named: "timer\(second)")
        if second == 0 {
            timer?.invalidate()
            UIView.animate(withDuration: 1) {
                self.view.removeFromSuperview()
            } completion: { (complete) in
                self.removeFromParent()
                self.delegate?.start()
            }
        }
    }
}

extension GameStartViewController: BackButtonDelegate {
    func backTapped() {
        delegate?.backTapped()
    }
}

