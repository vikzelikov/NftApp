//
//  FollowsViewCell.swift
//  Genies
//
//  Created by Yegor on 03.08.2021.
//

import UIKit

class FollowsViewCell: UITableViewCell {

    static let cellIdentifier = String(describing: FollowsViewCell.self)
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
    
    func bind() {
        
    }
    
}
