//
//  PurchasingCollectionCell.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 25.09.21.
//

import UIKit
import StoreKit

protocol PurchasingCollectionCellDelegate: AnyObject {
    func push()
}

class PurchasingCollectionCell: UICollectionViewCell {

    weak var delegate: PurchasingCollectionCellDelegate?
    
    private var myProduct: [SKProduct]?
    private var indicatorView = UIView()
    private var indicator = UIActivityIndicatorView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        fetchProduct()
    }
    
    private func fetchProduct() {
        let request = SKProductsRequest(productIdentifiers: ["com.witplex.PreSchoolMath.monthly", "com.witplex.PreSchoolMath.yearly"])
        request.delegate = self
        request.start()
    }
    
    private func purchase(productIdenty: String) {
        guard SKPaymentQueue.canMakePayments() else {
            return
        }
        
        guard let storeKitProduct = myProduct?.first(where: {$0.productIdentifier == productIdenty}) else {
            print(productIdenty)
            
            return
        }
        
        let paymentRequest = SKPayment(product: storeKitProduct)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(paymentRequest)
    }
    
    private func setupIndicator() {
        indicatorView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: self.frame.width, height: self.frame.height)))
        indicatorView.backgroundColor = .black
        indicatorView.alpha = 0.5
        self.addSubview(indicatorView)
        
        indicator.center = self.center
        indicator.color = .white
        indicatorView.addSubview(indicator)
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
    }
    
    private func hideIndicator() {
        indicatorView.isHidden = true
        indicator.stopAnimating()
    }
    
    @IBAction func bigSumAction(_ sender: UIButton) {
        purchase(productIdenty: "com.witplex.PreSchoolMath.yearly")
        setupIndicator()
    }
    
    @IBAction func smallSumAction(_ sender: UIButton) {
        purchase(productIdenty: "com.witplex.PreSchoolMath.monthly")
        setupIndicator()
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
        delegate?.push()
    }
    
    @IBAction func privacyAction(_ sender: UIButton) {
        let urlString = "https://www.witplex.com/PreMathGame/PrivacyPolicy"
        let url = URL(string: urlString)
        UIApplication.shared.openURL(url!)
    }
    
    @IBAction func termsAction(_ sender: UIButton) {
        let urlString = "https://www.witplex.com/PreMathGame/TermOfUse"
        let url = URL(string: urlString)
        UIApplication.shared.openURL(url!)
    }
    
    @IBAction func restoreAction(_ sender: UIButton) {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

extension PurchasingCollectionCell: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        self.myProduct = response.products
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        switch transactions.first?.transactionState {
        case .purchasing:
            break
        case .purchased:
            // unlock
//            AnalyticService.shared.setupAmplitudePurchased()
            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.paymentKey)
            SKPaymentQueue.default().finishTransaction(transactions.first!)
            SKPaymentQueue.default().remove(self)
            hideIndicator()
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
            
            delegate?.push()
            
            break
        case .failed:
            self.hideIndicator()
            break
        case .restored:
            break
        default:
            break
        }
    }
}
