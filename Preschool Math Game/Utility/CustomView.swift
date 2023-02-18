//
//  CustomView.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 5/7/21.
//

import UIKit

class CustomView: UIView {
        
    public func drawImages(image: UIImage, view: UIView) {
        let oneElement = Compare.positionForOneElement(view: view)
        let twoElement = Compare.positionForTwoElement(view: view)
        let threeElement = Compare.positionForThreeElement(view: view)
        let fourElement = Compare.positionForFourElement(view: view)
        let fiveElement = Compare.positionForFiveElement(view: view)
        let sixElement = Compare.positionForSixElement(view: view)
        let sevenElement = Compare.positionForSevenElement(view: view)
        let eightElement = Compare.positionForEightElement(view: view)
        let nineElement = Compare.positionForNineElement(view: view)
        let tenElement = Compare.positionForTenElement(view: view)
        
        let count: Int = Random.getRandomIndex(in: 1..<11)
        if count == 1 {
            addImageViews(with: image, at: oneElement, count: count, width: 80, height: 80)
        } else if count == 2 {
            addImageViews(with: image, at: twoElement, count: count, width: 80, height: 80)
        } else if count == 3 {
            addImageViews(with: image, at: threeElement, count: count, width: 60, height: 60)
        } else if count == 4 {
            addImageViews(with: image, at: fourElement, count: count, width: 50, height: 50)
        } else if count == 5 {
            addImageViews(with: image, at: fiveElement, count: count, width: 50, height: 50)
        } else if count == 6 {
            addImageViews(with: image, at: sixElement, count: count, width: 50, height: 50)
        } else if count == 7 {
            addImageViews(with: image, at: sevenElement, count: count, width: 50, height: 50)
        } else if count == 8 {
            addImageViews(with: image, at: eightElement, count: count, width: 50, height: 50)
        } else if count == 9 {
            addImageViews(with: image, at: nineElement, count: count, width: 35, height: 35)
        } else if count == 10 {
            addImageViews(with: image, at: tenElement, count: count, width: 40, height: 40)
        }
    }
}
