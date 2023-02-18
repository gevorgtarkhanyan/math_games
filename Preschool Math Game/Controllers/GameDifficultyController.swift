//
//  GameDifficultyController.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 6/11/21.
//

import UIKit

protocol GameDifficultyDelegate: AnyObject {
    func buttonTapped(index: Int)
    func beginnerButtonTapped(index: Int, game: Game)
    func intermediateButtonTapped(index: Int, game: Game)
    func advanceButtonTapped(index: Int, game: Game)
    func getSwitchValue(bool: Bool)
}

class GameDifficultyController: UIViewController {
    
    //MARK: - Outlets

    @IBOutlet weak var gameSwitch: MySwitch!
    @IBOutlet weak var baseContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var difficultStackView: UIStackView!
    @IBOutlet weak var stepStackView: UIStackView!

    //MARK: - Properties

    var game: Game!
    var fromController: FromController!
    private var hasSwitch = false
    private var stepByStep = false
    
    weak var delegate: GameDifficultyDelegate?
    
    override var prefersHomeIndicatorAutoHidden: Bool { return false }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge { return UIRectEdge.bottom }
    
    static func initWithStoryboard() -> GameDifficultyController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: GameDifficultyController.name) as? GameDifficultyController
    }
    
    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    deinit { NotificationCenter.default.removeObserver(self) }

    //MARK: - Setup

    private func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(notify), name: .closeDifficultControl, object: nil)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        addTapGesture()
        addAnimation()
        uiSetup()
    }

    private func uiSetup() {
        gameSwitch.isHidden = !hasSwitch
        stepStackView.isHidden = !stepByStep
        difficultStackView.isHidden = stepByStep
    }

    //MARK: - Functions

    @objc func notify() { removeAnimation() }

    @objc func tap() { removeAnimation() }

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
        UIView.animate(withDuration: 0.2) {
            self.containerView.transform = CGAffineTransform(translationX: 0, y: self.containerView.frame.height + 300)
        } completion: { (complete) in
            self.view.removeFromSuperview()
        }
    }

    //MARK: - Actions

    @IBAction func beginnerTapped(_ sender: UIButton) {
        delegate?.getSwitchValue(bool: gameSwitch.value)
        delegate?.beginnerButtonTapped(index: sender.tag, game: game)
    }

    @IBAction func intermediateTapped(_ sender: UIButton) {
        delegate?.getSwitchValue(bool: gameSwitch.value)
        delegate?.intermediateButtonTapped(index: sender.tag, game: game)
    }

    @IBAction func advanceTapped(_ sender: UIButton) {
        delegate?.getSwitchValue(bool: gameSwitch.value)
        delegate?.advanceButtonTapped(index: sender.tag, game: game)
    }
    
    @IBAction func stepButtonsAction(_ sender: UIButton) {
        delegate?.getSwitchValue(bool: gameSwitch.value)
        delegate?.buttonTapped(index: sender.tag)
    }

    //MARK: - Public
    
    public func setGame(_ game: Game) { self.game = game }

    public func setSwitch(_ bool: Bool) { hasSwitch = bool }
    
    public func setStepByStep(_ bool: Bool) { stepByStep = bool }
}

//MARK: - Helpers

enum FromController {
    case adding_3
    case subtracting_3
    case findNum
    case adding_5
    case subtracting_5
}

enum GameDifficulty: Int {
    case beginner
    case intermediate
    case advance
    case custom

    var strRawValue: String {
        switch self {
        case .beginner:
            return "Beginner"
        case .intermediate:
            return "Intermediate"
        case .advance:
            return "Advance"
        case .custom:
            return "Custom"
        }
    }
}
