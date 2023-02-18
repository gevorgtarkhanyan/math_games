//
//  SettingsViewController.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 5/25/21.
//

import UIKit
import StoreKit

protocol SettingsViewControllerDelegate: AnyObject {
    func changeFirstIcon()
}

enum CellsType: Int {
    case first
    case second
    case third
    case foure
}

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var gameGroundView: UIView!
    
    @IBOutlet var subscriptionInfoView: UIView!
    @IBOutlet weak var versionButton: UIButton!
    @IBOutlet weak var yearLabel: UILabel!
    
    weak var delegate: SettingsViewControllerDelegate?
    
    var cellType: [CellsType] = []
    
    var array = ["Feedback", "share", "rate_Us"]
    var tappedCount = 0
    
    override var prefersHomeIndicatorAutoHidden: Bool { return false }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return UIRectEdge.bottom
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameGroundView.layer.borderWidth = 5
        gameGroundView.layer.borderColor = #colorLiteral(red: 0.7450980392, green: 0.8431372549, blue: 0.1764705882, alpha: 1)
        subscriptionInfoView.layer.cornerRadius = 10
        let langStr = Locale.current.languageCode
        
        let lng = UserDefaults.standard.value(forKey: UserDefaultsKeys.languageKey) as? String
        changeLanguage(str: (lng ?? langStr)!)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "SettingsSecondTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingsSecondTableViewCell")
        tableView.register(UINib(nibName: "SettingsFirtsTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingsFirtsTableViewCell")
        tableView.register(UINib(nibName: "ShowHuntTableViewCell", bundle: nil), forCellReuseIdentifier: "ShowHuntTableViewCell")
        setVersionAndYear()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(subscriptionViewAction))
        subscriptionInfoView.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.post(name: .closeParentalControl, object: nil)
    }
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func subscriptionViewAction() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SubscriptionViewController") as! SubscriptionViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func changeLanguage(str: String) {
        array[1] = "share".localized(str: str)
        array[2] = "rate_Us".localized(str: str)
        tableView.reloadData()
    }
    
    func setVersionAndYear() {
        yearLabel.text = "Witplex © \(Date().yearString)"
        versionButton.setTitle("Preschool Math Game \(UIApplication.appVersion())", for: .normal)
        versionButton.addTarget(self, action: #selector(tappedFiveTims), for: .touchUpInside)
    }
    
    @objc private func tappedFiveTims() {
        tappedCount += 1
        
        guard tappedCount == 5 else { return }
        showToastAlert(message: UIApplication.appBuild())
        tappedCount = 0
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        cellType = []
        cellType.append(.first)
        cellType.append(.second)
        cellType.append(.third)
        cellType.append(.foure)
        
        return cellType.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch cellType[section] {
        case .first:
            return 1
        case .second:
            return 1
        case .third:
            return 1
        case .foure:
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cellType[indexPath.section] {
        case .first:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsFirtsTableViewCell", for: indexPath) as! SettingsFirtsTableViewCell
            
            cell.setupDelegate(controller: self)
            
            return cell
            
        case .second:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsSecondTableViewCell", for: indexPath) as! SettingsSecondTableViewCell
            
            return cell
            
        case .third:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShowHuntTableViewCell", for: indexPath) as! ShowHuntTableViewCell
            
            if GamesLimit.isShowHunt {
                cell.showHintSwitch.isOn = true
            } else {
                cell.showHintSwitch.isOn = false
            }
            
            return cell
            
        case .foure:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as! SettingsTableViewCell
            
            cell.label.text = array[indexPath.row]
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch cellType[indexPath.section] {
        case .first:
            delegate?.changeFirstIcon()
        case .second:
            NotificationCenter.default.post(name: .changeVolumeIcon, object: nil)
        case .third:
            return
            
        case .foure:
             if indexPath.row == 0 {
                let email = "info@witplex.com"
                if let url = URL(string: "mailto:\(email)") {
                    UIApplication.shared.openURL(url)
                }
                
            } else if indexPath.row == 1 {
                guard let appStoreURL = URL(string: "https://apps.apple.com/us/app/math-for-kids-cool-fun-games/id1570425468"), let playMarketURL = URL(string: "https://play.google.com/store/apps/details?id=com.witplex.preschoolmathgame") else { return }
                
                let activityVc = UIActivityViewController(activityItems: ["Hey, I am learning math by using this great app! \n\nDownload it free for \niOS: \n\(appStoreURL) \nAndroid: \n\(playMarketURL)"], applicationActivities: nil)
                activityVc.popoverPresentationController?.sourceView = view
                present(activityVc, animated: true, completion: nil)
                
            } else if indexPath.row == 2{
                let appURL = "https://apps.apple.com/us/app/math-for-kids-cool-fun-games/id1570425468"
                
                    var components = URLComponents(string: appURL)
                    components?.queryItems = [
                        URLQueryItem(name: "action", value: "write-review")
                    ]

                if let reviewPageURL = components?.url {
                    UIApplication.shared.openURL(reviewPageURL)
                }
                
            } else if indexPath.row == 3 {
//                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LanguagePageController") as! LanguagePageController
//                
//                vc.delegate = self
//                self.addChild(vc)
//                self.view.addSubview(vc.view)
//                vc.didMove(toParent: self)
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
    }
}

extension SettingsViewController: LanguagePageControllerDelegate {
    func changeLanguage(string: String) {
        changeLanguage(str: string)
    }
}

