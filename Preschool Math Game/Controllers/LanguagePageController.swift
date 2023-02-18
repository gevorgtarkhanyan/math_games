//
//  LanguagePageController.swift
//  Preschool Math Game
//
//  Created by Gago Mkrtchyan on 07.07.21.
//

import UIKit

protocol LanguagePageControllerDelegate: AnyObject {
    func changeLanguage(string: String)
}

class LanguagePageController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var baseContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    var languageArray = ["English", "Spanish"]//, "German", "Marathi", "Russian", "French", "Hindi", "Portuguese"]
    
    var selectedIndexPath: IndexPath?
    
    weak var delegate: LanguagePageControllerDelegate?
    
    var language = ""
    
    var index: Int?
    
    var defaultIndex: Int?
    
    override var prefersHomeIndicatorAutoHidden: Bool { return false }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return UIRectEdge.bottom
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        containerView.layer.borderWidth = 3
        containerView.layer.borderColor = #colorLiteral(red: 1, green: 0.7058823529, blue: 0.231372549, alpha: 1)

        configureLanguage()
        configureUI()
        addTapGesture()
        
        addAnimation()
    }
    
    private func configureUI() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "LanguageTableViewCell", bundle: nil), forCellReuseIdentifier: "LanguageTableViewCell")
        
    }
    
    private func configureLanguage() {
        let langStr = Locale.current.languageCode
        
        if langStr == "ru" {
            defaultIndex = 3
        } else if langStr == "en" {
            defaultIndex = 0
        }
        
        index = UserDefaults.standard.value(forKey: UserDefaultsKeys.languageIndexPath) as? Int ?? defaultIndex
    }
    
    private func addTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        baseContainerView.addGestureRecognizer(tapGestureRecognizer)
        view.isUserInteractionEnabled = true
    }
    
    @objc func tap() {
        removeAnimation()
    }
    
    private func addAnimation() {
        self.containerView.transform = CGAffineTransform(translationX: 0, y: self.containerView.frame.height)
        UIView.animate(withDuration: 0.5) {
            self.containerView.transform = .identity
        }
    }
    
    private func removeAnimation() {
        UIView.animate(withDuration: 0.2) {
            self.containerView.transform = CGAffineTransform(translationX: 0, y: self.containerView.frame.height + 300)
        } completion: { (complete) in
            self.view.removeFromSuperview()
        }
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        removeAnimation()
    }
}

extension LanguagePageController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageTableViewCell", for: indexPath) as! LanguageTableViewCell
        
        cell.languageName.text = languageArray[indexPath.row]
        
        if index != nil {
            if indexPath.row == index {
                cell.tickIcon.isHidden = false
            } else {
                cell.tickIcon.isHidden = true
            }
        } else {
            if let selectedIndexPath = selectedIndexPath, indexPath.row == selectedIndexPath.row {
                cell.tickIcon.isHidden = false
            } else {
                cell.tickIcon.isHidden = true
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        if let selectedIndexPath = selectedIndexPath, indexPath.row == selectedIndexPath.row {
            UserDefaults.standard.setValue(selectedIndexPath.row, forKey: UserDefaultsKeys.languageIndexPath)
            self.selectedIndexPath = nil
        } else {
            self.selectedIndexPath = indexPath
        }
        
        let index = indexPath.row
        if index == 0 {
            language = "en"
        } else if index == 3 {
            language = "ru"
        }
        UserDefaults.standard.setValue(indexPath.row, forKey: UserDefaultsKeys.languageIndexPath)
        
        delegate?.changeLanguage(string: language)
        removeAnimation()
//        tableView.reloadData()
    }
}

