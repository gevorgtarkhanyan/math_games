//
//  ImageCollectionViewCell.swift
//  Preschool Math Game
//
//  Created by Taron Saribekyan on 02.09.22.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectionImageView: UIImageView!
    @IBOutlet weak var hiddenImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func setData(backgroundImage: String, image: UIImage) {
        backgroundImageView.image = UIImage(named: backgroundImage)
        imageView.image = image
    }

    func unselect() {
        isUserInteractionEnabled = true
        selectionImageView.isHidden = true
    }

    func select() { backgroundImageView.image = UIImage(named: "tabularCellLightBlue") }

    func setGreyBackground() { backgroundImageView.image = UIImage(named: "tabularCellGrey") }

    func hideImage() { hiddenImageView.isHidden = false }

    func openImage() { hiddenImageView.isHidden = true }
}
