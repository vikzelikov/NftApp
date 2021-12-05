//
//  HistoryViewCell.swift
//  NftApp
//
//  Created by Yegor on 17.07.2021.
//

import UIKit

class HistoryViewCell: UITableViewCell {
    
    static let cellIdentifier = String(describing: HistoryViewCell.self)

    @IBOutlet weak var loginOwnerLabel: UILabel!
    @IBOutlet weak var datePurchase: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bind(viewModel: HistoryCellViewModel) {
//        titleLabel?.text = viewModel.title
//        priceLabel?.text = viewModel.price
    }
    
}
