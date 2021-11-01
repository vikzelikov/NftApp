//
//  NftProfileViewCell.swift
//  NftApp
//
//  Created by Yegor on 24.10.2021.
//

import UIKit

class NftViewCell: UITableViewCell {
    
    static let cellIdentifier = String(describing: NftViewCell.self)

    var typeDetailNFT: TypeDetailNFT = .detail
    
    @IBOutlet weak var influencerImage: UIImageView! {
        didSet {
            influencerImage.layer.cornerRadius = influencerImage.frame.width / 2
        }
    }
    @IBOutlet weak var nftImage: UIImageView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var titleNftLabel: UILabel!
    @IBOutlet weak var expirationLabel: UILabel!
    @IBOutlet weak var expirationView: UIView!
    @IBOutlet weak var influencerLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceFiatLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bind(viewModel: NftViewModel) {
        titleNftLabel?.text = viewModel.edition.name
        priceLabel?.text = String(viewModel.edition.price)
        nftImage.sd_setImage(with: URL(string: viewModel.edition.mediaUrl)!)
//        leftCountLabel?.text = "x\(viewModel.edition.count)"
        
        if typeDetailNFT == .detail {
            expirationView.isHidden = true
        }
    }
    
}
