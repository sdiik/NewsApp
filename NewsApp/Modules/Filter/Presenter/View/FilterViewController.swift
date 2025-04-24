//
//  FilterViewController.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 24/04/25.
//

import UIKit

class FilterViewController: UIViewController {
    private let tableView = UITableView()
    private let loadingIndicator = UIActivityIndicatorView()

    var viewModel = FilterViewModel()
    
    init(selectedSite: String? = nil) {
        self.viewModel.selectedSite = selectedSite
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .pageSheet
        if let sheet = sheetPresentationController {
            sheet.detents = [.medium()]
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        viewModel.delegate = self
        setupTableView()
        viewModel.getInfo()
    }

    private func setupTableView() {
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        loadingIndicator.style = .large
        loadingIndicator.color = .orange
        loadingIndicator.center = view.center
        loadingIndicator.hidesWhenStopped = true
        view.addSubview(loadingIndicator)
    }
}

extension FilterViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  viewModel.info.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let title = viewModel.info[indexPath.row]
        cell.textLabel?.text = title
        cell.accessoryType = (title == viewModel.selectedSite) ? .checkmark : .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.onSelectNewsSite?(viewModel.info[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
}

extension FilterViewController: FilterDelegate{
    func didStartLoading() {
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }
    
    func didFinishLoading() {
        loadingIndicator.stopAnimating()
    }
    
    func didFailWithError(_ error: any Error) {
        Alert.showMessage(with: error.localizedDescription, controller: self)
    }
    
    func didInfo() {
        tableView.reloadData()
    }
}
