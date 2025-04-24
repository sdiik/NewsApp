//
//  SearchViewController.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 23/04/25.
//

import UIKit

class SearchViewController: ParentViewController {
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var searchView: UISearchBar! {
        didSet {
            searchView.delegate = self
        }
    }
    
    @IBOutlet weak var tableListView: UITableView! {
        didSet {
            tableListView.delegate = self
            tableListView.dataSource = self
        }
    }
    
    private let refreshControl = UIRefreshControl()
    var newType: NewsType = .articles
    var viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = newType.title
        viewModel.delegate = self
        setupView()
        registerCell()
        viewModel.loadInitialNews(with: "", type: newType)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupView() {
        searchView.placeholder = "Search \(newType.title)"
        sortButton.addTarget(self, action: #selector(sortTapped), for: .touchUpInside)
        filterButton.addTarget(self, action: #selector(filterTapped), for: .touchUpInside)
    }
    
    private func registerCell() {
        tableListView.register(UINib(nibName: "EmptyTableCell", bundle: nil), forCellReuseIdentifier: "EmptyTableCell")
        tableListView.register(UINib(nibName: "SearchTableCell", bundle: nil), forCellReuseIdentifier: "SearchTableCell")
        tableListView.estimatedRowHeight = 88.0
        tableListView.sectionHeaderHeight = 0
        tableListView.sectionHeaderTopPadding = 0
        tableListView.rowHeight = UITableView.automaticDimension
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableListView.refreshControl = refreshControl
    }
    
    @objc func handleRefresh() {
        viewModel.resetAll()
        searchView.text = viewModel.searchQuery
        viewModel.loadInitialNews(with: "", type: newType)
    }
    
    @objc func sortTapped() {
        viewModel.sortByTitle()
        tableListView.reloadData()
    }
    
    @objc func filterTapped() {
        viewModel.fetchNewsSites()
        let filterVC = FilterViewController(selectedSite: viewModel.selectedNewsSite)
        filterVC.viewModel.onSelectNewsSite = { [weak self] selected in
            guard let self = self else { return }
            self.viewModel.selectedNewsSite = selected
            self.viewModel.filterArticles()
            self.tableListView.reloadData()
        }
        present(filterVC, animated: true)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.filteredReports.isEmpty {
            tableListView.separatorStyle = .none
            return 1
        } else {
            tableListView.separatorStyle = .singleLine
            return viewModel.filteredReports.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.filteredReports.isEmpty {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyTableCell", for: indexPath) as? EmptyTableCell
            else { return .init() }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableCell", for: indexPath) as? SearchTableCell
            else { return .init() }
            cell.setupView(with: viewModel.filteredReports[indexPath.row])
            return cell
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height - 100 {
            if !viewModel.isFilterProccesing() {
                viewModel.loadNextPage()
            }
        }
    }
}

extension SearchViewController: SearchViewDelegate {
    func didStartLoading() {
        loadingView.isHidden = false
        loadingView.startAnimating()
    }
    
    func didFinishLoading() {
        loadingView.stopAnimating()
    }
    
    func didFailWithError(_ error: any Error) {
        Alert.showMessage(with: error.localizedDescription, controller: self)
    }
    
    func didSearchNews() {
        tableListView.reloadData()
        refreshControl.endRefreshing()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchQuery = searchText
        viewModel.loadInitialNews(with: viewModel.searchQuery, type: newType)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchQuery = ""
        searchView.text = viewModel.searchQuery
        viewModel.loadInitialNews(with: viewModel.searchQuery, type: newType)
    }
}
