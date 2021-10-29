//
//  OfferPriceViewCell.swift
//  NftApp
//
//  Created by Yegor on 17.07.2021.
//

import UIKit

class OfferPriceViewCell: UITableViewCell {
    
    static let cellIdentifier = String(describing: OfferPriceViewCell.self)
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupStyle()
    }
    
    private func setupStyle() {
        mainView.layer.shadowColor = UIColor(named: "gray")?.cgColor
        mainView.layer.shadowOpacity = 1
        mainView.layer.shadowOffset = .zero
        mainView.layer.shadowRadius = 4
        
//        buyButton.applyButtonStyle()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bind(viewModel: NftViewModel) {
        
//        priceLabel?.text = viewModel.price
    }
    
    @IBAction func buyButtonDidTap(_ sender: UIButton) {
        sender.isEnabled = false
        sender.loadingIndicator(isShow: true, titleButton: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            sender.loadingIndicator(isShow: false, titleButton: "Get")
            sender.isEnabled = true
        }
    }
    
}
