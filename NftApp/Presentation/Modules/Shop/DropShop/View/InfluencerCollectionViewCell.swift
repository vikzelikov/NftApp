//
//  InfluencerCollectionViewCell.swift
//  NftApp
//
//  Created by Yegor on 01.10.2021.
//

import UIKit

class InfluencerCollectionViewCell: UICollectionViewCell {

    static let cellIdentifier = String(describing: InfluencerCollectionViewCell.self)
    
    var isAll: Bool = false
    
    @IBOutlet weak var userImageView: UIImageView! {
        didSet {
            userImageView.layer.cornerRadius = userImageView.frame.width / 2
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bind(viewModel: UserViewModel?) {
//        mainView.layer.shadowColor = UIColor(named: "gray")?.cgColor
//        mainView.layer.shadowOpacity = 1
//        mainView.layer.shadowOffset = .zero
//        mainView.layer.shadowRadius = 5
        userImageView.isHidden = false
        
        nameLabel?.text = viewModel?.login
        if let avatarUrl = viewModel?.avatarUrl, let url = URL(string: avatarUrl) {
            userImageView.contentMode = .scaleAspectFill
            userImageView.load(with: url)
        } else {
            userImageView.contentMode = .scaleAspectFit
            userImageView.image = UIImage(named: "mini_icon")
        }
    }
    
    func setupAll() {
//        mainView.layer.shadowColor = UIColor(named: "gray")?.cgColor
//        mainView.layer.shadowOpacity = 1
//        mainView.layer.shadowOffset = .zero
//        mainView.layer.shadowRadius = 5
        
        nameLabel.text = NSLocalizedString("All", comment: "")
        userImageView.isHidden = true
    }

}
