//
//  TransactionViewCell.swift
//  NftApp
//
//  Created by Yegor on 01.08.2021.
//

import UIKit

class TransactionViewCell: UITableViewCell {

    static let cellIdentifier = String(describing: TransactionViewCell.self)

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bind() {
        
    }
    
}
