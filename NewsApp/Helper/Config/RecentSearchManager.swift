//
//  RecentSearchManager.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 24/04/25.
//

import Foundation

class RecentSearchManager {
    static let shared = RecentSearchManager()
    private let key = "recentSearches"

    func save(searchTerm: String) {
        var searches = getSearches()
        if let index = searches.firstIndex(of: searchTerm) {
            searches.remove(at: index)
        }
        searches.insert(searchTerm, at: 0)
        UserDefaults.standard.set(searches, forKey: key)
    }

    func getSearches() -> [String] {
        return UserDefaults.standard.stringArray(forKey: key) ?? []
    }

    func clear() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
