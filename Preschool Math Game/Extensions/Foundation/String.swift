//
//  String.swift
//  Preschool Math Game
//
//  Created by Armen Gasparyan on 02.03.22.
//

import Foundation

extension StringProtocol {
    var digits: [Int] { compactMap(\.wholeNumberValue) }
}

extension String {
    func localized(str: String) -> String {
        
        let path = Bundle.main.path(forResource: str, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        UserDefaults.standard.setValue(str, forKey: UserDefaultsKeys.languageKey)
        
        return NSLocalizedString(self,
                                 tableName: "Localizable",
                                 bundle: bundle!,
                                 value: self,
                                 comment: self)
    }
    
    var getOnlyNumberFromText: String {
        let pattern = UnicodeScalar("0")..."9"
        return String(unicodeScalars
                        .compactMap { pattern ~= $0 ? Character($0) : nil })
    }
    
    mutating func addZero() {
        guard self.count == 1 else { return }
        self = "0" + self
    }
    
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
}
