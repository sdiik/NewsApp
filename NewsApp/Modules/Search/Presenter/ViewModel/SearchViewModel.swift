//
//  SearchViewModel.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 24/04/25.
//

import Foundation

protocol SearchViewDelegate: AnyObject {
    func didStartLoading()
    func didFinishLoading()
    func didFailWithError(_ error: Error)
    func didSearchNews()
}

class SearchViewModel {
    weak var delegate: SearchViewDelegate?
    private let newsUseCase: SearchNewsUseCase
    private var nextPageURL: URL?
    
    private(set) var newsSites: [String] = []
    var searchItem: [Blog] = []
    var filteredReports: [Blog] = []
    var recentSearches: [String] = []
    
    var searchQuery: String = ""
    var selectedNewsSite: String?
    private var isAscending = true

    init(newsUseCase: SearchNewsUseCase = SearchNewsUseCaseImpl()) {
        self.newsUseCase = newsUseCase
    }
    
    func loadInitialNews(with query: String, type: NewsType) {
        guard let url = type.url(with: query) else { return }
        loadNews(from: url, isInitial: true)
    }
    
    func loadNextPage() {
        guard let nextURL = nextPageURL else { return }
        loadNews(from: nextURL, isInitial: false)
    }
    
    func loadNews(from url: URL, isInitial: Bool) {
        resetAll()
        delegate?.didStartLoading()
        newsUseCase.execute(with: url){ [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.delegate?.didFinishLoading()
                switch result {
                case .success(let response):
                    if isInitial {
                        self.searchItem = response.results ?? []
                        self.filteredReports = response.results ?? []
                    } else {
                        self.searchItem += response.results ?? []
                        self.filteredReports += response.results ?? []
                    }
                    NewsSiteHelper.updateNewsSites(from: self.searchItem)
                    self.nextPageURL = URL(string: response.next ?? "")
                    self.delegate?.didSearchNews()
                case .failure(let error):
                    self.delegate?.didFailWithError(error)
                }
            }
            
        }
    }

    func fetchNewsSites() {
        self.newsSites = NewsSiteHelper.getUniqueNewsSites().sorted()
    }
    
    func sortByTitle() {
        isAscending.toggle()
        filteredReports = searchItem.sorted {
            isAscending ? $0.title.lowercased() < $1.title.lowercased()
            : $0.title.lowercased() > $1.title.lowercased()
        }
    }
    
    func filterArticles() {
        guard let selected = selectedNewsSite else { return }
        if selected == "ALL" {
            filteredReports = searchItem
        } else {
            filteredReports = searchItem.filter { $0.newsSite == selected }
        }
    }
    
    func resetAll() {
        searchQuery = ""
        selectedNewsSite = ""
        filteredReports = searchItem
    }
    
    func isFilterProccesing() -> Bool {
        if let alreadySelected = selectedNewsSite, !alreadySelected.isEmpty {
            return true
        } else {
            return false
        }
    }
}
