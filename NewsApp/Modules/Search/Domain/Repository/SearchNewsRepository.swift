//
//  SearchNewsRepository.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 24/04/25.
//

import Foundation

typealias SearchItemsResult = (_ result: Result<NewsResponse, FetchNewsError>) -> Void

protocol SearchNewsRepository {
    func searchNews(with url: URL?, completion: @escaping SearchItemsResult)
}
