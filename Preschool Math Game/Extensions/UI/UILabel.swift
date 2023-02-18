//
//  UILabel.swift
//  Preschool Math Game
//
//  Created by Armen Gasparyan on 22.12.21.
//

import UIKit

@IBDesignable extension UILabel {
    @IBInspectable var adjustsText: Bool {
        get { return adjustsFontSizeToFitWidth }
        set { adjustsFontSizeToFitWidth = newValue }
    }
}

extension UILabel {
    func animateText() {
        UIView.animate(withDuration: 0.1, animations: {() -> Void in
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: {(_ finished: Bool) -> Void in
            if finished {
                UIView.animate(withDuration: 0.4, animations: { [weak self] in
                    self?.transform = CGAffineTransform(scaleX: 2, y: 2)
                    self?.alpha = 0
                    
                    let _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
                        self?.removeFromSuperview()
                    }
                })
            }
        })
    }
    
    func operations(secondOperation: UILabel) {
        let indexArray = [0, 1]
        let shuffleIndex = indexArray.shuffled()
        
        self.tag = shuffleIndex[0]
        secondOperation.tag = shuffleIndex[1]
        
        if self.tag == 1 {
            self.text = "+"
        } else {
            self.text = "-"
        }
        
        if secondOperation.tag == 1 {
            secondOperation.text = "+"
        } else {
            secondOperation.text = "-"
        }
    }
    
    public func setStrokeText(_ text: String) {
        let attrString = NSAttributedString(
            string: text,
            attributes: [
                NSAttributedString.Key.strokeColor: UIColor.textBorderBlue,
                NSAttributedString.Key.foregroundColor: UIColor.titleCream,
                NSAttributedString.Key.strokeWidth: -6.0
            ]
        )
        self.attributedText = attrString
    }
    
}
