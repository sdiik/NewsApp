//
//  SearchNewsUseCase.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 24/04/25.
//

import Foundation

typealias SearchNewsUseCaseCompletionHandler = (_ result: Result<NewsResponse, FetchNewsError>) -> Void

protocol SearchNewsUseCase {
    func execute(with url: URL?, completionHandler: @escaping SearchNewsUseCaseCompletionHandler)
}
