//
//  DetailViewController.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 24/04/25.
//

import UIKit

class DetailViewController: UIViewController {
    
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let summaryTextView = UITextView()
    private let loadingView = UIActivityIndicatorView(style: .large)
    
    var viewModel = DetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        viewModel.getDetailNews()
        setupViews()
        viewModel.delegate = self
        viewModel.getDetailNews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupViews() {
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.numberOfLines = 0

        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.textColor = .gray
        dateLabel.numberOfLines = 1

        summaryTextView.font = .systemFont(ofSize: 16)
        summaryTextView.isEditable = false
        summaryTextView.isScrollEnabled = false
        summaryTextView.backgroundColor = .clear
        summaryTextView.textContainerInset = .zero
        summaryTextView.textContainer.lineFragmentPadding = 0

        let stack = UIStackView(arrangedSubviews: [titleLabel, dateLabel, summaryTextView])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])

        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.color = .orange
        loadingView.hidesWhenStopped = true

        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension DetailViewController: DetailDelegate {
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
    
    func didDetail() {
        titleLabel.text = viewModel.detail?.title ?? ""
        dateLabel.text = StringUtils.formatDate(viewModel.detail?.publishedAt ?? "")
        summaryTextView.text = StringUtils.getSummarySentence(from: viewModel.detail?.summary ?? "")
    }
}
