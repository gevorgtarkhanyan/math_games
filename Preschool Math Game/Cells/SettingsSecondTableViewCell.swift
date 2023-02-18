//
//  SettingsSecondTableViewCell.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 6/2/21.
//

import UIKit

class SettingsSecondTableViewCell: UITableViewCell {

    @IBOutlet weak var volumeIcon: UIImageView!
    
    private var isclicked = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        isclicked = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isClickedEfectsSoundBtn)
        
        if UserDefaults.standard.bool(forKey: UserDefaultsKeys.ischangeEfectsSoundStatus) {
            if UserDefaults.standard.bool(forKey: UserDefaultsKeys.efectsSoundIsOn) {
                volumeIcon.image = UIImage(named: "volume_up")
            } else {
                volumeIcon.image = UIImage(named: "volume_off")
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(notify), name: .changeVolumeIcon, object: nil)
    }
    
    @objc func notify() {
        if !isclicked {
            volumeIcon.image = UIImage(named: "volume_off")
            isclicked = true
            UserDefaults.standard.setValue(false, forKey: UserDefaultsKeys.efectsSoundIsOn)
            UserDefaults.standard.setValue(true, forKey: UserDefaultsKeys.ischangeEfectsSoundStatus)
            UserDefaults.standard.setValue(true, forKey: UserDefaultsKeys.isClickedEfectsSoundBtn)
        } else {
            volumeIcon.image = UIImage(named: "volume_up")
            isclicked = false
            UserDefaults.standard.setValue(true, forKey: UserDefaultsKeys.efectsSoundIsOn)
            UserDefaults.standard.setValue(false, forKey: UserDefaultsKeys.isClickedEfectsSoundBtn)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


