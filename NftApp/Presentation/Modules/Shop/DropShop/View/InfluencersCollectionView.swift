//
//  InfluencersViewCell.swift
//  NftApp
//
//  Created by Yegor on 01.10.2021.
//

import UIKit

class InfluencersCollectionView: UITableViewCell {
    
    static let cellIdentifier = String(describing: InfluencersCollectionView.self)

    @IBOutlet weak var collectionView: UICollectionView!

    func reload() {
        collectionView.reloadData()
    }
    
}

extension InfluencersCollectionView {

    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.setContentOffset(collectionView.contentOffset, animated: false)
        collectionView.reloadData()
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        collectionView.register(UINib(nibName: InfluencerCollectionViewCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: InfluencerCollectionViewCell.cellIdentifier)
    }

    var collectionViewOffset: CGFloat {
        set { collectionView.contentOffset.x = newValue }
        get { return collectionView.contentOffset.x }
    }
    
}
