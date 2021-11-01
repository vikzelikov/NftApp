//
//  InfluencerViewCell.swift
//  NftApp
//
//  Created by Yegor on 31.10.2021.
//

import UIKit

class InfluencerViewCell: UITableViewCell {

    static let cellIdentifier = String(describing: InfluencerViewCell.self)
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView! {
        didSet {
            userImageView.layer.cornerRadius = userImageView.frame.width / 2
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bind(viewModel: UserViewModel) {
        loginLabel?.text = viewModel.login
//        userImageView.sd_setImage(with: URL(string: viewModel.edition.mediaUrl)!)
    }
    
}
