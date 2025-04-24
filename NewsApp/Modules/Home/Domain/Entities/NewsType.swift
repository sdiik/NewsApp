//
//  NewsType.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 23/04/25.
//

import Foundation

enum NewsType: Int, CaseIterable {
    case articles = 0
    case blogs = 1
    case reports = 2

    var url: URL? {
        switch self {
        case .articles:
            return NewsAPIService().makeArticlesURL()
        case .blogs:
            return NewsAPIService().makeBlogsURL()
        case .reports:
            return NewsAPIService().makeReportsURL()
        }
    }
    
    func url(with query: String) -> URL? {
        switch self {
        case .articles:
            return NewsAPIService().makeArticlesURL(withQuery: query)
        case .blogs:
            return NewsAPIService().makeBlogsURL(withQuery: query)
        case .reports:
            return NewsAPIService().makeReportsURL(withQuery: query)
        }
    }
    
    var title: String {
        switch self {
        case .articles:
            return "Articles"
        case .blogs:
            return "Blogs"
        case .reports:
            return "Reports"
        }
    }
}
