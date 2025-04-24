//
//  NewsResponse.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 23/04/25.
//

import Foundation
 
struct NewsResponse: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Blog]?
}

struct Blog: Decodable {
    let id: Int
    let title: String
    let authors: [Author]?
    let url: String
    let imageUrl: String?
    let newsSite: String?
    let summary: String
    let publishedAt: String?
    let updatedAt: String?
    let featured: Bool?
    let launches: [Launch]?
    let events: [Event]?

    enum CodingKeys: String, CodingKey {
        case id, title, authors, url
        case imageUrl = "image_url"
        case newsSite = "news_site"
        case summary
        case publishedAt = "published_at"
        case updatedAt = "updated_at"
        case featured, launches, events
    }
}

struct Author: Decodable {
    let name: String
    let socials: [String: String]?
}

struct Launch: Decodable {
    let launchId: String?
    let provider: String?
        
    enum CodingKeys: String, CodingKey {
        case provider
        case launchId = "launch_id"
    }
}
        
struct Event: Decodable {
    let eventId: Int?
    let provider: String?
        
    enum CodingKeys: String, CodingKey {
        case provider
        case eventId = "event_id"
    }
}

