//
//  HeaderTableCell.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 23/04/25.
//

import UIKit

class SectionHeaderView: UITableViewHeaderFooterView {
    static let reuseIdentifier = "SectionHeaderView"
    var seeMoreAction: (() -> Void)?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let seeMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("See More", for: .normal)
        button.setTitleColor(UIColor.orange, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
        seeMoreButton.addTarget(self, action: #selector(seeMoreTapped), for: .touchUpInside)
    }
    
    @objc private func seeMoreTapped() {
        seeMoreAction?()
    }
    
    private func setupViews() {
        contentView.backgroundColor = UIColor.clear
        contentView.addSubview(titleLabel)
        contentView.addSubview(seeMoreButton)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            seeMoreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            seeMoreButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    func configure(title: String) {
        titleLabel.text = title
    }
}
