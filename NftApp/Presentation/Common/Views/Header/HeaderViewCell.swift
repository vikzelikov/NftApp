//
//  HeaderViewCell.swift
//  NftApp
//
//  Created by Yegor on 12.11.2021.
//

import UIKit

class HeaderViewCell: UITableViewCell {

    static let cellIdentifier = String(describing: HeaderViewCell.self)
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var rightArrow: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bind(title: String, showArrow: Bool = false) {
        headerLabel.text = title
        rightArrow.isHidden = !showArrow
    }
    
}
