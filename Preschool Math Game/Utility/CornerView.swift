//
//  CornerView.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 6/15/21.
//

import UIKit

class CornerButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        cornerView()
    }
    
    private func cornerView() {
        self.layer.cornerRadius = 10
    }
}
