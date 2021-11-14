//
//  PlaceholderViewCell.swift
//  NftApp
//
//  Created by Yegor on 14.11.2021.
//

import UIKit

class PlaceholderViewCell: UITableViewCell {

    static let cellIdentifier = String(describing: PlaceholderViewCell.self)

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
