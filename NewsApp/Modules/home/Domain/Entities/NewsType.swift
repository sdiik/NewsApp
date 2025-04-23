//
//  NewsType.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 23/04/25.
//

enum NewsType: Int, CaseIterable {
    case articles = 0
    case blogs = 1
    case reports = 2

    var url: String {
        switch self {
        case .articles:
            return "https://api.spaceflightnewsapi.net/v4/articles/?format=json"
        case .blogs:
            return "https://api.spaceflightnewsapi.net/v4/blogs/?format=json"
        case .reports:
            return "https://api.spaceflightnewsapi.net/v4/reports/?format=json"
        }
    }
}
