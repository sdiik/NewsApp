//
//  ItemCell.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 23/04/25.
//

import UIKit
import Kingfisher

class ItemCell: UICollectionViewCell {
    @IBOutlet weak var itemBackgroundView: UIView!
    @IBOutlet weak var itemImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        itemBackgroundView.backgroundColor = .white
        itemBackgroundView.layer.borderWidth = 1
        itemBackgroundView.layer.borderColor = UIColor.systemGray.cgColor
        itemBackgroundView.layer.cornerRadius = 8
        itemImageView.layer.cornerRadius = 8
    }
    
    func configure(with urlString: String?) {
        itemImageView.image = nil
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return
        }
        
        itemImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "icon_news"),
            options: [
                .transition(.fade(0.3)),
                .cacheOriginalImage
            ]
        )
    }
}
