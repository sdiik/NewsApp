//
//  SectionTableCell.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 23/04/25.
//

import UIKit

class SectionTableCell: UITableViewCell {
    @IBOutlet weak var listCollectionView: UICollectionView!
    
    var newsItems = [Blog]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerCollectionCell()
    }
    
    private func registerCollectionCell() {
        listCollectionView.register(UINib(nibName: "ItemCell", bundle: nil), forCellWithReuseIdentifier: "ItemCell")
        listCollectionView.delegate = self
        listCollectionView.dataSource = self
        listCollectionView.decelerationRate = .fast
    }
    
    internal func setNewsItems(with data: [Blog]) {
        newsItems = data
        listCollectionView.reloadData()
    }
}

extension SectionTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell",
                                                            for: indexPath) as? ItemCell else { return .init() }
        cell.configure(with: newsItems[indexPath.row].imageUrl)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
