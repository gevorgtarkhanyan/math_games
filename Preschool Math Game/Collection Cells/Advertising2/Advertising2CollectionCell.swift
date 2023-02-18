//
//  Advertising2CollectionCell.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 25.09.21.
//

import UIKit

protocol Advertising2CollectionCellDelegate: AnyObject {
    func goToPurchaseing()
}

class Advertising2CollectionCell: UICollectionViewCell {

    weak var delegate: Advertising2CollectionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBAction func getStartedAction(_ sender: UIButton) {
        delegate?.goToPurchaseing()
    }
    
}
