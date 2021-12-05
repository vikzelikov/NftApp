//
//  NftExchangeViewCell.swift
//  NftApp
//
//  Created by Yegor on 16.07.2021.
//

import UIKit

class NftMarketViewCell: UITableViewCell {
    
    static let cellIdentifier = String(describing: NftMarketViewCell.self)

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var nftImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bind(viewModel: Nft) {
        mainView.layer.shadowColor = UIColor(named: "gray")?.cgColor
        mainView.layer.shadowOpacity = 1
        mainView.layer.shadowOffset = .zero
        mainView.layer.shadowRadius = 5

        
        titleLabel?.text = viewModel.edition.name
//        priceLabel?.text = "\(viewModel.price ?? 0.0)"
//        if let stringUrl = viewModel.imageUrl {
//            if let url = getUrl(stringUrl: stringUrl) {
//                nftImageView.load(with: url)
//            }
//        }
    }
    
    func getUrl(stringUrl: String) -> URL? {
        return URL(string: stringUrl)
    }
    
}
