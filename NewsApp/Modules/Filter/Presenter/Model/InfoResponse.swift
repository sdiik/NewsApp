//
//  InfoResponse.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 24/04/25.
//

struct InfoResponse: Codable {
    let newsSites: [String]
    
    enum CodingKeys: String, CodingKey {
        case newsSites = "news_sites"
    }
}
