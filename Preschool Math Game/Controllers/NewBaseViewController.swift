//
//  NewBaseViewController.swift
//  Preschool Math Game
//
//  Created by Armen Gasparyan on 02.03.22.
//

import UIKit

class NewBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - Observer
    @objc public func addBackgroundNotificaitonObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationOpenedFromBackground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationEnteredToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc public func applicationOpenedFromBackground(_ sender: Notification) { }
    @objc public func applicationEnteredToBackground(_ sender: Notification) { }
    @objc public func applicationWillResignActive(_ sender: Notification) { }
    
    @objc public func removeBackgroundNotificaitonObserver() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
    }
}
