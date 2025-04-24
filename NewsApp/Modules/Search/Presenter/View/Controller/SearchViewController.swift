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
    
    let refreshControl = UIRefreshControl()
    var recentTableView: UITableView!

    var newType: NewsType = .articles
    var viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = newType.title
        viewModel.delegate = self
        setupView()
        setupRecentTableView()
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
    
    private func setupRecentTableView() {
        recentTableView = UITableView(frame: .zero, style: .plain)
        recentTableView.register(UITableViewCell.self, forCellReuseIdentifier: "RecentCell")
        recentTableView.dataSource = self
        recentTableView.delegate = self
        recentTableView.isHidden = true
        view.addSubview(recentTableView)

        recentTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recentTableView.topAnchor.constraint(equalTo: searchView.bottomAnchor),
            recentTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recentTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recentTableView.heightAnchor.constraint(equalToConstant: 200) // adjust as needed
        ])
    }
    
    @objc func handleRefresh() {
        viewModel.resetAll()
        searchView.text = viewModel.searchQuery
        viewModel.loadInitialNews(with: viewModel.searchQuery, type: newType)
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
