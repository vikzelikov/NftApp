//
//  DetailDropViewController.swift
//  Genies
//
//  Created by Yegor on 15.07.2021.
//

import UIKit

class DetailNftViewController: UIViewController {
    
    var clothes: ClothesCellViewModel? = nil
    var isForDropShop: Bool = false

    @IBOutlet weak var clothesImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var originalTagView: UIView!
    @IBOutlet weak var nftTagConstraint: NSLayoutConstraint!
    @IBOutlet weak var nftTagView: UIView!
    @IBOutlet weak var moreInfoNftLabel: UIStackView!
    @IBOutlet weak var expirationDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkoutView()
        
        setupStyle()
        
        if let price = clothes?.price {
            buyButton?.setTitle("\(price)", for: .normal)
        }
            
        titleLabel?.text = clothes?.title
        descriptionLabel?.text = clothes?.description
        if let stringUrl = clothes?.imageUrl {
            if let url = getUrl(stringUrl: stringUrl) {
                clothesImageView.sd_setImage(with: url)
            }
        }
    }
    
    private func setupStyle() {
        buyButton.applyButtonStyle()
        buyButton.applyButtonEffects()
    }
    
    private func checkoutView() {
        if isForDropShop {
            moreInfoNftLabel.isHidden = true
            expirationDateLabel.isHidden = false
        } else {
            moreInfoNftLabel.isHidden = false
            expirationDateLabel.isHidden = true
            
            originalTagView.isHidden = true
            nftTagConstraint.constant = 15
        }
    }
    
    func getUrl(stringUrl: String) -> URL? {
        return URL(string: stringUrl)
    }
    
    @IBAction func tradingHistoryDidTap(_ sender: Any) {
        let vc = TradingHistoryViewController(nibName: "TradingHistoryViewController", bundle: nil)
//        vc.nft = items[indexPath.row]
        self.present(vc, animated: true, completion: nil)
                
        HapticHelper.buttonVibro(.light)
    }
    
    @IBAction func moreOffersDidTap(_ sender: Any) {
        let vc = MoreOffersViewController(nibName: "MoreOffersViewController", bundle: nil)
//        vc.nft = items[indexPath.row]
        self.present(vc, animated: true, completion: nil)
                
        HapticHelper.buttonVibro(.light)
    }
    
    @IBAction func dismissDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

