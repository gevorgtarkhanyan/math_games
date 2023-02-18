//
//  GameSelectionViewController.swift
//  Preschool Math Game
//
//  Created by Armen Gasparyan on 21.02.22.
//

import UIKit

class GameSelectionViewController: NewBaseViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var preschoolMathGameConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backButton: BackButton!
    private let flowLayout = ZoomFlowLayout()

    @IBOutlet weak var topLeftImageView: UIImageView!
    @IBOutlet weak var bottomRightImageView: UIImageView!

    @IBOutlet weak var topLeftImageVIewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomRightImageVIewHeightConstraint: NSLayoutConstraint!
    
    //MARK: - Properties
    
    var games = [Game]()

    var navigationIndexes = [0, 0, 0, 0]
    
    static func initWithStoryboard() -> GameSelectionViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: GameSelectionViewController.name) as? GameSelectionViewController
    }
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupUIForPad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
        addBackgroundNotificaitonObserver()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeBackgroundNotificaitonObserver()
    }
    
    override func applicationOpenedFromBackground(_ sender: Notification) { collectionView.reloadData() }
    
    //MARK: - Setup
    
    private func setup() {
        navigationIndexes[0] = games.first?.type.index ?? 0
        backButton.setNavigation(navigationController)
        setupCollectionView()
        titleLabel.layer.borderWidth = 1.5
        titleLabel.layer.borderColor = UIColor(red: 249, green: 184, blue: 24).cgColor
    }
    
    private func setupCollectionView() {
        collectionView.register(UINib(nibName: "DivisionCollectionCell", bundle: nil), forCellWithReuseIdentifier: "DivisionCollectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = flowLayout
    }
}

//MARK: - Collection View
extension GameSelectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return games.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DivisionCollectionCell", for: indexPath) as! DivisionCollectionCell
        
        cell.setGame(game: games[indexPath.row])

        if indexPath.row == 2 {
            cell.centerYConstraint.constant = -3
            cell.centerXConstraint.constant = -1
        } else if indexPath.row == 1 {
            cell.centerYConstraint.constant = 1
            cell.centerXConstraint.constant = 1
        } else if indexPath.row == 0 {
            cell.centerXConstraint.constant = 1
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let game = games[indexPath.row]
        navigationIndexes[0] = game.type.index
        navigationIndexes[1] = game.subtype.subIndex
        if game.isLocked {
            lockedAction()
        } else if game.hasDifficulty {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                    difficultyAction(with: indexPath.row, game: game)
            }
        } else {
            switch game.subtype {
            case .counting1:
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                    guard let vc = Counting_1Controller.initWithStoryboard() else { return }
                    vc.game = game
                    navigationController?.pushViewController(vc, animated: true)
                }
            case .counting2:
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                    guard let vc = Countong_2Controller.initWithStoryboard() else { return }
                    vc.game = game
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case .oddEven:
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                    guard let vc = EvenAndOddViewController.initWithStoryboard() else { return }
                    vc.game = game
                    navigationController?.pushViewController(vc, animated: true)
                }
            case .shapes1:
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                    guard let vc = Shapes_1ViewController.initWithStoryboard() else { return }
                    vc.game = game
                    navigationController?.pushViewController(vc, animated: true)
                }
            case .shapes2:
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                    guard let vc = Shapes_2ViewController.initWithStoryboard() else { return }
                    vc.game = game
                    navigationController?.pushViewController(vc, animated: true)
                }
            case .shapes3:
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                    guard let vc = Shapes_3ViewController.initWithStoryboard() else { return }
                    vc.game = game
                    navigationController?.pushViewController(vc, animated: true)
                }
            case .shapes4:
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                    guard let vc = Shapes_4ViewController.initWithStoryboard() else { return }
                    vc.game = game
                    navigationController?.pushViewController(vc, animated: true)
                }
            case .adding1:
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                    guard let vc = AddingFunController.initWithStoryboard() else { return }
                    vc.game = game
                    navigationController?.pushViewController(vc, animated: true)
                }
            case .adding2:
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                    guard let vc = AddingFun_2ViewController.initWithStoryboard() else { return }
                    vc.game = game
                    navigationController?.pushViewController(vc, animated: true)
                }
            case .adding4:
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                    guard let vc = NewAddingController.initWithStoryboard() else { return }
                    vc.game = game
                    navigationController?.pushViewController(vc, animated: true)
                }
            case .addingMix:
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                    guard let vc = AddingSubMixController.initWithStoryboard() else { return }
                    vc.game = game
                    navigationController?.pushViewController(vc, animated: true)
                }
            case .ascending:
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                    guard let vc = SortingNumbersController.initWithStoryboard() else { return }
                    vc.isAscending = true
                    vc.game = game
                    navigationController?.pushViewController(vc, animated: true)
                }
            case .descending:
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                    guard let vc = SortingNumbersController.initWithStoryboard() else { return }
                    vc.isAscending = false
                    vc.game = game
                    navigationController?.pushViewController(vc, animated: true)
                }
            case .learning:
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                    guard let vc = LearningBaseController.initWithStoryboard() else { return }
                    vc.game = game
                    navigationController?.pushViewController(vc, animated: true)
                }
            case .multipl1:
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                    guard let vc = MultiplicationController.initWithStoryboard() else { return }
                    vc.game = game
                    navigationController?.pushViewController(vc, animated: true)
                }
            case .multipl2:
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                    guard let vc = Multiplication_2Controller.initWithStoryboard() else { return }
                    vc.game = game
                    navigationController?.pushViewController(vc, animated: true)
                }
            case .multipl3:
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                    guard let vc = NewMultiplicationController.initWithStoryboard() else { return }
                    vc.game = game
                    navigationController?.pushViewController(vc, animated: true)
                }
            case .compare:
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                    guard let vc = CompareController.initWithStoryboard() else { return }
                    vc.game = game
                    navigationController?.pushViewController(vc, animated: true)
                }
            case .division1:
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                    guard let vc = DivisionViewController.initWithStoryboard() else { return }
                    vc.game = game
                    navigationController?.pushViewController(vc, animated: true)
                }
            case .division2:
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                    guard let vc = NewDivisionController.initWithStoryboard() else { return }
                    vc.game = game
                    navigationController?.pushViewController(vc, animated: true)
                }
            case .subtract1:
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                    guard let vc = SubtractingFunController.initWithStoryboard() else { return }
                    vc.game = game
                    navigationController?.pushViewController(vc, animated: true)
                }
            case .subtract2:
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                    guard let vc = Subtracting_2ViewController.initWithStoryboard() else { return }
                    vc.game = game
                    navigationController?.pushViewController(vc, animated: true)
                }
            case .subtract4:
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                    guard let vc = NewSubtractingController.initWithStoryboard() else { return }
                    vc.game = game
                    navigationController?.pushViewController(vc, animated: true)
                }
            default:
                break
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat
        var height: CGFloat
        //        let itemsHeight: CGFloat = 10 + 15 + 5 + 5 + 17
        var n: CGFloat = 37
        
        if UIDevice.current.userInterfaceIdiom != .pad {
            height = (view.frame.height) / 3.4
        } else {
            n = 25
            height = (view.frame.height) / 4.5
        }
        width = height * (150 / 83.71) - (height * n / 76) //2778 / 1284
        return CGSize(width: width, height: height)
    }
    
    //MARK: - Functions

    private func difficultyAction(with index: Int, game: Game) {
        guard let vc = GameDifficultyController.initWithStoryboard() else { return }
        vc.game = game
        vc.delegate = self
        
        if game.type == .schulte {
            vc.setSwitch(true)
        } else { vc.setSwitch(false) }
        
        vc.setStepByStep(game.name == "Step By Step")
        self.addChild(vc)
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
    private func lockedAction() {
        guard let vc = ParentalControllController.initWithStoryboard() else { return }
        
        self.addChild(vc)
        self.view.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
}

//MARK: - Difficulty

extension GameSelectionViewController: GameDifficultyDelegate {

    func beginnerButtonTapped(index: Int, game: Game) {
        switch game.subtype {
        case .findNumber:
            guard let vc = FindRightNumberController.initWithStoryboard() else { return }
            vc.game = game
            navigationController?.pushViewController(vc, animated: true)
        case .adding3:
            guard let vc = Adding_3ViewController.initWithStoryboard() else { return }
            vc.game = game
            vc.gameType = .beginner
            navigationController?.pushViewController(vc, animated: true)
        case .adding5:
            guard let vc = Adding_5ViewController.initWithStoryboard() else { return }
            vc.game = game
            navigationController?.pushViewController(vc, animated: true)
        case .subtract3:
            guard let vc = Subtracting_3ViewController.initWithStoryboard() else { return }
            vc.game = game
            vc.gameType = .beginner
            navigationController?.pushViewController(vc, animated: true)
        case .subtract5:
            guard let vc = Subtracting_5Controller.initWithStoryboard() else { return }
            vc.game = game
            navigationController?.pushViewController(vc, animated: true)
        case .scale:
            removeTopChildViewController()
            guard let vc = ScaleGameViewController.initWithStoryboard() else { return }
            vc.game = game
            navigationController?.pushViewController(vc, animated: true)
        default:
            navigationIndexes[3] = index
            removeTopChildViewController()
            guard let vc = TabularViewController.initWithStoryboard() else { return }
            vc.setNavigationIndexes(navigationIndexes)
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func intermediateButtonTapped(index: Int, game: Game) {
        switch game.subtype {
        case .findNumber:
            guard let vc = IntermediateFindNumController.initWithStoryboard() else { return }
            vc.game = game
            navigationController?.pushViewController(vc, animated: true)
        case .adding3:
            guard let vc = Adding_3ViewController.initWithStoryboard() else { return }
            vc.game = game
            vc.gameType = .intermediate
            navigationController?.pushViewController(vc, animated: true)
        case .adding5:
            guard let vc = Adding_5InterController.initWithStoryboard() else { return }
            vc.game = game
            navigationController?.pushViewController(vc, animated: true)
        case .subtract3:
            guard let vc = Subtracting_3ViewController.initWithStoryboard() else { return }
            vc.game = game
            vc.gameType = .intermediate
            navigationController?.pushViewController(vc, animated: true)
        case .subtract5:
            guard let vc = Subtracting_5InterController.initWithStoryboard() else { return }
            vc.game = game
            navigationController?.pushViewController(vc, animated: true)
        case .scale:
            removeTopChildViewController()
            guard let vc = ScaleGameIntermediateAdvanceViewController.initWithStoryboard() else { return }
            vc.game = game
            vc.difficulty = .intermediate
            navigationController?.pushViewController(vc, animated: true)
        default:
            navigationIndexes[3] = index
            removeTopChildViewController()
            guard let vc = TabularViewController.initWithStoryboard() else { return }
            vc.setNavigationIndexes(navigationIndexes)
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func advanceButtonTapped(index: Int, game: Game) {
        switch game.subtype {
        case .findNumber:
            guard let vc = AdvanceFindNumController.initWithStoryboard() else { return }
            vc.game = game
            navigationController?.pushViewController(vc, animated: true)
        case .adding3:
            guard let vc = Adding_3ViewController.initWithStoryboard() else { return }
            vc.game = game
            vc.gameType = .advance
            navigationController?.pushViewController(vc, animated: true)
        case .adding5:
            guard let vc = Adding_5AdvancedController.initWithStoryboard() else { return }
            vc.game = game
            navigationController?.pushViewController(vc, animated: true)
        case .subtract3:
            guard let vc = Subtracting_3ViewController.initWithStoryboard() else { return }
            vc.game = game
            vc.gameType = .advance
            navigationController?.pushViewController(vc, animated: true)
        case .subtract5:
            guard let vc = Subtracting_5AdvancedController.initWithStoryboard() else { return }
            vc.game = game
            navigationController?.pushViewController(vc, animated: true)
        case .scale:
            removeTopChildViewController()
            guard let vc = ScaleGameIntermediateAdvanceViewController.initWithStoryboard() else { return }
            vc.game = game
            vc.difficulty = .advance
            navigationController?.pushViewController(vc, animated: true)
        default:
            navigationIndexes[3] = index
            removeTopChildViewController()
            guard let vc = TabularViewController.initWithStoryboard() else { return }
            vc.setNavigationIndexes(navigationIndexes)
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func buttonTapped(index: Int) {
        navigationIndexes[3] = index
        removeTopChildViewController()
        guard let vc = TabularViewController.initWithStoryboard() else { return }
        vc.setNavigationIndexes(navigationIndexes)
        navigationController?.pushViewController(vc, animated: true)
    }

    func getSwitchValue(bool: Bool) { navigationIndexes[2] = bool.intValue }
}

//MARK: - Extensions

extension GameSelectionViewController {
    public func setGames(_ games: [Game]) { self.games = games }
}

extension GameSelectionViewController {
    private func setupUIForPad() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            backgroundImageView.image = UIImage(named: "gameSelectionBackgroundPad")
            preschoolMathGameConstraint.constant = 130

            let padTopLeftImageViewHeightConstraint = NSLayoutConstraint(item: topLeftImageView!, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.3, constant: 0)
            let padBottomRightImagVieweHeightConstraint = NSLayoutConstraint(item: bottomRightImageView!, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.3, constant: 0)

            topLeftImageVIewHeightConstraint.isActive = false
            topLeftImageVIewHeightConstraint = padTopLeftImageViewHeightConstraint
            padTopLeftImageViewHeightConstraint.isActive = true

            bottomRightImageVIewHeightConstraint.isActive = false
            padBottomRightImagVieweHeightConstraint.isActive = true
            bottomRightImageVIewHeightConstraint = padBottomRightImagVieweHeightConstraint
        }
    }
}
