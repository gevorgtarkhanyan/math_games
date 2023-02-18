//
//  Date.swift
//  Preschool Math Game
//
//  Created by Armen Gasparyan on 03.02.22.
//

import Foundation

extension Date {
    var yearString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self)
    }
    
    var yesterday: Date? {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)
    }
}
