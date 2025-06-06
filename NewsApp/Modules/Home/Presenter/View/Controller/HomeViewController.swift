//
//  HomeViewController.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 23/04/25.
//

import UIKit

class HomeViewController: ParentViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var homeTableView: UITableView!
    
    var viewModel = HomeViewModel()
    var titleSection = ["artikel", "blog", "report"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
        registerCell()
        viewModel.delegate = self
        fetchAllNews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setupTitle() {
        let greating = GreetingHelper.getGreeting(for: Date())
        titleLabel.text = greating
        descLabel.text = CredentialsStorage().getUsername()
    }
    
    private func registerCell() {
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.register(UINib(nibName: "SectionTableCell", bundle: nil), forCellReuseIdentifier: "SectionTableCell")
        homeTableView.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SectionHeaderView.reuseIdentifier)
        homeTableView.estimatedRowHeight = 88.0
        homeTableView.sectionHeaderHeight = 0
        homeTableView.sectionHeaderTopPadding = 0
        homeTableView.rowHeight = UITableView.automaticDimension
    }
    
    private func fetchAllNews() {
        viewModel.fetchNews(for: .articles)
        viewModel.fetchNews(for: .blogs)
        viewModel.fetchNews(for: .reports)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderView.reuseIdentifier) as? SectionHeaderView else {
            return nil
        }
        header.configure(title: NewsType(rawValue: section)?.title ?? "")
        header.seeMoreAction = { [weak self] in
            let searchVC = SearchViewController()
            searchVC.newType = NewsType(rawValue: section) ?? .articles
            self?.navigationController?.pushViewController(searchVC, animated: true)
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SectionTableCell", for: indexPath) as? SectionTableCell else { return .init() }
        switch indexPath.section {
        case 0:
            cell.setNewsItems(with: viewModel.articles, newsType: 0, controller: self)
        case 1:
            cell.setNewsItems(with: viewModel.blogs, newsType: 1, controller: self)
        case 2:
            cell.setNewsItems(with: viewModel.reports, newsType: 2, controller: self)
        default:
            break
        }
        return cell
    }
}

extension HomeViewController: HomeViewDelegate {
    func didStartLoading() {
        loadingView.isHidden = false
        loadingView.startAnimating()
    }

    func didFinishLoading() {
        loadingView.stopAnimating()
    }

    func didFailWithError(_ error: Error) {
        Alert.showMessage(with: error.localizedDescription, controller: self)
    }

    func didFetchNews(for type: NewsType) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.homeTableView.reloadSections(IndexSet(integer: type.rawValue), with: .automatic)
        }
    }
}
