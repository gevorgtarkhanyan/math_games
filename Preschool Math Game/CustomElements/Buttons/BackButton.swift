//
//  BackButton.swift
//  Preschool Math Game
//
//  Created by Armen Gasparyan on 24.02.22.
//

import UIKit

protocol BackButtonDelegate: AnyObject {
    func backTapped()
}

class BackButton: UIButton {
    
    weak private var navigationController: UINavigationController?
    weak var delegate: BackButtonDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        setImage(UIImage(named: "close_icon"), for: .normal)
        addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    
    func setNavigation(_ controller: UINavigationController?) {
        navigationController = controller
    }
    
    @objc func tapped() {
        navigationController?.popViewController(animated: true)
        delegate?.backTapped()
    }
}
