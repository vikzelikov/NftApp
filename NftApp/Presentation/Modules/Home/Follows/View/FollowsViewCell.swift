//
//  FollowsViewCell.swift
//  NftApp
//
//  Created by Yegor on 03.08.2021.
//

import UIKit

class FollowsViewCell: UITableViewCell {

    static let cellIdentifier = String(describing: FollowsViewCell.self)
    
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

        if let avatarUrl = viewModel.avatarUrl, let url = URL(string: avatarUrl) {
            userImageView.contentMode = .scaleAspectFill
            userImageView.load(with: url)
        } else {
            userImageView.image = UIImage(named: "mini_icon")
        }
    }
    
}
