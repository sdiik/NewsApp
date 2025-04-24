//
//  HomeViewModel.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 23/04/25.
//

import Foundation

protocol HomeViewDelegate: AnyObject {
    func didStartLoading()
    func didFinishLoading()
    func didFailWithError(_ error: Error)
    func didFetchNews(for type: NewsType)
}

class HomeViewModel {
    weak var delegate: HomeViewDelegate?
    private let newsUseCase: FetchNewsUseCase
    
    var articles: [Blog] = []
    var blogs: [Blog] = []
    var reports: [Blog] = []
    
    init(newsUseCase: FetchNewsUseCase = FetchNewsUseCaseImpl()) {
        self.newsUseCase = newsUseCase
    }
    
    func fetchNews(for type: NewsType) {
        delegate?.didStartLoading()
        newsUseCase.execute(type: type) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didFinishLoading()
                switch result {
                case .success(let newsResponse):
                    switch type {
                    case .articles: self.articles = newsResponse.results ?? []
                    case .blogs: self.blogs = newsResponse.results ?? []
                    case .reports: self.reports = newsResponse.results ?? []
                    }
                    self.delegate?.didFetchNews(for: type)
                case .failure(let error):
                    self.delegate?.didFailWithError(error)
                }
            }
        }
    }
}
