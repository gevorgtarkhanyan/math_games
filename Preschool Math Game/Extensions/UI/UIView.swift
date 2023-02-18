//
//  UIView.swift
//  Preschool Math Game
//
//  Created by Armen Gasparyan on 22.12.21.
//

import UIKit

extension UIView {
    var globalFrame: CGRect {
        let rootView = UIApplication.shared.keyWindow?.rootViewController?.view
        return self.superview?.convert(self.frame, to: rootView) ?? .zero
    }
    
    func addImageViews(with image: UIImage, at positions: [CGPoint], count: Int, width: CGFloat, height: CGFloat) {
        for i in 0 ..< count {
            let point = positions[i]
            let imageView = UIImageView(frame: CGRect(x: point.x, y: point.y, width: width, height: height))
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            imageView.changeSizeImageWithAnimate()
            addSubview(imageView)
        }
    }
    
    func addView(with view: UIView, at positions: [CGPoint], count: Int, width: CGFloat, height: CGFloat) {
        for i in 0..<count {
            let point = positions[i]
            let view = UIView(frame: CGRect(x: point.x, y: point.y, width: width, height: height))
            view.backgroundColor = .white
            view.alpha = 0.7
            addSubview(view)
        }
    }
    
    //MARK: - Animation
    func animateFromBottom(duration: TimeInterval = 0.5,
                           delay: TimeInterval = 0,
                           point: CGPoint = CGPoint(x: 0, y: 120))
    {
        self.transform = CGAffineTransform(translationX: point.x, y: point.y)
        UIView.animate(withDuration: duration, delay: delay) {
            self.transform = .identity
        }
    }
    
    func animateWithShake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 5, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 5, y: self.center.y))

        self.layer.add(animation, forKey: "position")
    }

    func animateWithShakeLonger() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 12
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 5, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 5, y: self.center.y))

        self.layer.add(animation, forKey: "position")
    }
    
    func changeSizeImageWithAnimate() {
        UIView.animate(withDuration: 0.1, animations: {() -> Void in
            self.transform = CGAffineTransform(scaleX: 0, y: 0)
        }, completion: {(_ finished: Bool) -> Void in
            if finished {
                UIView.animate(withDuration: 0.8, animations: { [weak self] in
                    self?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                })
            }
        })
    }
    
    //MARK: - Layer
    public func setBorder(with: CGFloat = 4, color: UIColor? = nil) {
        layer.borderWidth = with
        layer.borderColor = (color ?? .border).cgColor
    }
    
    public func setCorner(_ radius: CGFloat = 10) {
        layer.cornerRadius = radius
    }
}


