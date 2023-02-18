//
//  SettingsFirtsTableViewCell.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 6/2/21.
//

import UIKit

class SettingsFirtsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var volumeIcon: UIImageView!
    
    private var isclicked = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
                
        isclicked = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isClickedBackgroundSoundBtn)
        
        if UserDefaults.standard.bool(forKey: UserDefaultsKeys.ischangeBackgroundSoundStatus) {
            if UserDefaults.standard.bool(forKey: UserDefaultsKeys.backgroundSoundIsOn) {
                volumeIcon.image = UIImage(named: "volume_up")
            } else {
                volumeIcon.image = UIImage(named: "volume_off")
            }
        }
    }
    
    func setupDelegate(controller: SettingsViewController) {
        controller.delegate = self
    }
}

extension SettingsFirtsTableViewCell: SettingsViewControllerDelegate {
    func changeFirstIcon() {
        if !isclicked {
            volumeIcon.image = UIImage(named: "volume_off")
            isclicked = true
            BasePageController.sounds.stopBackgroundSound()
            UserDefaults.standard.setValue(false, forKey: UserDefaultsKeys.backgroundSoundIsOn)
            UserDefaults.standard.setValue(true, forKey: UserDefaultsKeys.ischangeBackgroundSoundStatus)
            UserDefaults.standard.setValue(true, forKey: UserDefaultsKeys.isClickedBackgroundSoundBtn)

        } else {
            volumeIcon.image = UIImage(named: "volume_up")
            isclicked = false
            BasePageController.sounds.playBackgroundSound()
            UserDefaults.standard.setValue(true, forKey: UserDefaultsKeys.backgroundSoundIsOn)
            UserDefaults.standard.setValue(false, forKey: UserDefaultsKeys.isClickedBackgroundSoundBtn)
        }
    }
}
