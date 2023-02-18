//
//  UIViewController.swift
//  Preschool Math Game
//
//  Created by Armen Gasparyan on 22.12.21.
//


import UIKit

extension UIViewController {
    func showAlert(_ title: String? = nil, message: String?, handler: ((UIAlertAction) -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: handler))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showToastAlert1(_ title: String? = nil, message: String?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showToastAlert(_ title: String? = nil, message: String?) {
        let uialert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(uialert, animated: true, completion:{
            uialert.view.superview?.isUserInteractionEnabled = true
            uialert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
        })
    }
    
    @objc func dismissOnTapOutside(){
        self.dismiss(animated: true, completion: nil)
    }
        
    func removeTopChildViewController() {
        guard self.children.count > 0 else { return }
        let viewControllers:[UIViewController] = self.children
        viewControllers.last?.willMove(toParent: nil)
        viewControllers.last?.removeFromParent()
        viewControllers.last?.view.removeFromSuperview()
    }
}
