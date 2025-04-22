//
//  Alert.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 23/04/25.
//

import Foundation
import UIKit

class Alert {
    static func showMessage(with message: String, controller: UIViewController) {
        DispatchQueue.main.async {
            if controller.presentedViewController == nil {
                let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                controller.present(alert, animated: true, completion: nil)
            } else {
                print("error")
            }
        }
    }
}
