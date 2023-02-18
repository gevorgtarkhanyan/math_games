//
//  ImagePositions.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 5/7/21.
//

import UIKit

class Counting_1 {
    static func positionForOneElement(view: UIView, spacing: CGFloat) -> [CGPoint] {
        let x = (view.frame.width / 2) - spacing / 2
        let y = view.frame.height / 2 - 30
        return [CGPoint(x: x, y: y)]
    }
    
    static func positionForTwoElement(view: UIView, spacing: CGFloat) -> [CGPoint] {
        let x_1 = (view.frame.width / 2) - (spacing * 1.1)
        let x_2 = (view.frame.width / 2) + (spacing / 9)
        let y = view.frame.height / 2 - 30
        return [CGPoint(x: x_1, y: y), CGPoint(x: x_2, y: y)]
    }
    
    static func positionForThreeElement(view: UIView, spacing: CGFloat) -> [CGPoint] {
        let x_1 = (view.frame.width / 2) - spacing / 2
        let x_2 = (view.frame.width / 2) - (spacing + (spacing / 2))
        let x_3 = (view.frame.width / 2) + (spacing / 2)
        let y = view.frame.height / 2 - 30
        return [CGPoint(x: x_1, y: y), CGPoint(x: x_2, y: y), CGPoint(x: x_3, y: y)]
    }
    
    static func positionForFoureElement(view: UIView, spacing: CGFloat) -> [CGPoint] {
        let x_1 = (view.frame.width / 2) - (spacing * 2 / 2.1)
        let x_2 = (view.frame.width / 2) - (spacing * 2.5 / 1.3)
        let x_3 = (view.frame.width / 2)
        let x_4 = (view.frame.width / 2) + (spacing / 1.06)
        let y = view.frame.height / 2 - 30
        return [CGPoint(x: x_1, y: y), CGPoint(x: x_2, y: y), CGPoint(x: x_3, y: y), CGPoint(x: x_4, y: y)]
    }
    
    static func positionForFiveElement(view: UIView, spacing: CGFloat) -> [CGPoint] {
        let x_1 = (view.frame.width / 2) - (spacing / 2)
        let x_2 = (view.frame.width / 2) - (spacing + (spacing / 2))
        let x_3 = (view.frame.width / 2) - (spacing * 2 + (spacing / 2))
        let x_4 = (view.frame.width / 2) + (spacing / 2)
        let x_5 = view.frame.width / 2 + (spacing + (spacing / 2))
        let y = view.frame.height / 2 - 30
        return [CGPoint(x: x_1, y: y), CGPoint(x: x_2, y: y), CGPoint(x: x_3, y: y), CGPoint(x: x_4, y: y), CGPoint(x: x_5, y: y)]
    }
    
    static func positionForSixElement(view: UIView, spacing: CGFloat) -> [CGPoint] {
        let x_1 = (view.frame.width / 2) - (spacing * 2 / 2.1)
        let x_2 = (view.frame.width / 2) - (spacing * 2.5 / 1.3)
        let x_3 = (view.frame.width / 2) - (spacing * 2.9)
        let x_4 = (view.frame.width / 2)
        let x_5 = (view.frame.width / 2) + (spacing / 1.06)
        let x_6 = view.frame.width / 2 + (spacing / 0.53)
        let y = (view.frame.height / 2) - 30
        return [CGPoint(x: x_1, y: y), CGPoint(x: x_2, y: y), CGPoint(x: x_3, y: y), CGPoint(x: x_4, y: y), CGPoint(x: x_5, y: y), CGPoint(x: x_6, y: y)]
    }
    
    static func positionForSevenElement(view: UIView, spacing: CGFloat) -> [CGPoint] {
        let x_1 = (view.frame.width / 2) - (spacing / 2)
        let x_2 = (view.frame.width / 2) - (spacing + (spacing / 2))
        let x_3 = (view.frame.width / 2) - (spacing * 2 + (spacing / 2))
        let x_4 = (view.frame.width / 2) - (spacing * 3 + (spacing / 2))
        let x_5 = (view.frame.width / 2) + (spacing / 2)
        let x_6 = view.frame.width / 2 + (spacing + (spacing / 2))
        let x_7 = view.frame.width / 2 + (spacing * 2.5)
        let y = view.frame.height / 2 - 30
        return [CGPoint(x: x_1, y: y), CGPoint(x: x_2, y: y), CGPoint(x: x_3, y: y), CGPoint(x: x_4, y: y), CGPoint(x: x_5, y: y), CGPoint(x: x_6, y: y), CGPoint(x: x_7, y: y)]
    }
    
    static func positionForEightElement(view: UIView, spacing: CGFloat) -> [CGPoint] {
        let x_1 = (view.frame.width / 2) - (spacing * 2 / 2.08)
        let x_2 = (view.frame.width / 2) - (spacing * 2.5 / 1.3)
        let x_3 = (view.frame.width / 2) - (spacing * 2.9)
        let x_4 = (view.frame.width / 2) - (spacing * 3.9)
        let x_5 = (view.frame.width / 2)
        let x_6 = (view.frame.width / 2) + (spacing / 1.06)
        let x_7 = view.frame.width / 2 + (spacing / 0.52)
        let x_8 = view.frame.width / 2 + (spacing * 2.9)
        let y = view.frame.height / 2 - 30
        return [CGPoint(x: x_1, y: y), CGPoint(x: x_2, y: y), CGPoint(x: x_3, y: y), CGPoint(x: x_4, y: y), CGPoint(x: x_5, y: y), CGPoint(x: x_6, y: y), CGPoint(x: x_7, y: y), CGPoint(x: x_8, y: y)]
    }
    
    static func positionForNineElement(view: UIView, spacing: CGFloat) -> [CGPoint] {
        let x_1 = (view.frame.width / 2) - (spacing / 2)
        let x_2 = (view.frame.width / 2) - (spacing + (spacing / 2.1))
        let x_3 = (view.frame.width / 2) - (spacing * 2 + (spacing / 2.1))
        let x_4 = (view.frame.width / 2) - (spacing * 3 + (spacing / 2.1))
        let x_5 = (view.frame.width / 2) - (spacing * 3 + (spacing / 0.69))
        let x_6 = (view.frame.width / 2) + (spacing / 2)
        let x_7 = view.frame.width / 2 + (spacing + (spacing / 2))
        let x_8 = view.frame.width / 2 + (spacing * 2.5)
        let x_9 = view.frame.width / 2 + (spacing * 3.5)
        let y = view.frame.height / 2 - 30
        return [CGPoint(x: x_1, y: y), CGPoint(x: x_2, y: y), CGPoint(x: x_3, y: y), CGPoint(x: x_4, y: y), CGPoint(x: x_5, y: y), CGPoint(x: x_6, y: y), CGPoint(x: x_7, y: y), CGPoint(x: x_8, y: y), CGPoint(x: x_9, y: y)]
    }
    
    static func positionForTenElement(view: UIView, spacing: CGFloat) -> [CGPoint] {
        let x_1 = (view.frame.width / 2) - (spacing * 2 / 2.08)
        let x_2 = (view.frame.width / 2) - (spacing * 2.5 / 1.3)
        let x_3 = (view.frame.width / 2) - (spacing * 2.9)
        let x_4 = (view.frame.width / 2) - (spacing * 3.9)
        let x_5 = (view.frame.width / 2) - (spacing * 4.9)
        let x_6 = (view.frame.width / 2)
        let x_7 = (view.frame.width / 2) + (spacing / 1.06)
        let x_8 = view.frame.width / 2 + (spacing / 0.52)
        let x_9 = view.frame.width / 2 + (spacing * 2.9)
        let x_10 = view.frame.width / 2 + (spacing * 3.9)
        let y = view.frame.height / 2 - 30
        return [CGPoint(x: x_1, y: y), CGPoint(x: x_2, y: y), CGPoint(x: x_3, y: y), CGPoint(x: x_4, y: y), CGPoint(x: x_5, y: y), CGPoint(x: x_6, y: y), CGPoint(x: x_7, y: y), CGPoint(x: x_8, y: y), CGPoint(x: x_9, y: y), CGPoint(x: x_10, y: y)]
    }
}

class AddingFunPositions {
    
    static func positionForOneElement(view: UIView) -> [CGPoint] {
        let x = view.frame.width / 2 - 50
        let y = view.frame.height / 2 - 50
        return [CGPoint(x: x, y: y)]
    }
    
    static func positionForTwoElement(view: UIView) -> [CGPoint] {
        let x = view.frame.width / 2 - 40
        let y_1 = view.frame.minY + 15
        let y_2 = view.frame.maxY - 95
        return [CGPoint(x: x, y: y_1), CGPoint(x: x, y: y_2)]
    }
    
    static func positionForThreeElement(view: UIView) -> [CGPoint] {
        let x_1 = view.frame.width / 2 - 60
        let x_2 = view.frame.width / 2 + 15
        let y_1 = view.frame.minY + 20
        let y_2 = view.frame.maxY - 80
        let y_3 = view.center.y - 30
        return [CGPoint(x: x_1, y: y_1), CGPoint(x: x_1, y: y_2), CGPoint(x: x_2, y: y_3)]
    }
    
    static func positionForFourElement(view: UIView) -> [CGPoint] {
        let x_1 = view.frame.width / 2 - 70
        let x_2 = view.frame.width / 2 + 20
        let y_1 = view.frame.minY + 35
        let y_2 = view.frame.maxY - 85
        
        return [CGPoint(x: x_1, y: y_1), CGPoint(x: x_2, y: y_1), CGPoint(x: x_1, y: y_2), CGPoint(x: x_2, y: y_2)]
    }
    
    static func positionForFiveElement(view: UIView) -> [CGPoint] {
        let x_1 = view.frame.width / 2 - 70
        let x_2 = view.frame.width / 2 + 20
        let y_1 = view.frame.minY + 20
        let y_2 = view.frame.height / 2 - 25
        let y_3 = view.frame.maxY - 70
        let y_4 = view.frame.height / 2 - 55
        let y_5 = view.frame.height / 2 + 5
        
        return [CGPoint(x: x_1, y: y_1), CGPoint(x: x_1, y: y_2), CGPoint(x: x_1, y: y_3), CGPoint(x: x_2, y: y_4), CGPoint(x: x_2, y: y_5)]
    }
}

class SubtractingFunPositions {
    
    static func positionForOneElement(view: UIView) -> [CGPoint] {
        let x = view.frame.width / 2 - 50
        let y = view.frame.height / 2 - 50
        return [CGPoint(x: x, y: y)]
    }
    
    static func positionForTwoElement(view: UIView) -> [CGPoint] {
        let x_1 = view.frame.width / 2 - 110
        let x_2 = view.frame.width / 2 + 10
        let y = view.frame.height / 2 - 50
        return [CGPoint(x: x_1, y: y), CGPoint(x: x_2, y: y)]
    }
    
    static func positionForThreeElement(view: UIView) -> [CGPoint] {
        let x_1 = view.frame.width / 2 - 130
        let x_2 = view.frame.width / 2 + 30
        let y_1 = view.frame.height / 2 - 100
        
        let x_3 = view.frame.width / 2 - 50
        let y_2 = view.frame.height / 2 - 15
        return [CGPoint(x: x_1, y: y_1), CGPoint(x: x_2, y: y_1), CGPoint(x: x_3, y: y_2)]
    }
    
    static func positionForFoureElement(view: UIView) -> [CGPoint] {
        let x_1 = view.frame.width / 2 - 110
        let x_2 = view.frame.width / 2 + 10
        let y_1 = view.frame.height / 2 - 100
        let y_2 = view.frame.height / 2
        return [CGPoint(x: x_1, y: y_1), CGPoint(x: x_2, y: y_1), CGPoint(x: x_1, y: y_2), CGPoint(x: x_2, y: y_2)]
    }
    
    static func positionForFiveElement(view: UIView) -> [CGPoint] {
        let x_1 = view.frame.width / 2 - 45
        let x_2 = view.frame.width / 2 - 145
        let x_3 = view.frame.width / 2 + 55
        let y_1 = view.frame.height / 2 - 90
        
        let x_4 = view.frame.width / 2 - 95
        let x_5 = view.frame.width / 2 + 5
        let y_2 = view.frame.height / 2
        return [CGPoint(x: x_1, y: y_1), CGPoint(x: x_2, y: y_1), CGPoint(x: x_3, y: y_1), CGPoint(x: x_4, y: y_2), CGPoint(x: x_5, y: y_2)]
    }
    
    static func positionForSixElement(view: UIView) -> [CGPoint] {
        let x_1 = view.frame.width / 2 - 45
        let x_2 = view.frame.width / 2 - 145
        let x_3 = view.frame.width / 2 + 55
        let y_1 = view.frame.height / 2 - 90
        let y_2 = view.frame.height / 2
        return [CGPoint(x: x_1, y: y_1), CGPoint(x: x_2, y: y_1), CGPoint(x: x_3, y: y_1), CGPoint(x: x_1, y: y_2), CGPoint(x: x_2, y: y_2), CGPoint(x: x_3, y: y_2)]
    }
    
    static func positionForSevenElement(view: UIView) -> [CGPoint] {
        let x_1 = view.frame.width / 2 - 35
        let x_2 = view.frame.width / 2 - 115
        let x_3 = view.frame.width / 2 + 45
        let y_1 = view.frame.height / 2 - 80
        
        let x_4 = view.frame.width / 2 - 75
        let x_5 = view.frame.width / 2 - 155
        let x_6 = view.frame.width / 2 + 5
        let x_7 = view.frame.width / 2 + 85
        let y_2 = view.frame.height / 2 + 10
        return [CGPoint(x: x_1, y: y_1), CGPoint(x: x_2, y: y_1), CGPoint(x: x_3, y: y_1), CGPoint(x: x_4, y: y_2), CGPoint(x: x_5, y: y_2), CGPoint(x: x_6, y: y_2), CGPoint(x: x_7, y: y_2)]
    }
    
    static func positionForEightElement(view: UIView) -> [CGPoint] {
        let x_1 = view.frame.width / 2 - 75
        let x_2 = view.frame.width / 2 - 155
        let x_3 = view.frame.width / 2 + 5
        let x_4 = view.frame.width / 2 + 85
        
        let y_1 = view.frame.height / 2 - 80
        let y_2 = view.frame.height / 2 + 10
        return [CGPoint(x: x_1, y: y_1), CGPoint(x: x_2, y: y_1), CGPoint(x: x_3, y: y_1), CGPoint(x: x_4, y: y_1), CGPoint(x: x_1, y: y_2), CGPoint(x: x_2, y: y_2), CGPoint(x: x_3, y: y_2), CGPoint(x: x_4, y: y_2)]
    }
    
    static func positionForNineElement(view: UIView) -> [CGPoint] {
        let x_1 = view.frame.width / 2 - 53.5
        let x_2 = view.frame.width / 2 - 110.5
        let x_3 = view.frame.width / 2 + 3.5
        let x_4 = view.frame.width / 2 + 60.5
        
        let x_5 = view.frame.width / 2 - 25
        let x_6 = view.frame.width / 2 - 82
        let x_7 = view.frame.width / 2 - 139
        let x_8 = view.frame.width / 2 + 32
        let x_9 = view.frame.width / 2 + 89
        
        let y_1 = view.frame.height / 2 - 70
        let y_2 = view.frame.height / 2 + 10
        return [CGPoint(x: x_1, y: y_1), CGPoint(x: x_2, y: y_1), CGPoint(x: x_3, y: y_1), CGPoint(x: x_4, y: y_1), CGPoint(x: x_5, y: y_2), CGPoint(x: x_6, y: y_2), CGPoint(x: x_7, y: y_2), CGPoint(x: x_8, y: y_2), CGPoint(x: x_9, y: y_2)]
    }
    
    static func positionForTenElement(view: UIView) -> [CGPoint] {
        let x_1 = view.frame.width / 2 - 25
        let x_2 = view.frame.width / 2 - 82
        let x_3 = view.frame.width / 2 - 139
        let x_4 = view.frame.width / 2 + 32
        let x_5 = view.frame.width / 2 + 89
        
        let y_1 = view.frame.height / 2 - 70
        let y_2 = view.frame.height / 2 + 10
        return [CGPoint(x: x_1, y: y_1), CGPoint(x: x_2, y: y_1), CGPoint(x: x_3, y: y_1), CGPoint(x: x_4, y: y_1), CGPoint(x: x_5, y: y_1), CGPoint(x: x_1, y: y_2), CGPoint(x: x_2, y: y_2), CGPoint(x: x_3, y: y_2), CGPoint(x: x_4, y: y_2), CGPoint(x: x_5, y: y_2)]
    }
}

class Compare {
    
    static func positionForOneElement(view: UIView) -> [CGPoint] {
        let x = view.frame.width / 2 - 40
        let y = view.frame.height / 2 - 40
        return [CGPoint(x: x, y: y)]
    }
    
    static func positionForTwoElement(view: UIView) -> [CGPoint] {
        let x = view.frame.width / 2 - 40
        let y_1 = view.frame.minY * 0 + 30
        let y_2 = view.frame.maxY - 140
        return [CGPoint(x: x, y: y_1), CGPoint(x: x, y: y_2)]
    }
    
    static func positionForThreeElement(view: UIView) -> [CGPoint] {
        let x_1 = view.frame.width / 2 - 30
        let y_1 = view.frame.height / 2 - 25
        let y_2 = view.frame.maxY - 120
        let y_3 = view.frame.minY * 0 + 20
        return [CGPoint(x: x_1, y: y_1), CGPoint(x: x_1, y: y_2), CGPoint(x: x_1, y: y_3)]
    }
    
    static func positionForFourElement(view: UIView) -> [CGPoint] {
        let x_1 = view.frame.width / 2 - 25
        let y_1 = view.frame.height / 2 - 115
        let y_2 = view.frame.height / 2 - 50
        let y_3 = view.frame.height / 2 + 18
        let y_4 = view.frame.height / 2 + 80
        
        return [CGPoint(x: x_1, y: y_1), CGPoint(x: x_1, y: y_2), CGPoint(x: x_1, y: y_3), CGPoint(x: x_1, y: y_4)]
    }
    
    static func positionForFiveElement(view: UIView) -> [CGPoint] {
        let x_1 = view.frame.width / 2 - 55
        let y_1 = view.frame.minY * 0 + 20
        let y_2 = view.frame.maxY - 105
        let y_3 = view.frame.height / 2 - 20
        
        let x_2 = view.frame.width / 2 + 5
        let y_4 = view.frame.height / 2 - 55
        let y_5 = view.frame.height / 2 + 25
        return [CGPoint(x: x_1, y: y_1), CGPoint(x: x_1, y: y_2), CGPoint(x: x_1, y: y_3), CGPoint(x: x_2, y: y_4), CGPoint(x: x_2, y: y_5)]
    }
    
    static func positionForSixElement(view: UIView) -> [CGPoint] {
        let x_1 = view.frame.width / 2 - 50
        let y_1 = view.frame.height / 2 - 110
        let y_2 = view.frame .height / 2 - 40
        let y_3 = view.frame.height / 2 + 30
        
        let x_2 = view.frame.width / 2
        let y_4 = view.frame.height / 2 - 70
        let y_5 = view.frame.height / 2
        let y_6 = view.frame.height / 2 + 70
        return [CGPoint(x: x_1, y: y_1), CGPoint(x: x_1, y: y_2), CGPoint(x: x_1, y: y_3), CGPoint(x: x_2, y: y_4), CGPoint(x: x_2, y: y_5), CGPoint(x: x_2, y: y_6)]
    }
    
    static func positionForSevenElement(view: UIView) -> [CGPoint] {
        let x_1 = view.frame.width / 2 + 4
        let y_1 = view.frame.height / 2 - 115
        let y_2 = view.frame.height / 2 - 50
        let y_3 = view.frame.height / 2 + 18
        let y_4 = view.frame.height / 2 + 80
        
        let x_2 = view.frame.width / 2 - 54
        let y_5 = view.frame.height / 2 - 80
        let y_6 = view.frame.height / 2 - 10
        let y_7 = view.frame.height / 2 + 60
        
        return [CGPoint(x: x_1, y: y_1), CGPoint(x: x_1, y: y_2), CGPoint(x: x_1, y: y_3), CGPoint(x: x_1, y: y_4), CGPoint(x: x_2, y: y_5), CGPoint(x: x_2, y: y_6), CGPoint(x: x_2, y: y_7)]
    }
    
    static func positionForEightElement(view: UIView) -> [CGPoint] {
        let x_1 = view.frame.width / 2 - 55
        let x_2 = view.frame.width / 2 + 2
        let y_1 = view.frame.height / 2 - 115
        let y_2 = view.frame.height / 2 - 50
        let y_3 = view.frame.height / 2 + 18
        let y_4 = view.frame.height / 2 + 80
        return [CGPoint(x: x_1, y: y_1), CGPoint(x: x_1, y: y_2), CGPoint(x: x_1, y: y_3), CGPoint(x: x_1, y: y_4), CGPoint(x: x_2, y: y_1), CGPoint(x: x_2, y: y_2),CGPoint(x: x_2, y: y_3), CGPoint(x: x_2, y: y_4)]
    }
    
    static func positionForNineElement(view: UIView) -> [CGPoint] {
        let x_1 = view.frame.width / 2 - 41
        let x_2 = view.frame.width / 2 + 5
        let x_3 = view.frame.width / 2 - 58
        let x_4 = view.frame.width / 2 + 22
        let x_5 = view.frame.width / 2 - 17.5
        let y_1 = view.frame.height / 2 - 95
        let y_2 = view.frame.height / 2 - 40
        let y_3 = view.frame.height / 2 + 15
        let y_4 = view.frame.height / 2 + 68
        return [CGPoint(x: x_1, y: y_1), CGPoint(x: x_1, y: y_2), CGPoint(x: x_1, y: y_3), CGPoint(x: x_2, y: y_1), CGPoint(x: x_2, y: y_2), CGPoint(x: x_2, y: y_3),CGPoint(x: x_3, y: y_4), CGPoint(x: x_4, y: y_4), CGPoint(x: x_5, y: y_4)]
    }
    
    static func positionForTenElement(view: UIView) -> [CGPoint] {
        let x_1 = view.frame.width / 2 - 45
        let x_2 = view.frame.width / 2 + 5
        let y_1 = view.frame.height / 2 - 115
        let y_2 = view.frame.height / 2 - 63
        let y_3 = view.frame.height / 2 - 13
        let y_4 = view.frame.height / 2 + 40
        let y_5 = view.frame.height / 2 + 90
        return [CGPoint(x: x_1, y: y_1), CGPoint(x: x_1, y: y_2), CGPoint(x: x_1, y: y_3), CGPoint(x: x_1, y: y_4), CGPoint(x: x_1, y: y_5), CGPoint(x: x_2, y: y_1),CGPoint(x: x_2, y: y_2), CGPoint(x: x_2, y: y_3), CGPoint(x: x_2, y: y_4), CGPoint(x: x_2, y: y_5)]
    }
}

class Counting_2 {
    static func positionForOneElement(view: UIView) -> [CGPoint] {
        let x = view.frame.width / 2 - 50
        let y = view.frame.height / 2 - 50
        return [CGPoint(x: x, y: y)]
    }
    
    static func positionForTwoElement(view: UIView) -> [CGPoint] {
        let x_1 = view.frame.width / 2 - 100
        let x_2 = view.frame.width / 2 + 10
        let y = view.frame.height / 2 - 50
        return [CGPoint(x: x_1, y: y), CGPoint(x: x_2, y: y)]
    }
    
    static func positionForThreeElement(view: UIView) -> [CGPoint] {
        let x_1 = view.frame.width / 2 - 45
        let x_2 = view.frame.width / 2 - 140
        let x_3 = view.frame.width / 2 + 50
        let y = view.frame.height / 2 - 50
        return [CGPoint(x: x_1, y: y), CGPoint(x: x_2, y: y), CGPoint(x: x_3, y: y)]
    }
    
    static func positionForFoureElement(view: UIView) -> [CGPoint] {
        let x_1 = view.frame.width / 2 - 150
        let x_2 = view.frame.width / 2 - 70
        let y_1 = view.frame.height / 2 - 50
        
        let x_3 = view.frame.width / 2 + 10
        let x_4 = view.frame.width / 2 + 90
        let y_2 = view.frame.height / 2 - 20
        return [CGPoint(x: x_1, y: y_1), CGPoint(x: x_2, y: y_2), CGPoint(x: x_3, y: y_1), CGPoint(x: x_4, y: y_2)]
    }
    
    static func positionForFiveElement(view: UIView) -> [CGPoint] {
        let x_1 = view.frame.width / 2 - 40
        let x_2 = view.frame.width / 2 - 120
        let x_3 = view.frame.width / 2 + 40
        let y_1 = view.frame.height / 2 - 80
        
        let x_4 = view.frame.width / 2 - 80
        let x_5 = view.frame.width / 2
        let y_2 = view.frame.height / 2 + 10
        return [CGPoint(x: x_1, y: y_1), CGPoint(x: x_2, y: y_1), CGPoint(x: x_3, y: y_1), CGPoint(x: x_4, y: y_2), CGPoint(x: x_5, y: y_2)]
    }
    
    static func positionForSixElement(view: UIView) -> [CGPoint] {
        let x_1 = view.frame.width / 2 - 40
        let x_2 = view.frame.width / 2 - 120
        let x_3 = view.frame.width / 2 + 40
        let y_1 = view.frame.height / 2 - 80
        let y_2 = view.frame.height / 2 + 10
        return [CGPoint(x: x_1, y: y_1), CGPoint(x: x_2, y: y_1), CGPoint(x: x_3, y: y_1), CGPoint(x: x_1, y: y_2), CGPoint(x: x_2, y: y_2), CGPoint(x: x_3, y: y_2)]
    }
    
    static func positionForSevenElement(view: UIView) -> [CGPoint] {
        let x_1 = view.frame.width / 2 - 40
        let x_2 = view.frame.width / 2 - 120
        let x_3 = view.frame.width / 2 + 40
        let y_1 = view.frame.height / 2 - 80
        
        let x_4 = view.frame.width / 2 - 140
        let x_5 = view.frame.width / 2 - 70
        let x_6 = view.frame.width / 2
        let x_7 = view.frame.width / 2 + 70
        let y_2 = view.frame.height / 2 + 10
        return [CGPoint(x: x_1, y: y_1), CGPoint(x: x_2, y: y_1), CGPoint(x: x_3, y: y_1), CGPoint(x: x_4, y: y_2), CGPoint(x: x_5, y: y_2), CGPoint(x: x_6, y: y_2), CGPoint(x: x_7, y: y_2)]
    }
    
    static func positionForEightElement(view: UIView) -> [CGPoint] {
        let x_1 = view.frame.width / 2 - 140
        let x_2 = view.frame.width / 2 - 70
        let x_3 = view.frame.width / 2
        let x_4 = view.frame.width / 2 + 70
        let y_2 = view.frame.height / 2 + 10
        let y_1 = view.frame.height / 2 - 80
        return [CGPoint(x: x_1, y: y_1), CGPoint(x: x_2, y: y_1), CGPoint(x: x_3, y: y_1), CGPoint(x: x_4, y: y_1), CGPoint(x: x_1, y: y_2), CGPoint(x: x_2, y: y_2), CGPoint(x: x_3, y: y_2), CGPoint(x: x_4, y: y_2)]
    }
    
    static func positionForNineElement(view: UIView) -> [CGPoint] {
        let x_1 = view.frame.width / 2 - 110
        let x_2 = view.frame.width / 2 - 50
        let x_3 = view.frame.width / 2 + 10
        let x_4 = view.frame.width / 2 + 70
        let y_1 = view.frame.height / 2 - 80
        
        let x_5 = view.frame.width / 2 - 140
        let x_6 = view.frame.width / 2 - 80
        let x_7 = view.frame.width / 2 - 20
        let x_8 = view.frame.width / 2 + 40
        let x_9 = view.frame.width / 2 + 100
        let y_2 = view.frame.height / 2 + 10
        return [CGPoint(x: x_1, y: y_1), CGPoint(x: x_2, y: y_1), CGPoint(x: x_3, y: y_1), CGPoint(x: x_4, y: y_1), CGPoint(x: x_5, y: y_2), CGPoint(x: x_6, y: y_2), CGPoint(x: x_7, y: y_2), CGPoint(x: x_8, y: y_2), CGPoint(x: x_9, y: y_2)]
    }
    
    static func positionForTenElement(view: UIView) -> [CGPoint] {
        let x_1 = view.frame.width / 2 - 140
        let x_2 = view.frame.width / 2 - 80
        let x_3 = view.frame.width / 2 - 20
        let x_4 = view.frame.width / 2 + 40
        let x_5 = view.frame.width / 2 + 100
        let y_1 = view.frame.height / 2 - 80
        let y_2 = view.frame.height / 2 + 10
        return [CGPoint(x: x_1, y: y_1), CGPoint(x: x_2, y: y_1), CGPoint(x: x_3, y: y_1), CGPoint(x: x_4, y: y_1), CGPoint(x: x_5, y: y_1), CGPoint(x: x_1, y: y_2), CGPoint(x: x_2, y: y_2), CGPoint(x: x_3, y: y_2), CGPoint(x: x_4, y: y_2), CGPoint(x: x_5, y: y_2)]
    }
}

class Shapes_1 {
    static func positionForOneElement(view: UIView, spacing: CGFloat) -> [CGPoint] {
        let x = (view.frame.width / 2) - spacing / 2
        let y = (view.frame.height / 2) - spacing / 2
        return [CGPoint(x: x, y: y)]
    }
}
