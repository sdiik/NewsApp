//
//  SearchViewController+UISearchBar.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 24/04/25.
//

import UIKit

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchQuery = searchText
        viewModel.loadInitialNews(with: viewModel.searchQuery, type: newType)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchQuery = ""
        searchView.text = viewModel.searchQuery
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text, !keyword.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        RecentSearchManager.shared.save(searchTerm: keyword)
        viewModel.loadInitialNews(with: viewModel.searchQuery, type: newType)
        searchBar.resignFirstResponder()
        recentTableView.isHidden = true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewModel.recentSearches = RecentSearchManager.shared.getSearches()
        recentTableView.reloadData()
        recentTableView.isHidden = false
    }
}
