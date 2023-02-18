//
//  Extensions.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 5/7/21.
//

import UIKit
import StoreKit

extension Array where Element: UIView {
    func animateFromBottom(delay: TimeInterval = 0.1, point: CGPoint = CGPoint(x: 0, y: 0)) {
        for (index, view) in self.enumerated() {
            view.animateFromBottom(delay: Double(index) * delay, point: point)
        }
    }
}

//MARK: - Double
extension Double {
    func formatWithCurrency() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.formatterBehavior = .behavior10_4
        
        return formatter.string(from: NSNumber(value: self))
    }
    
    func getString() -> String {
        guard !self.isNaN else { return "0" }
        
        var doubleString = String(self)
        var largeNumber = self
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        if self < 1 && self != 0 && self > -1 {
            doubleString = String(format: "%f", self)
            numberFormatter.maximumFractionDigits = 6
            //for the small number 2.1e-14
            if numberFormatter.string(from: NSNumber(value: largeNumber)) == "0" {
                largeNumber = largeNumber > 0 ? 0.000001 : -0.000001
            } else {
                largeNumber = Double(doubleString) ?? self
            }
        }
        
        if let str = numberFormatter.string(from: NSNumber(value: largeNumber)) {
            doubleString = str
        }
        return doubleString
    }
}

extension Int {
    func toHoursMinutesSeconds() -> (Int, Int, Int) {
        return (self / 3600, (self % 3600) / 60, (self % 3600) % 60)
    }
    
    func toHoursMinutesSeconds() -> String {
        var hours = String(self / 3600)
        var minutes = String((self % 3600) / 60)
        var seconds = String((self % 3600) % 60)
        hours.addZero()
        minutes.addZero()
        seconds.addZero()
        return "\(hours) \(minutes) \(seconds)"
    }
    
    func toString() -> String {
        return String(self)
    }
}

extension Bool {
    public var intValue: Int {
        return self ? 1 : 0
    }
}

//MARK: - SKProduct
extension SKProduct {
    func localizedPrice() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.priceLocale
        return formatter.string(from: self.price) ?? ""
    }

//    func getDurationWithPrice() -> String {
//        if productIdentifier.lowercased().contains("month") {
//            return "monthly".localized() + " " + localizedPrice()
//        } else if productIdentifier.lowercased().contains("year") {
//            return "yearly".localized() + " " + localizedPrice()
//        } else if productIdentifier.lowercased().contains("week") {
//            return "weekly".localized() + " " + localizedPrice()
//        }
//
//        return localizedPrice()
//    }
}

extension UIApplication {
    class func appVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
  
    class func appBuild() -> String {
        return Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as? String ?? ""
    }
  
    class func versionBuild() -> String {
        let version = appVersion(), build = appBuild()
      
        return version == build ? "v\(version)" : "v\(version)(\(build))"
    }
}

extension RangeReplaceableCollection {
    /// Returns a new Collection shuffled
    var shuffled: Self { .init(shuffled()) }
    /// Shuffles this Collection in place
//    @discardableResult
//    mutating func shuffledInPlace() -> Self  {
//        self = shuffled
//        return self
//    }
    func choose(_ n: Int) -> [Element] { shuffled.prefix(n).map { $0 } }
}


extension UIFont {
    func withWeight(_ weight: UIFont.Weight) -> UIFont {
        let newDescriptor = fontDescriptor.addingAttributes([.traits: [UIFontDescriptor.TraitKey.weight: weight]])
        return UIFont(descriptor: newDescriptor, size: pointSize)
    }
}
