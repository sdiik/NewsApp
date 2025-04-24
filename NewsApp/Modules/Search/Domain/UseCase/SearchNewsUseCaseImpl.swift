//
//  SearchNewsUseCaseImpl.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 24/04/25.
//

import Foundation

class SearchNewsUseCaseImpl: SearchNewsUseCase {
    let searchNewsRepository: SearchNewsRepository
    
    init(searchNewsRepository: SearchNewsRepository = SearchNewsRepositoryImpl()) {
        self.searchNewsRepository = searchNewsRepository
    }
    
    func execute(with url: URL?, completionHandler: @escaping SearchNewsUseCaseCompletionHandler) {
        searchNewsRepository.searchNews(with: url) { result in
            switch result {
            case .success(let newsResponse):
                completionHandler(.success(newsResponse))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
