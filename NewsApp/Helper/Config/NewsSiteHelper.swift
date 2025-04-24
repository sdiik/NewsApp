//
//  NewsSiteHelper.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 24/04/25.
//

import Foundation

class NewsSiteHelper {
    private static var newsSites: Set<String> = []
    
    static func addUniqueNewsSite(_ newNewsSite: String) {
        newsSites.insert(newNewsSite)
    }
    
    static func updateNewsSites(from articles: [Blog]) {
        for article in articles {
            if let alreadyNewSite = article.newsSite {
                addUniqueNewsSite(alreadyNewSite)
            }
        }
    }
    
    static func getUniqueNewsSites() -> [String] {
        return Array(newsSites)
    }
    
    static func reset() {
        newsSites.removeAll()
    }
}
