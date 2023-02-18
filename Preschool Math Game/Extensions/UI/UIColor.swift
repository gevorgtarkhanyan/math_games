//
//  UIColor.swift
//  Preschool Math Game
//
//  Created by Armen Gasparyan on 23.02.22.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension UIColor {
    class var border: UIColor {
        return UIColor(red: 191, green: 50, blue: 56)
    }
    
    class var switchBorder: UIColor {
        return UIColor(red: 120, green: 169, blue: 65)
    }
    
    class var switchBackground: UIColor {
        return UIColor(red: 235, green: 227, blue: 183)
    }
    
    class var borderBlue: UIColor {
        return UIColor(red: 0.471, green: 0.745, blue: 0.847, alpha: 1)
    }
    
    class var textBorderBlue: UIColor {
        return UIColor(red: 73, green: 151, blue: 202)
    }
    
    class var cellRed: UIColor {
        return UIColor(red: 0.875, green: 0.435, blue: 0.471, alpha: 1)
    }
    
    class var prize1: UIColor {
        return UIColor(red: 1, green: 0.765, blue: 0.275, alpha: 1)
    }
    
    class var prize2: UIColor {
        return UIColor(red: 0.612, green: 0.612, blue: 0.612, alpha: 1)
    }
    
    class var prize3: UIColor {
        return UIColor(red: 0.843, green: 0.604, blue: 0.247, alpha: 1)
    }
    
    class var losePrize: UIColor {
        return UIColor(red: 0.749, green: 0.196, blue: 0.22, alpha: 1)
    }
    
    class var backgroundCream: UIColor {
        return UIColor(red: 0.988, green: 0.976, blue: 0.933, alpha: 1)
    }
    
    class var titleCream: UIColor {
        return UIColor(red: 249, green: 245, blue: 224)
    }
    
}
