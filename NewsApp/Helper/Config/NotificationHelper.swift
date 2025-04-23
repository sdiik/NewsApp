//
//  NotificationHelper.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 23/04/25.
//

import UserNotifications

class NotificationHelper {
    static let shared = NotificationHelper()

    func sendLogoutNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Session Expired"
        content.body = "Akun Anda telah logout otomatis setelah 10 menit."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let request = UNNotificationRequest(
            identifier: "sessionExpiredNotification",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule logout notification: \(error.localizedDescription)")
            }
        }
    }
}
