//
//  PrizeTableViewCell.swift
//  Preschool Math Game
//
//  Created by Armen Gasparyan on 28.02.22.
//

import UIKit

class PrizeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var prizeImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    static let height = CGFloat(50)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization co
        backgroundColor = .clear
        timeLabel.adjustsFontSizeToFitWidth = true
    }
    
    public func setPrize(_ prize: Prize) {
        prizeImageView.image = UIImage(named: prize.name)
        timeLabel.text = prize.seconds.toHoursMinutesSeconds()
        timeLabel.textColor = prize.textColor
    }
}
