//
//  ClothesViewCell.swift
//  NftApp
//
//  Created by Yegor on 14.07.2021.
//

import UIKit
import SDWebImage

class NftDropViewCell: UITableViewCell {
    
    static let cellIdentifier = String(describing: NftDropViewCell.self)

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
    
    func bind(viewModel: NftCellViewModel) {
        mainView.layer.shadowColor = UIColor(named: "gray")?.cgColor
        mainView.layer.shadowOpacity = 1
        mainView.layer.shadowOffset = .zero
        mainView.layer.shadowRadius = 5
        nftImageView.layer.cornerRadius = 12
        
        titleLabel?.text = viewModel.title
        priceLabel?.text = viewModel.price
        if let url = viewModel.imageUrl {
            nftImageView.sd_setImage(with: URL(string: url)!)
        }
    }
    
    func getUrl(stringUrl: String) -> URL? {
        return URL(string: stringUrl)
    }
}
