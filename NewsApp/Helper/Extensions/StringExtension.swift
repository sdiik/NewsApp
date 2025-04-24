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

class GreetingHelper {
    static func getGreeting(for date: Date = Date()) -> String {
        let hour = Calendar.current.component(.hour, from: date)

        switch hour {
        case 5..<12:
            return "Good morning"
        case 12..<17:
            return "Good afternoon"
        case 17..<21:
            return "Good evening"
        default:
            return "Good night"
        }
    }
}

class StringUtils {
    static func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.date(from: dateString) {
            let localDateFormatter = DateFormatter()
            localDateFormatter.dateStyle = .long
            localDateFormatter.timeStyle = .short
            localDateFormatter.locale = Locale(identifier: "en_US")
            return localDateFormatter.string(from: date).replacingOccurrences(of: " at ", with: ",")
        }
        return dateString
    }
    
    static func getSummarySentence(from summary: String) -> String {
        let sentence = summary.split(separator: ".").first ?? ""
        return String(sentence)
    }
}
