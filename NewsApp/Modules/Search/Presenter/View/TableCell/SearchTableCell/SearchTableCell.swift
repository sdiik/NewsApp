//
//  SearchTableCell.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 23/04/25.
//

import UIKit

class SearchTableCell: UITableViewCell {
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var laucherValueLabel: UILabel!
    @IBOutlet weak var eventsValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupView(with data: Blog) {
        titleLabel.text = data.title
        descLabel.text = data.summary
        
        if let launchCount = data.launches, let eventCount = data.events, !launchCount.isEmpty, !eventCount.isEmpty {
            laucherValueLabel.text = "\(launchCount)"
            eventsValueLabel.text = "\(eventCount)"
        } else {
            laucherValueLabel.text = "0"
            eventsValueLabel.text = "0"
        }
        configure(with: data.imageUrl)
    }
    
    private func configure(with urlString: String?) {
        newsImageView.image = nil
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return
        }
        
        newsImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "icon_news"),
            options: [
                .transition(.fade(0.3)),
                .cacheOriginalImage
            ]
        )
    }
}
