//
//  BorderView.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 5/11/21.
//

import UIKit

class BorderView: UIView {
    
    var borderColor = UIColor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    private func configureView() {
        self.layer.borderWidth = 3
        self.layer.borderColor = #colorLiteral(red: 0.7490196078, green: 0.1882352941, blue: 0.2156862745, alpha: 1)
        self.layer.cornerRadius = 15
    }
    
    public func drawImages(image: UIImage, imagesCount: [Int], view: UIView) {
        let oneWidth = view.frame.width / 5
        let twoWidth = view.frame.width / 4
        let threeWidth = view.frame.width / 5
        let fourWidth = view.frame.width / 5
        let fiveWidth = view.frame.width / 5 - 5
        let sixWidth = view.frame.width / 6
        let sevenWidth = view.frame.width / 7 - 5
        let eightWidth = view.frame.width / 8
        let nineWidth = view.frame.width / 9 - 1
        let tenWidth = view.frame.width / 10
        
        let oneElement = Counting_1.positionForOneElement(view: view, spacing: oneWidth)
        let twoElement = Counting_1.positionForTwoElement(view: view, spacing: twoWidth)
        let threeElement = Counting_1.positionForThreeElement(view: view, spacing: threeWidth)
        let foureElement = Counting_1.positionForFoureElement(view: view, spacing: fourWidth)
        let fiveElement = Counting_1.positionForFiveElement(view: view, spacing: fiveWidth)
        let sixElement = Counting_1.positionForSixElement(view: view, spacing: sixWidth)
        let sevenElement = Counting_1.positionForSevenElement(view: view, spacing: sevenWidth)
        let eightElement = Counting_1.positionForEightElement(view: view, spacing: eightWidth)
        let nineElement = Counting_1.positionForNineElement(view: view, spacing: nineWidth)
        let tenElement = Counting_1.positionForTenElement(view: view, spacing: tenWidth)
        let count: Int = Random.getRandomIndex(in: 1..<11, ignoredIndexes: imagesCount)
        if count == 1 {
            addImageViews(with: image, at: oneElement, count: count, width: oneWidth, height: 60)
        } else if count == 2 {
            addImageViews(with: image, at: twoElement, count: count, width: twoWidth, height: 60)
        } else if count == 3 {
            addImageViews(with: image, at: threeElement, count: count, width: threeWidth, height: 60)
        } else if count == 4 {
            addImageViews(with: image, at: foureElement, count: count, width: fourWidth, height: 60)
        } else if count == 5 {
            addImageViews(with: image, at: fiveElement, count: count, width: fiveWidth, height: 60)
        } else if count == 6 {
            addImageViews(with: image, at: sixElement, count: count, width: sixWidth, height: 60)
        } else if count == 7 {
            addImageViews(with: image, at: sevenElement, count: count, width: sevenWidth, height: 60)
        } else if count == 8 {
            addImageViews(with: image, at: eightElement, count: count, width: eightWidth, height: 60)
        } else if count == 9 {
            addImageViews(with: image, at: nineElement, count: count, width: nineWidth, height: 60)
        } else if count == 10 {
            addImageViews(with: image, at: tenElement, count: count, width: tenWidth, height: 60)
        }
    }
}
