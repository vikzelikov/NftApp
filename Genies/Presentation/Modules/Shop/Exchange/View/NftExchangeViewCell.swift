//
//  NftExchangeViewCell.swift
//  Genies
//
//  Created by Yegor on 16.07.2021.
//

import UIKit

class NftExchangeViewCell: UITableViewCell {
    
    static let cellIdentifier = String(describing: NftExchangeViewCell.self)

    @IBOutlet weak var nftImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bind(viewModel: NftCellViewModel) {
        titleLabel?.text = viewModel.title
        priceLabel?.text = viewModel.price
        if let stringUrl = viewModel.imageUrl {
            if let url = getUrl(stringUrl: stringUrl) {
                nftImageView.sd_setImage(with: url)
            }
        }
    }
    
    func getUrl(stringUrl: String) -> URL? {
        return URL(string: stringUrl)
    }
    
}
