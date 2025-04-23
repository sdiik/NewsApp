//
//  AppDelegate.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 22/04/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    let credentialsStorage = CredentialsStorage()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        if credentialsStorage.isExpired() {
            credentialsStorage.clear()
            NotificationHelper.shared.sendLogoutNotification()
            navigateToLoginScreen()
        } else {
            navigateToMainScreen()
        }
        setupNotification()
        return true
    }
    
    func navigateToLoginScreen() {
        if let window = window {
            let navigationController = UINavigationController(rootViewController: LoginViewController())
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
    }
    
    func navigateToMainScreen() {
        if let window = window {
            let mainViewController = ViewController()
            window.rootViewController = mainViewController
            window.makeKeyAndVisible()
        }
    }
    
    func setupNotification() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            } else {
                print("Notification permission granted: \(granted)")
            }
        }
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }
}
