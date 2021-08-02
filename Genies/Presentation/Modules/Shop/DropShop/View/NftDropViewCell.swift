//
//  ClothesViewCell.swift
//  Genies
//
//  Created by Yegor on 14.07.2021.
//

import UIKit
import SDWebImage

class NftDropViewCell: UITableViewCell {
    
    static let cellIdentifier = String(describing: NftDropViewCell.self)

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var clothesImageView: UIImageView!
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
        
        titleLabel?.text = viewModel.title
        priceLabel?.text = viewModel.price
        if let stringUrl = viewModel.imageUrl {
            if let url = getUrl(stringUrl: stringUrl) {
                clothesImageView.sd_setImage(with: url)
            }
        }
    }
    
    func getUrl(stringUrl: String) -> URL? {
        return URL(string: stringUrl)
    }
}
