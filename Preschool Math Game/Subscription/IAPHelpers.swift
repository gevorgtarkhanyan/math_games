
import Foundation
import StoreKit
import FirebaseCrashlytics

enum ReceiptURL: String {
    case sandbox = "https://sandbox.itunes.apple.com/verifyReceipt"
    case production = "https://buy.itunes.apple.com/verifyReceipt"
}

final class IAPHelper: NSObject {

    static let sharedInstance = IAPHelper()

    typealias ReceiptData = [String: String]
//    var completionHandler: (() -> Void)?
    var pandingInfo: PandingInfo?

    //MARK: - Receipt Validation
    // Check first by production URL, if failed check error code, if 21007,
    // means that your receipt is from sandbox environment, need to check with sandbox URL
    public func receiptValidation(completion: @escaping (PandingInfo?) -> Void) {
        guard let requestDictionary = getReceiptData() else { completion(nil); return }
        
        do {
            let requestData = try JSONSerialization.data(withJSONObject: requestDictionary)
            if Reachability.isConnectedToNetwork {
                guard let validationProdURL = URL(string: ReceiptURL.production.rawValue) else {
                    completion(nil)
                    debugPrint("Error: No production URL")
                    return
                }
                let prodSession = URLSession(configuration: .default)
                var prodRequest = URLRequest(url: validationProdURL)
                prodRequest.httpMethod = "POST"
                prodRequest.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
                prodSession.uploadTask(with: prodRequest, from: requestData) { (data, response, error) in
                    guard let data = data, error == nil else {
                        completion(nil)
                        debugPrint("the upload task returned an error: \(String(describing: error))")
                        return
                    }
                    UserDefaults.standard.setValue(data, forKey: UserDefaultsKeys.subscriptionData)
                    self.dataHandling(with: data, requestData: requestData, completion: completion)
                }.resume()
            } else {
                guard let data = UserDefaults.standard.value(forKey: UserDefaultsKeys.subscriptionData) as? Data else { completion(nil); return }
                self.dataHandling(with: data, requestData: requestData, completion: completion)
            }
        } catch let error as NSError {
            completion(nil)
            debugPrint("json serialization failed with error: \(error)")
        }
    }

    //MARK: - Data Handling
    private func dataHandling(with data: Data, requestData: Data, completion: @escaping (PandingInfo?) -> Void) {
        do {
            guard let appReceiptJSON = try JSONSerialization.jsonObject(with: data) as? NSDictionary,
                  let status = appReceiptJSON["status"] as? Int64 else {
                completion(nil)
                debugPrint("Failed to cast serialized JSON to Dictionary<String, AnyObject>")
                return
            }
            switch status {
            case 0: // receipt verified in Production
                self.updateSubscription(with: appReceiptJSON, completion: completion)
                
            case 21007: // Means that our receipt is from sandbox environment, need to validate it there instead
                self.sandBoxRequest(from: requestData, completion: completion)
                
            default:
                completion(nil)
                debugPrint("Receipt validation error:", status)
                
            }
        } catch let error as NSError {
            completion(nil)
            debugPrint("json serialization failed with error: \(error)")
        }
    }
    
    private func sandBoxDataHandling(data: Data, completion: @escaping (PandingInfo?) -> Void) {
        do {
            guard let appReceiptJSON = try JSONSerialization.jsonObject(with: data) as? NSDictionary else {
                completion(nil)
                debugPrint("Failed to cast serialized JSON to Dictionary<String, AnyObject>")
                return
            }
            
            self.updateSubscription(with: appReceiptJSON, completion: completion)
        } catch let error as NSError {
            completion(nil)
            debugPrint("json serialization failed with error: \(error)")
        }
    }
    
    //MARK: - SandBox Request
    private func sandBoxRequest(from requestData: Data, completion: @escaping (PandingInfo?) -> Void) {
        if Reachability.isConnectedToNetwork {
            guard let validationSandboxURL = URL(string: ReceiptURL.sandbox.rawValue) else {
                completion(nil)
                debugPrint("Error: No sandbox URL")
                return
            }
            let sandboxSession = URLSession(configuration: .default)
            var sandboxRequest = URLRequest(url: validationSandboxURL)
            sandboxRequest.httpMethod = "POST"
            sandboxRequest.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
            sandboxSession.uploadTask(with: sandboxRequest, from: requestData) { (data, response, error) in
                guard let data = data, error == nil else {
                    completion(nil)
                    debugPrint("the upload task returned an error: \(String(describing: error))")
                    return
                }
                UserDefaults.standard.setValue(data, forKey: UserDefaultsKeys.sandBoxSubscriptionData)
                self.sandBoxDataHandling(data: data, completion: completion)
            }.resume()
        } else if let data = UserDefaults.standard.value(forKey: UserDefaultsKeys.sandBoxSubscriptionData) as? Data {
            sandBoxDataHandling(data: data, completion: completion)
        } else {
            completion(nil)
        }
    }
    
    //MARK: -Receipt Data
    private func getReceiptData() -> ReceiptData? {
        guard let receiptPath = Bundle.main.appStoreReceiptURL?.path, FileManager.default.fileExists(atPath: receiptPath),
              let appStoreURL = Bundle.main.appStoreReceiptURL else { return nil }
        
        var receiptData: NSData?
        do {
            receiptData = try NSData(contentsOf: appStoreURL, options: NSData.ReadingOptions.alwaysMapped)
        } catch {
            debugPrint("ERROR: " + error.localizedDescription)
        }
        
        guard let base64encodedReceipt = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithCarriageReturn) else { return nil }
        let requestDictionary = ["receipt-data": base64encodedReceipt, "password": Constants.shareSecret]
        
        guard JSONSerialization.isValidJSONObject(requestDictionary) else {
            debugPrint("requestDictionary is not valid JSON")
            return nil
        }
        
        return requestDictionary
    }
    
    //MARK: - Receipt Logic
    private func updateSubscription(with appReceiptJSON: NSDictionary, completion: @escaping (PandingInfo?) -> Void) {
        guard let pandingInfo = (appReceiptJSON["pending_renewal_info"] as? [NSDictionary])?.first else {
            completion(nil)
            debugPrint("Failed to cast serialized JSON to Dictionary<String, AnyObject>")
            return
        }
        self.pandingInfo = PandingInfo(json: pandingInfo)
        
        if self.pandingInfo?.productId == UserDefaults.standard.string(forKey: UserDefaultsKeys.subscriptionType) {
            if self.checkExpirationDate(jsonResponse: appReceiptJSON as NSDictionary) {
                UserDefaults.standard.setValue(true, forKey: UserDefaultsKeys.paymentKey)
                completion(self.pandingInfo)
            } else {
                UserDefaults.standard.setValue(false, forKey: UserDefaultsKeys.paymentKey)
                UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.subscriptionType)
                completion(self.pandingInfo)
            }
        } else {
            if self.checkExpirationDate(jsonResponse: appReceiptJSON as NSDictionary) {
                UserDefaults.standard.set(self.pandingInfo?.productId, forKey: UserDefaultsKeys.subscriptionType)
                UserDefaults.standard.setValue(true, forKey: UserDefaultsKeys.paymentKey)
                completion(self.pandingInfo)
            } else {
                UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.subscriptionType)
                UserDefaults.standard.setValue(false, forKey: UserDefaultsKeys.paymentKey)
                completion(self.pandingInfo)
            }
        }

            if UserDefaults.standard.string(forKey: UserDefaultsKeys.subscriptionType) == "com.witplex.PreSchoolMath.monthly" {
                Crashlytics.crashlytics().setCustomValue("monthly" as Any, forKey: "subscriptionType")
            } else if UserDefaults.standard.string(forKey: UserDefaultsKeys.subscriptionType) == "com.witplex.PreSchoolMath.yearly" {
                Crashlytics.crashlytics().setCustomValue("yearly" as Any, forKey: "subscriptionType")
            }
    }

//    private func checkExpirationDate(jsonResponse: NSDictionary) -> Bool {
//        guard let info: NSArray = jsonResponse["latest_receipt_info"] as? NSArray,
//              let last = info.firstObject as? NSDictionary,
//              let expireString = last["expires_date_ms"] as? String,
//              let expireMiliseconds = Double(expireString) else { return false }
//
//        let current = Date().timeIntervalSince1970
//        let expire = TimeInterval(expireMiliseconds / 1000)
//        return expire > current
//    }
    
    private func checkExpirationDate(jsonResponse: NSDictionary) -> Bool {
        guard let info = jsonResponse["latest_receipt_info"] as? [NSDictionary] else { return false }
 
        let current = Date().timeIntervalSince1970 * 1000
        var mss = [Double]()

        for data in info {
            if let expireString = data["expires_date_ms"] as? String, let expireMiliseconds = Double(expireString) {
                mss.append(expireMiliseconds)
            }
        }

        return mss.contains(where: { $0 > current })
    }
    
}
