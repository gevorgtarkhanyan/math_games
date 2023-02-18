//
//  DivisionCollectionCell.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 19.07.21.
//

import UIKit

class DivisionCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var lockImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var prizImage: UIImageView!
    @IBOutlet weak var prizCount: UILabel!
    @IBOutlet weak var centerYConstraint: NSLayoutConstraint!
    @IBOutlet weak var centerXConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.borderWidth = 1.5
        containerView.layer.borderColor = #colorLiteral(red: 0.7490196078, green: 0.1882352941, blue: 0.2156862745, alpha: 1)
        containerView.clipsToBounds = true
    }
    
    public func setGame(game: Game) {
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor(red: 249, green: 184, blue: 24),
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.strokeWidth: -6.0
            
        ];
        
        let textWithStroke = NSAttributedString(
            string: game.name,
            attributes: attributes
        );

        gameLabel.attributedText = textWithStroke
//        gameLabel.text = game.name
        gameImage.image = UIImage(named: game.id)
        prizImage.image = UIImage(named: game.prize)
        prizCount.text = game.prize
        lockImageView.isHidden = !game.isLocked
    }
}
