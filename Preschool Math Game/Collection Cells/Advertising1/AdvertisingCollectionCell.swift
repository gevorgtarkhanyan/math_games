//
//  AdvertisingCollectionCell.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 24.09.21.
//

import UIKit

protocol AdvertisingCollectionCellDelaget: AnyObject {
    func goToPurchase()
}

class AdvertisingCollectionCell: UICollectionViewCell {
    
    weak var delegate: AdvertisingCollectionCellDelaget?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func getStartedAction(_ sender: UIButton) {
        delegate?.goToPurchase()
    }
    
}
