//
//  OfferPriceViewCell.swift
//  Genies
//
//  Created by Yegor on 17.07.2021.
//

import UIKit

class OfferPriceViewCell: UITableViewCell {
    
    
    static let cellIdentifier = String(describing: OfferPriceViewCell.self)
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bind(viewModel: NftCellViewModel) {
//        priceLabel?.text = viewModel.price
    }
    
    @IBAction func buyButtonDidTap(_ sender: UIButton) {
        HapticHelper.buttonVibro(.light)
        sender.isEnabled = false
        sender.loadingIndicator(isShow: true, titleButton: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            sender.loadingIndicator(isShow: false, titleButton: "Get")
            sender.isEnabled = true
        }
    }
    
}
