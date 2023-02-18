//
//  SubscriptionViewController.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 5/26/21.
//

import UIKit
import StoreKit

class SubscriptionViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var yearlyLabel: UILabel!
    @IBOutlet var yearlyView: UIView!
    @IBOutlet var yearly: UILabel!
    
    @IBOutlet weak var monthlyLabel: UILabel!
    @IBOutlet var montlyView: UIView!
    @IBOutlet var monthly: UILabel!
    
    @IBOutlet var yearlyTo12monthsLabel: UILabel!
    @IBOutlet var savePercentLabel: UILabel!
    @IBOutlet var subscriptionOrTrialButton: UIButton!
    @IBOutlet var trialLabel: UILabel!
    @IBOutlet var backgroundImage: UIImageView!
    
    @IBOutlet var updateButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var yearlyViewImage: UIImageView!
    @IBOutlet var monthlyImageView: UIImageView!
    @IBOutlet var nextLabel: UILabel!
    @IBOutlet var savePercentImageView: UIImageView!
    
    @IBOutlet var saveLabel: UILabel!
    @IBOutlet var trialLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet var updateButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet var errorLabelHeightConstraint: NSLayoutConstraint!
    
    //MARK: - Properties
    private var subscriptions: [Subscription]?
    public var fromLimitedGame = false
    public var fromLearningGame = false
    private var indicatorView = UIView()
    private var indicator = UIActivityIndicatorView()
    private var yearlyTappedCount = 0
    private var monthlyTappedCount = 0
    private var selectedView = ""
    private var purpleColor = UIColor(red: 127, green: 72, blue: 195)
    private var grayColor = UIColor(red: 224, green: 224, blue: 222).cgColor
    override var prefersHomeIndicatorAutoHidden: Bool { return false }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return UIRectEdge.bottom
    }
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sturtupSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.post(name: .closeParentalControl, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Loading.shared.endLoading()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            backgroundImage.image = UIImage(named: "subscribe_background_ipad")
            
        }
        yearlyView.layer.cornerRadius = 5
        montlyView.layer.cornerRadius = 5
        montlyView.layer.borderColor = grayColor
        yearlyView.layer.borderColor = purpleColor.cgColor
        
        
    }
    
    //MARK: - Setup UI
    private func sturtupSetup() {
        fetchProduct()
        setLabelTitle()
        updateUI()
        yearlyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(yearlyButtonAction)))
        yearlyView.layer.borderWidth = 1.5
        montlyView.layer.borderWidth = 1.5
        selectedView = "yearly"
        montlyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(montlyButtonAction)))
        nextLabel.layer.masksToBounds = true
        nextLabel.layer.cornerRadius = 10
        yearlyLabel.text = UserDefaults.standard.string(forKey: "yearlyPrice")
        monthlyLabel.text = UserDefaults.standard.string(forKey: "montlyPrice")
        savePercentLabel.text = UserDefaults.standard.string(forKey: "yearlyPercent")
        yearlyTo12monthsLabel.text = UserDefaults.standard.string(forKey: "12monthsPrice")

                                        
    }
    
    fileprivate func updateUI() {
        let id = UserDefaults.standard.string(forKey: UserDefaultsKeys.subscriptionType) ?? ""

        if id.contains("yearly") {
            yearlyViewImage.image = UIImage(named: "yearlyViewSelectedImage")
            monthlyImageView.image = UIImage(named: "monthlyViewUnSelectedImage")
            yearlyLabel.textColor = .white
            yearly.textColor = .white
            monthlyLabel.textColor = purpleColor
            monthly.textColor = purpleColor
            savePercentImageView.tintColor = purpleColor
            yearlyTo12monthsLabel.textColor = .white
            savePercentImageView.image = UIImage(named: "subscriptionSavePercentSelected")
            saveLabel.textColor = purpleColor
            savePercentLabel.textColor = purpleColor
            trialLabelHeightConstraint.constant = 0
            subscriptionOrTrialButton.setTitle("Subscribe", for: .normal)
            if let id = IAPHelper.sharedInstance.pandingInfo?.autoRenewId, id.contains("monthly") {
                nextLabel.isHidden = false
            }
        } else if id.contains("monthly") {
            montlyView.backgroundColor = purpleColor
            monthlyLabel.textColor = .white
            monthly.textColor = .white
            yearlyViewImage.image = UIImage(named: "yearlyViewUnselectImage")
            monthlyImageView.image = UIImage(named: "monthlyViewSelectedImage")
            yearlyLabel.textColor = purpleColor
            yearly.textColor = purpleColor
            yearlyTo12monthsLabel.textColor = purpleColor
            savePercentImageView.image = UIImage(named: "subscriptionSavePercentUnselected")
            saveLabel.textColor = .white
            savePercentLabel.textColor = .white
            nextLabel.isHidden = true
            trialLabelHeightConstraint.constant = 0
            subscriptionOrTrialButton.setTitle("Subscribe", for: .normal)
            errorLabelHeightConstraint.constant = 0
        } else {
            nextLabel.isHidden = true
            monthly.textColor = purpleColor
            monthlyLabel.textColor = purpleColor
            yearly.textColor = purpleColor
            yearlyLabel.textColor = purpleColor
            montlyView.backgroundColor = .white
            yearlyView.backgroundColor = .white
            yearlyViewImage.image = UIImage(named: "yearlyViewUnselectImage")
            monthlyImageView.image = UIImage(named: "monthlyViewUnSelectedImage")
            trialLabelHeightConstraint.constant = 0
            errorLabelHeightConstraint.constant = 0
        }
        if let billingRetry = IAPHelper.sharedInstance.pandingInfo?.billingRetry {
            if  billingRetry == 1 {
                if (IAPHelper.sharedInstance.pandingInfo?.grace_period) != nil {
                    errorLabel.text = "Payment problem: your account remains active, but please update your credit card information to avoid suspension."
                    errorLabelHeightConstraint.constant = 20
                    updateButton.isHidden = false
                    updateButtonHeightConstraint.constant = 15
                } else {
                    errorLabel.text = "Payment problem: Billing Retry state, please update your credit card information to resume subscription."
                    errorLabelHeightConstraint.constant = 20
                    updateButtonHeightConstraint.constant = 15
                }
            }
        }
        if let autoRenewStatus =  IAPHelper.sharedInstance.pandingInfo?.autoRenewStatus {
            if id != "" && autoRenewStatus == "0" {
                errorLabel.text = "The subscription has been canceled, please RE-SUBSCRIBE to avoid suspension."
                errorLabelHeightConstraint.constant = 20
                updateButtonHeightConstraint.constant = 15
                subscriptionOrTrialButton.setTitle("Re-Subscribe", for: .normal)
            }
        }
        
    }
    
    private func setLabelTitle() {
        yearlyLabel.adjustsFontSizeToFitWidth = true
        monthlyLabel.adjustsFontSizeToFitWidth = true

        if let subscriptions = subscriptions {
            yearlyLabel.text = "\(subscriptions.last?.localizedPrice ?? "")"
            monthlyLabel.text = "\(subscriptions.first?.localizedPrice ?? "")"
            UserDefaults.standard.set(monthlyLabel.text, forKey: "montlyPrice")
            UserDefaults.standard.set(yearlyLabel.text, forKey: "yearlyPrice")
            let productPrice = (subscriptions.first?.price ?? 0.0 ) * 12
            var text = "12 months as x/mo"
            text = text.replacingOccurrences(of: "x", with: "\(((subscriptions.last?.price  ?? 0.0) / 12).getString())")
            yearlyTo12monthsLabel.text = text
            savePercentLabel.text =   "\(Int(100 - (((subscriptions.last?.price  ?? 0.0) * 100) / productPrice)))" + "%"
            UserDefaults.standard.set(savePercentLabel.text, forKey: "yearlyPercent")
            UserDefaults.standard.set(yearlyTo12monthsLabel.text, forKey: "12monthsPrice")
        }
    }
    
    //MARK: - Fonctions
    private func setupIndicator() {
        indicatorView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: view.frame.height)))
        indicatorView.backgroundColor = .black
        indicatorView.alpha = 0.5
        view.addSubview(indicatorView)
        
        indicator.center = view.center
        indicator.color = .white
        indicatorView.addSubview(indicator)
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
    }
    
    private func hideIndicator() {
        indicatorView.isHidden = true
        indicator.stopAnimating()
    }
    
    private func fetchProduct() {
        Loading.shared.startLoading(ignoringActions: true, for: self.view)
        SKPaymentQueue.default().add(self)
        let request = SKProductsRequest(productIdentifiers: ["com.witplex.PreSchoolMath.monthly", "com.witplex.PreSchoolMath.yearly"])
        request.delegate = self
        request.start()
    }
    
    private func purchase(productIdenty: String) {
        guard SKPaymentQueue.canMakePayments() else {
            Loading.shared.endLoading()
            return
        }

        guard let storeKitProduct = subscriptions?.first(where: { $0.product.productIdentifier == productIdenty })?.product else {
            print(productIdenty)
            Loading.shared.endLoading()
            return
        }
        
        let paymentRequest = SKPayment(product: storeKitProduct)
        SKPaymentQueue.default().add(paymentRequest)
    }
    
    //MARK: - Actions
    @objc func yearlyButtonAction() {
        monthlyTappedCount = 0
        selectedView = "yearly"
        yearlyView.layer.borderColor = purpleColor.cgColor
        montlyView.layer.borderColor = grayColor
        yearlyTappedCount += 1
        if yearlyTappedCount == 2 {
            subscriptionButtonAction(UIButton())
        }
        
        
    }
    
    @objc func montlyButtonAction() {
        yearlyTappedCount = 0
        montlyView.layer.borderColor = purpleColor.cgColor
        yearlyView.layer.borderColor = grayColor
        selectedView = "monthly"
        monthlyTappedCount += 1
        if monthlyTappedCount == 2 {
            subscriptionButtonAction(UIButton())
        }
        
    }
    
    @IBAction func subscriptionButtonAction(_ sender: Any) {
        if selectedView == "yearly" {
            Loading.shared.startLoading()
            purchase(productIdenty: "com.witplex.PreSchoolMath.yearly")
        } else {
            Loading.shared.startLoading()
            purchase(productIdenty: "com.witplex.PreSchoolMath.monthly")
        }
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        if fromLimitedGame {
            if fromLearningGame {
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
            } else {
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
            }
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func termsButtonAction(_ sender: UIButton) {
        let urlString = "https://www.witplex.com/PreMathGame/TermOfUse"
        let url = URL(string: urlString)
        UIApplication.shared.openURL(url!)
    }
    
    @IBAction func policyAction(_ sender: UIButton) {
        let urlString = "https://www.witplex.com/PreMathGame/PrivacyPolicy"
        let url = URL(string: urlString)
        UIApplication.shared.openURL(url!)
    }
    
    @IBAction func restoreAction(_ sender: UIButton) {
        Loading.shared.startLoading()
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

//MARK: - Extensions
extension SubscriptionViewController: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.subscriptions = response.products.map { Subscription(product: $0) }
        DispatchQueue.main.async {
            self.setLabelTitle()
            Loading.shared.endLoading(for: self.view)
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .failed:
                queue.finishTransaction(transaction)
                DispatchQueue.main.async {
                    Loading.shared.endLoading()
//                    guard let error = transaction.error?.localizedDescription else { return }
//                    self.showAlert(message: error)
                }
                debugPrint("Transaction Failed \(transaction.payment.productIdentifier)")
            case .purchased, .restored:
                    queue.finishTransaction(transaction)
                DispatchQueue.main.async {
                    Loading.shared.endLoading()
                    guard let error = transaction.error?.localizedDescription else { return }
                    self.showAlert(message: error)
                }

                    if transaction == transactions.last {
                        self.receiptValidate()
                    }
                    debugPrint("Transaction purchased or restored: \(transaction.payment.productIdentifier)")
            case .deferred, .purchasing:
                DispatchQueue.main.async {
                    Loading.shared.startLoading()
                }
                debugPrint("Transaction in progress: \(transaction.payment.productIdentifier)")
            default:
                DispatchQueue.main.async {
                    Loading.shared.endLoading()
                }
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        DispatchQueue.main.async { Loading.shared.endLoading() }
    }

    func receiptValidate() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            IAPHelper.sharedInstance.receiptValidation { [weak self] _ in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.updateUI()
                    self.postNotifications()
                    Loading.shared.endLoading()
                }
            }
        }
    }
    
    fileprivate func postNotifications() {
        guard subscribed else { return }
        
        NotificationCenter.default.post(name: .updateCounting_1, object: nil)

        NotificationCenter.default.post(name: .updateCounting_2, object: nil)

        NotificationCenter.default.post(name: .updateCompare, object: nil)

        NotificationCenter.default.post(name: .updateAddingFun, object: nil)

        NotificationCenter.default.post(name: .updateSubtracting, object: nil)

        NotificationCenter.default.post(name: .updateShapes_1, object: nil)

        NotificationCenter.default.post(name: .updateShapes_2, object: nil)

        NotificationCenter.default.post(name: .updateAdding_2, object: nil)

        NotificationCenter.default.post(name: .updateSubtracting_2, object: nil)

        NotificationCenter.default.post(name: .updateAdding_3, object: nil)

        NotificationCenter.default.post(name: .updateSubtracting_3, object: nil)

        NotificationCenter.default.post(name: .updateAddingSubMix, object: nil)

        NotificationCenter.default.post(name: .updateMultiplication, object: nil)

        NotificationCenter.default.post(name: .updateMultiplication_2, object: nil)

        NotificationCenter.default.post(name: .updateDivision, object: nil)

        NotificationCenter.default.post(name: .updateOdd_Even, object: nil)
        
        NotificationCenter.default.post(name: .updateShapes_3, object: nil)

        NotificationCenter.default.post(name: .updateShapes_4, object: nil)

        NotificationCenter.default.post(name: .updateFindNumber, object: nil)

        NotificationCenter.default.post(name: .updateSortingNum_1, object: nil)
        
        NotificationCenter.default.post(name: .updateNewAdding, object: nil)

        NotificationCenter.default.post(name: .updateNewMultiplic, object: nil)

        NotificationCenter.default.post(name: .updateNewDivision, object: nil)

        NotificationCenter.default.post(name: .updateNewSubtracting, object: nil)

        NotificationCenter.default.post(name: .updateLearning, object: nil)
        
        NotificationCenter.default.post(name: .unblockLearning, object: nil)
        
        NotificationCenter.default.post(name: .updateAdding_5, object: nil)

        NotificationCenter.default.post(name: .updateSubtracting_5, object: nil)

        GameCenter.allGames.forEach { $0.isLocked = false }
    }
}
