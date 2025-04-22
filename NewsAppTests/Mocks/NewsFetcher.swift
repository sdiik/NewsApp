//
//  NewsFetcher.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 22/04/25.
//

import XCTest
@testable import NewsApp

class NewsFetcher {
    let repo: NetworkRepository

    init(repo: NetworkRepository) {
        self.repo = repo
    }

    func loadNews(completion: @escaping (String) -> Void) {
        guard let url = URL(string: "https://api.spaceflightnewsapi.net/v4/articles/?format=json") else { return }

        repo.fetchRequest(url) { result in
            switch result {
            case .success((_, let data)):
                let message = String(data: data, encoding: .utf8) ?? "Invalid Data"
                completion(message)
            case .failure:
                completion("Fetch Failed")
            }
        }
    }
}
