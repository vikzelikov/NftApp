//
//  InfluencerCollectionViewCell.swift
//  NftApp
//
//  Created by Yegor on 01.10.2021.
//

import UIKit

class InfluencerCollectionViewCell: UICollectionViewCell {

    static let cellIdentifier = String(describing: InfluencerCollectionViewCell.self)
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bind() {
        mainView.layer.shadowColor = UIColor(named: "gray")?.cgColor
        mainView.layer.shadowOpacity = 1
        mainView.layer.shadowOffset = .zero
//        mainView.layer.shadowRadius = 5
        userImageView.layer.cornerRadius = userImageView.frame.width / 2

        nameLabel?.text = "Bloger #1"
    }

}
