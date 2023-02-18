//
//  TabularViewController.swift
//  Preschool Math Game
//
//  Created by Armen Gasparyan on 22.02.22.
//

import UIKit
import AudioToolbox.AudioServices
import FirebaseAnalytics

class TabularViewController: BaseViewController, GameStartDelegate {
    
    //MARK: - Outlets
    
    @IBOutlet private weak var backButton: BackButton!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var prizeTableView: UITableView!
    @IBOutlet private weak var topImageView: UIImageView!
    @IBOutlet private weak var personImageView: UIImageView!
    @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet private weak var middleView: UIView!
    @IBOutlet private weak var prizesAndTimerContentView: UIView!
    @IBOutlet private weak var prizeContentView: UIView!
    @IBOutlet private weak var timerContentView: UIView!
    @IBOutlet private weak var balloonsImageView: UIImageView!
    @IBOutlet private weak var leftBalloonImageView: UIImageView!
    @IBOutlet private weak var rightBalloonImageView: UIImageView!
    
    @IBOutlet weak var collectionViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var prizeTableViewHeightConstraint: NSLayoutConstraint!
    
    private var selectedIndexPath: IndexPath?
    private var viewModel = TabularViewModel()
    
    //MARK: -Static
    
    static func initWithStoryboard() -> TabularViewController? {
        let storyboard = UIStoryboard(name: "SchulteAndMemory", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: TabularViewController.name) as? TabularViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }

    override func viewDidAppear(_ animated: Bool) {
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters: [AnalyticsParameterScreenName: viewModel.analiticsValue, AnalyticsParameterScreenClass: self])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if middleView.frame.height < (middleView.frame.width / viewModel.multiplier) {
            collectionViewHeightConstraint.constant = middleView.frame.height
            collectionViewWidthConstraint.constant = middleView.frame.height * viewModel.multiplier
        } else {
            collectionViewWidthConstraint.constant = middleView.frame.width
            collectionViewHeightConstraint.constant = middleView.frame.width / viewModel.multiplier
        }
        prizeTableViewHeightConstraint.constant = CGFloat(viewModel.prizeCount) * PrizeTableViewCell.height
    }
    
    private func setup() {
        viewModel.delegate = self
        viewModel.getState()
        
        backButton.setNavigation(navigationController)
        collectionView.setBorder()
        collectionView.setCorner()
        collectionView.isScrollEnabled = false
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = true
        collectionView.isUserInteractionEnabled = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        prizesAndTimerContentView.isHidden = viewModel.prizes == nil
        balloonsImageView.isHidden = viewModel.prizes != nil
        prizeTableView.separatorStyle = .none
        prizeTableView.setBorder(color: .borderBlue)
        prizeTableView.setCorner()
        prizeTableView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        timerContentView.setBorder()
        timerContentView.setCorner()
        timerLabel.textColor = .borderBlue
        timerLabel.adjustsFontSizeToFitWidth = true
        
        switch viewModel.gameAddress.subType {
        case .images:
            if viewModel.gameAddress.difficulty == .beginner {
                balloonsImageView.isHidden = true
                leftBalloonImageView.isHidden = false
                rightBalloonImageView.isHidden = false
            } else {
                leftBalloonImageView.isHidden = false
            }
            topImageView.image = UIImage(named: "beeBackground")
            collectionView.register(UINib(nibName: ImageCollectionViewCell.name, bundle: nil), forCellWithReuseIdentifier: ImageCollectionViewCell.name)
        default:
            collectionView.register(UINib(nibName: NumberCollectionViewCell.name, bundle: nil), forCellWithReuseIdentifier: NumberCollectionViewCell.name)
        }
        
        personImageView.image = UIImage(named: viewModel.personName)
        showGameStartVC(self)
    }

    func setNavigationIndexes(_ indexes: [Int]) { viewModel.setNavigationIndexes(indexes) }
    
    func start() { if viewModel.gameAddress.subType != .images {
        viewModel.selectFirstItem() }
    }
    
    func simpleSuccess() {
        guard #available(iOS 10.0, *) else { return }
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

//MARK: - CollectionView methods

extension TabularViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch viewModel.gameAddress.subType {
        case .images:
            return viewModel.images.count
        default:
            return viewModel.numbers.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.gameAddress.subType {
        case .images:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.name, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
            
            collectionView.isUserInteractionEnabled = true
            cell.setData(backgroundImage: viewModel.getIconNames(row: indexPath.row), image: viewModel.images[indexPath.row])
            cell.unselect()
            
            if viewModel.gameAddress.difficulty != .beginner {
                timer = Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { _ in
                    cell.hiddenImageView.isHidden = false
                    self.viewModel.startTimer()
                }
            }
            
            return cell
            
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NumberCollectionViewCell.name, for: indexPath) as? NumberCollectionViewCell else { return UICollectionViewCell() }
            
            cell.setData(number: viewModel.numbers[indexPath.row], image: viewModel.getIconNames(row: indexPath.row))
            cell.unselect()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch viewModel.gameAddress.subType {
        case .images:
            let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell
            
            if viewModel.gameAddress.difficulty == .beginner {
                cell?.select()
            } else {
                cell?.openImage()
            }
            Vibration.success.vibrate()
            
            if viewModel.firstIndexPath == nil {
                viewModel.firstIndexPath = indexPath
            } else {
                if viewModel.secondIndexPath == nil {
                    viewModel.secondIndexPath = indexPath
                } else {
                    // Advance / Intermediate
                    if viewModel.gameAddress.difficulty != .beginner {
                        let firstCell = collectionView.cellForItem(at: viewModel.firstIndexPath!) as? ImageCollectionViewCell
                        let secondCell = collectionView.cellForItem(at: viewModel.secondIndexPath!) as? ImageCollectionViewCell
                        viewModel.unselectFirstCell(collectionView: collectionView, firstCell: firstCell)
                        viewModel.unselectSecondCell(collectionView: collectionView, secondCell: secondCell)
                        viewModel.firstIndexPath = indexPath
                    } else {
                        // Beginner
                        let secondCell = collectionView.cellForItem(at: viewModel.secondIndexPath!) as? ImageCollectionViewCell
                        viewModel.unselectSecondCell(collectionView: collectionView, secondCell: secondCell)
                        viewModel.secondIndexPath = indexPath
                    }
                }
            }
            
            guard let _ = viewModel.secondIndexPath else { return }
            
            let firstCell = collectionView.cellForItem(at: viewModel.firstIndexPath!) as? ImageCollectionViewCell
            let secondCell = collectionView.cellForItem(at: viewModel.secondIndexPath!) as? ImageCollectionViewCell
            
            viewModel.checkImages(firstCell: firstCell, secondCell: secondCell, collectionView: collectionView, firstIndexPath: viewModel.firstIndexPath, secondIndexPath: viewModel.secondIndexPath)
            
        default:
            selectedIndexPath = indexPath
            viewModel.selectedAction(indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell
        viewModel.firstIndexPath = nil
        
        if viewModel.gameAddress.difficulty == .beginner {
            cell?.setGreyBackground()
        } else {
            cell?.hideImage()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.size.width / CGFloat(viewModel.columnRow.r)//sqrt(CGFloat(viewModel.numbers.count))
        return CGSize(width: height, height: height)
    }
}

//MARK: - TableView Methods

extension TabularViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return viewModel.prizeCount }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PrizeTableViewCell.name, for: indexPath) as? PrizeTableViewCell,
              let prizes = viewModel.prizes else { return UITableViewCell() }
        
        cell.setPrize(prizes[indexPath.row])
        return cell
    }
}

//MARK: - View Model

extension TabularViewController: TabularViewModelDelegate {
    func reloadData() {
        prizeTableView.reloadData()
        collectionView.reloadData()
    }
    
    func reset() { showGameStartVC(self) }
    
    func selectFirstItem(index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView(collectionView, didSelectItemAt: indexPath)
    }

    func updateTimer(second: Int) { DispatchQueue.main.async { self.timerLabel.text = second.toHoursMinutesSeconds() } }
    
    func gameEnded(iconName: String) {
        prizeTableViewHeightConstraint.constant = CGFloat(viewModel.prizeCount) * PrizeTableViewCell.height
        prizeTableView.reloadData()
        presentEndPopUpVC(delegate: self, icon: iconName, refresh: true)
        view.bringSubviewToFront(backButton)
    }
    
    func failAction() {
        guard let indexPath = selectedIndexPath,
              let cell = collectionView.cellForItem(at: indexPath) else { return }
        cell.animateWithShake()
        Vibration.error.vibrate()
    }
    
    func showParental() { showParentalController() }
    
    func succesSchulteAscendingBeginer() {
        guard let indexPath = selectedIndexPath,
              let cell = collectionView.cellForItem(at: indexPath) as? NumberCollectionViewCell else { return }
        Vibration.success.vibrate()
        cell.selectionSetup(with: viewModel.isAscending)
    }
}

//MARK: - EndPopUpViewController

extension TabularViewController: EndPopUpViewControllerDelegate {
    func backTapped() { backButton.tapped() }
    
    func refreshTapped() { viewModel.refresh() }
}

//MARK: - Constraints

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}
