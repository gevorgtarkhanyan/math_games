//
//  LanguageTableViewCell.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 07.07.21.
//

import UIKit

class LanguageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var languageName: UILabel!
    @IBOutlet weak var tickIcon: UIImageView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func choosedLanguage(index: Int) {
        
        if index == 0 {
            self.tickIcon.isHidden = false
        } else {
            self.tickIcon.isHidden = true
        }
    }
}
