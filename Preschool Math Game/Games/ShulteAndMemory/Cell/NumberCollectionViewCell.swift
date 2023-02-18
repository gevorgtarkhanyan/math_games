//
//  NumberCollectionViewCell.swift
//  Preschool Math Game
//
//  Created by Armen Gasparyan on 22.02.22.
//

import UIKit

class NumberCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var selectionImageView: UIImageView!
//    override var isSelected: Bool {
//        didSet {
//            numberLabel.textColor = isSelected ? .white : .white
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        numberLabel.textColor = .white
        numberLabel.adjustsFontSizeToFitWidth = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print(frame.height)
        let size: CGFloat = 30 * frame.height / 90
        numberLabel.font = numberLabel.font.withSize(size)
    }
    
    func setData(number: Int, image: String) {
        numberLabel.text = String(number)
        backgroundImageView.image = UIImage(named: image)
    }
    
    func selectionSetup(with isAscending: Bool) {
        isUserInteractionEnabled = false
        numberLabel.textColor = isAscending ? .borderBlue : .cellRed
        selectionImageView.isHidden = false
    }
    
    func unselect() {
        isUserInteractionEnabled = true
        numberLabel.textColor = .white
        selectionImageView.isHidden = true
    }
}
