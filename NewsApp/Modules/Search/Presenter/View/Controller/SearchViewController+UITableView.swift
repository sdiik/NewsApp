//
//  SearchViewController+UITableView.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 24/04/25.
//

import UIKit

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case recentTableView:
            return viewModel.recentSearches.count
        default:
            if viewModel.filteredReports.isEmpty {
                tableListView.separatorStyle = .none
                return 1
            } else {
                tableListView.separatorStyle = .singleLine
                return viewModel.filteredReports.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case recentTableView:
            return self.tableView(tableView, cellForResentRowAt: indexPath)
        default:
            return self.tableView(tableView, cellForNewRowAt: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForResentRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentCell", for: indexPath)
        cell.textLabel?.text = viewModel.recentSearches[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForNewRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case recentTableView:
            let selectedTerm = viewModel.recentSearches[indexPath.row]
            searchView.text = selectedTerm
            viewModel.searchQuery = selectedTerm
            viewModel.loadInitialNews(with: selectedTerm, type: newType)
            recentTableView.isHidden = true
        default:
            break
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
