//
//  Model.swift
//  Preschool Math Game
//
//  Created by Armen Gasparyan on 16.12.21.
//

import Foundation
import StoreKit

struct Subscription {
    let product: SKProduct
    let price: Double
    let localizedPrice: String
    
    private var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()

    init(product: SKProduct) {
        self.product = product
        
        if formatter.locale != self.product.priceLocale {
            formatter.locale = self.product.priceLocale
        }
        price = Double(truncating: product.price)
        localizedPrice = product.localizedPrice()
    }
}

class LatestInfo {
    let productId: String
    let expireDate: Double

    init(json: NSDictionary) {
        self.productId = json.value(forKey: "product_id") as? String ?? ""
        self.expireDate = Double(json.value(forKey: "expires_date_ms") as? String ?? "0")! / 1000
    }
}

class PandingInfo {
    let productId: String
    let autoRenewId: String
    let billingRetry: Int
    let grace_period: String
    let autoRenewStatus: String
    
    init(json: NSDictionary) {
        self.productId = json.value(forKey: "product_id") as? String ?? ""
        self.autoRenewId = json.value(forKey: "auto_renew_product_id") as? String ?? ""
        self.billingRetry = json.value(forKey: "is_in_billing_retry_period") as? Int ?? -1
        self.grace_period = json.value(forKey: "auto_renew_product_id") as? String ?? ""
        self.autoRenewStatus = json.value(forKey: "auto_renew_status") as? String ?? ""
        
    }
}

