//
//  UICollectionView.swift
//  Preschool Math Game
//
//  Created by Armen Gasparyan on 22.12.21.
//

import UIKit

extension UICollectionView {
    open override var adjustedContentInset: UIEdgeInsets {
        if #available(iOS 11, *) {
            return super.adjustedContentInset
        } else {
            return contentInset
        }
    }
    
}
