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
    
    func bindNft(viewModel: NftViewModel) {
        titleNftLabel?.text = viewModel.edition.name
        priceLabel?.text = String(viewModel.edition.price)
        nftImage.sd_setImage(with: URL(string: viewModel.edition.mediaUrl)!)
//        leftCountLabel?.text = "x\(viewModel.edition.count)"
        
        if typeDetailNFT == .detail {
            expirationView.isHidden = true
        }
    }
    
    func bindEdition(viewModel: EditionViewModel) {
        titleNftLabel?.text = viewModel.name
        priceLabel?.text = String(viewModel.price)
//        let date = Date(timeIntervalSince1970: viewModel.dateExpiration!)
//
//        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: "en_US_POSIX")
//        formatter.dateFormat = "HH:mm:ss"
//        let string: String = formatter.string(from: date)
        
        
        let timeInterval = NSDate().timeIntervalSince1970

        let dateExpiration = TimeInterval(viewModel.dateExpiration)! / 1000
        let delta = (dateExpiration - timeInterval) / 86400
        expirationLabel.text = String(delta)
        nftImage.sd_setImage(with: URL(string: viewModel.mediaUrl)!)
//        leftCountLabel?.text = "x\(viewModel.edition.count)"
        
        if typeDetailNFT == .detail {
            expirationView.isHidden = true
        }
    }
    
}
