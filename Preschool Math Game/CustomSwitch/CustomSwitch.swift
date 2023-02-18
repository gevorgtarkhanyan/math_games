//
//  CostimSwitch.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 21.07.21.
//

import UIKit

@IBDesignable
class UISwitchCustom: UISwitch {
    @IBInspectable var OffTint: UIColor? {
        didSet {
            self.tintColor = OffTint
            self.layer.cornerRadius = 16
            self.backgroundColor = OffTint
        }
    }
}


protocol MySwitchDelegate {
    func MySwitchDidChangeValue(mySwitch: MySwitch)
}

class MySwitch: UIView {

    var delegate: MySwitchDelegate?
    
    var imageSwitch: UIImageView!
    var leftImageView: UIImageView!
    var rightImageView: UIImageView!
    var OnImage: UIImage?
    var OffImage: UIImage?
    var OnColor: UIColor?
    var OffColor: UIColor?
    
    var rotateAnimation: Bool!
    
    var isLayoutSubviews = false
    
    private var isOn: Bool!
    
    var imageSwitchSize = CGSize(width: 40, height: 40)
    
    public var value: Bool {
        return !isOn
    }
    
    var swSpace: CGFloat {
        return frame.height * 0.07
    }
    
    var swHeight: CGFloat {
        return frame.height - swSpace * 2
    }
    
    //MARK: - init
    private func setup(isOn: Bool?, isCorner: Bool?, rotateAnimation: Bool, OnImg: UIImage?, OffImg: UIImage?, OnColor: UIColor?, OffColor: UIColor?) {
        self.clipsToBounds = true
        self.rotateAnimation = rotateAnimation
        self.isOn = isOn ?? true
        self.OnImage = OnImg
        self.OffImage = OffImg
        self.OnColor = OnColor ?? .white
        self.OffColor = OffColor ?? .white
        
        self.backgroundColor = .switchBackground

        let space = self.frame.height * 0.21
        let height = self.frame.height - space * 2
        
        leftImageView = UIImageView(frame: CGRect(x: space, y: space, width: height, height: height))
        leftImageView.image = UIImage(named: "rocketUp")?.withRenderingMode(.alwaysTemplate)
        self.addSubview(leftImageView)
        
        rightImageView = UIImageView(frame: CGRect(x: self.frame.width * 0.5 + space, y: space, width: height, height: height))
        rightImageView.image = UIImage(named: "rocketDown")?.withRenderingMode(.alwaysTemplate)
        self.addSubview(rightImageView)
        
        
        
        if isOn == false {
            imageSwitch = UIImageView(frame: CGRect(x: self.frame.width * 0.5 + swSpace, y: swSpace, width: swHeight, height: swHeight))
//            self.backgroundColor = OffColor
//            imageSwitch.image = OffImg
//            self.backgroundColor = OffColor ?? UIColor.green
        } else {
            imageSwitch = UIImageView(frame: CGRect(x: swSpace, y: swSpace, width: swHeight, height: swHeight))
//            self.backgroundColor = OnColor
//            imageSwitch.image = OnImg
//            self.backgroundColor = OnColor ?? UIColor.lightGray
        }
//        imageSwitch.backgroundColor = UIColor.white
        self.addSubview(imageSwitch)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
        
        if isCorner! {
            self.layer.cornerRadius = self.frame.height / 2
            imageSwitch.layer.cornerRadius = self.frame.height / 2
        }
        
        
        imageSwitch.image = UIImage(named: "thumbRocketUp")
        self.setBorder(with: 1, color: .switchBorder)
        
        imageSwitchSize = imageSwitch.frame.size
        
        
        changeTinte()

        
//        animationSwitcher()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard !isLayoutSubviews else { return }
        isLayoutSubviews.toggle()
        setup(isOn: nil, isCorner: true, rotateAnimation: true, OnImg: nil, OffImg: nil, OnColor: nil, OffColor: nil)
    }
    
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
//        OnImage = UIImage(named: "thumbRocketUp")
//        OffImage = UIImage(named: "thumbRocketDown")
        isOn.toggle()
        print("tap")
        self.animationSwitcher()
    }
    
    private func changeTinte() {
        self.leftImageView.tintColor = .switchBorder//self.isOn ? .white : .switchBorder
        self.rightImageView.tintColor = .switchBorder//self.isOn ? .switchBorder : .white
    }
    
    //MARK: - Set
    public func setOn(isOn: Bool) {
        if isOn != self.isOn {
            self.isOn = isOn
            animationSwitcher()
        } else {
            self.isOn = isOn
        }
    }
    
    //MARK: - Animation
    func animationSwitcher() {
//        self.isUserInteractionEnabled = false
        let angle: CGFloat = !isOn ? .pi / 2 : (.pi / 2) / 180
        let point = isOn ? CGPoint(x: self.swSpace, y: self.swSpace) : CGPoint(x: self.frame.width * 0.5 + self.swSpace , y: self.swSpace)
        UIView.animate(withDuration: 0.5, animations: {
            self.imageSwitch.transform = CGAffineTransform(rotationAngle: angle)
            self.imageSwitch.frame = CGRect(origin: point, size: self.imageSwitchSize)
        }, completion: { (_) in
            self.changeTinte()
        })
        
//        self.isUserInteractionEnabled = true
    }
    
}
