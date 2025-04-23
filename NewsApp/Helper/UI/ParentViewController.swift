//
//  ParentViewController.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 23/04/25.
//

import UIKit

class ParentViewController: UIViewController {
    var logoutTimer: Timer?
    var hasLoggedOut = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLogoutTimer()
    }
    
    func startLogoutTimer() {
        logoutTimer?.invalidate()
        logoutTimer = Timer.scheduledTimer(
            timeInterval: 30,
            target: self,
            selector: #selector(checkSessionExpired),
            userInfo: nil,
            repeats: true
        )
        }

    @objc func checkSessionExpired() {
        if CredentialsStorage().isExpired() {
            guard !hasLoggedOut else { return }
            hasLoggedOut = true
            logoutTimer?.invalidate()
            logoutTimer = nil
            showLogoutAlert()
        }
    }
    
    func showLogoutAlert() {
        CredentialsStorage().clear()
        NotificationHelper.shared.sendLogoutNotification()
        navigateToLoginScreen()
    }
    
    func navigateToLoginScreen() {
        let loginVC = LoginViewController()
        let nav = UINavigationController(rootViewController: loginVC)
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
            appDelegate.window?.rootViewController = nav
            appDelegate.window?.makeKeyAndVisible()
        }
    }
    
    deinit {
        logoutTimer?.invalidate()
    }
}
