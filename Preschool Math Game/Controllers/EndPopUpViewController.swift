//
//  EndPopUpViewController.swift
//  Preschool Math Game
//
//  Created by Armen Gasparyan on 07.02.22.
//

import UIKit

protocol EndPopUpViewControllerDelegate: BackButtonDelegate {
    func refreshTapped()
}

class EndPopUpViewController: UIViewController {

    @IBOutlet private weak var backButton: BackButton!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var refreshButton: UIButton!
    
    private var imageName = String()
    private var refresh = false
    
    public weak var delegate: EndPopUpViewControllerDelegate?
    
    static func initializeWithStoryboard() -> EndPopUpViewController? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: EndPopUpViewController.name) as? EndPopUpViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        animate()
    }
    
    @objc func refreshTapped() {
        dismis()
        delegate?.refreshTapped()
    }
    
    //MARK: - Setup
    private func setup() {
        view.backgroundColor = .clear
        iconImageView.image = UIImage(named: imageName)
        iconImageView.isHidden = true
        refreshButton.isHidden = true
//        addGesture()
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        refreshButton.addTarget(self, action: #selector(refreshTapped), for: .touchUpInside)
    }
    
    private func animate() {
        refreshButton.isHidden = !refresh
        iconImageView.isHidden = false
        refreshButton.changeSizeImageWithAnimate()
        iconImageView.changeSizeImageWithAnimate()
    }
    
    @objc func backTapped() {
        dismis()
        delegate?.backTapped()
    }
    
    private func addGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(backTapped))
        view.addGestureRecognizer(tap)
    }

    @objc private func dismis() { self.dismiss(animated: false, completion: nil) }
    
    //MARK: - Public
    public func setImage(_ name: String) { imageName = name }
    
    public func setRefresh(_ bool: Bool) { refresh = bool }
}
