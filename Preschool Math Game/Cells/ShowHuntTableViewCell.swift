//
//  ShowHuntTableViewCell.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 07.07.21.
//

import UIKit

class ShowHuntTableViewCell: UITableViewCell {

    @IBOutlet weak var showHintSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        showHintSwitch.layer.borderColor = UIColor(red: 75, green: 150, blue: 201).cgColor
        showHintSwitch.layer.borderWidth = 1.0
    }

    @IBAction func showHuntSwitchAction(_ sender: UISwitch) {
        if sender.isOn {
            GamesLimit.isShowHunt = true
            UserDefaults.standard.setValue(true, forKey: UserDefaultsKeys.isShowHunt)
        } else {
            GamesLimit.isShowHunt = false
            UserDefaults.standard.setValue(false, forKey: UserDefaultsKeys.isShowHunt)
            UserDefaults.standard.setValue(true, forKey: UserDefaultsKeys.isChangedShowHunt)
        }
    }
}
