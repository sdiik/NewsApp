//
//  StringExtension.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 23/04/25.
//

import Foundation

class Validation {
    static func isValidPassword(_ password: String) -> Bool {
        guard password.count >= 8 else { return false }
        
        let pattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$&*._-]).{8,}$"
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: password.utf16.count)
        
        return regex?.firstMatch(in: password, options: [], range: range) != nil
    }

    static func isValidEmail(_ email: String) -> Bool {
        let pattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: email.utf16.count)
        return regex?.firstMatch(in: email, options: [], range: range) != nil
    }
}
