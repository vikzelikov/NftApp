//
//  DetailDropViewController.swift
//  Genies
//
//  Created by Yegor on 15.07.2021.
//

import UIKit

class DetailNftViewController: UIViewController {
    
    var nftCellViewModel: NftCellViewModel? = nil
    
    enum TypeDetailNFT {
        case detail
        case dropShop
        case exchange
    }
    
    var typeDetailNFT: TypeDetailNFT = TypeDetailNFT.detail

    @IBOutlet weak var ownerAvatarImage: UIImageView! {
        didSet {
            ownerAvatarImage.layer.cornerRadius = ownerAvatarImage.frame.width / 2
        }
    }
    @IBOutlet weak var nftImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var originalTagView: UIView!
    @IBOutlet weak var nftTagView: UIView!
    @IBOutlet weak var leftNumberTagView: UIView!
    @IBOutlet weak var moreInfoNftLabel: UIStackView!
    @IBOutlet weak var moreOffersButton: UIButton!
    @IBOutlet weak var expirationDateLabel: UILabel!
    @IBOutlet weak var ownerLoginContainer: UIStackView!
    @IBOutlet weak var priceView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkoutView()
        
        setupStyle()
        
        if let price = nftCellViewModel?.price {
            buyButton?.setTitle("\(price)", for: .normal)
        }
            
        titleLabel?.text = nftCellViewModel?.title
        descriptionLabel?.text = nftCellViewModel?.description
        if let stringUrl = nftCellViewModel?.imageUrl {
            if let url = getUrl(stringUrl: stringUrl) {
                nftImageView.sd_setImage(with: url)
            }
        }
    }
    
    private func setupStyle() {
        buyButton.applyButtonStyle()
        buyButton.applyButtonEffects()
        
        let ownerLoginTap = UITapGestureRecognizer(target: self, action: #selector(ownerLoginDidTap(_:)))
        ownerLoginContainer?.isUserInteractionEnabled = true
        ownerLoginContainer?.addGestureRecognizer(ownerLoginTap)
    }
    
    @objc func ownerLoginDidTap(_ sender: UITapGestureRecognizer) {
        // with user id
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        guard let profilePage = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
        profilePage.isOtherUser = true
        present(profilePage, animated: true, completion: nil)
                
        HapticHelper.vibro(.light)
    }
    
    private func checkoutView() {
        switch typeDetailNFT {
            case .detail:
                leftNumberTagView.isHidden = true
                moreOffersButton.isHidden = true
                originalTagView.isHidden = true
                expirationDateLabel.isHidden = true
                moreInfoNftLabel.isHidden = false
                buyButton.isHidden = true
                priceView.isHidden = false

            case .dropShop:
                buyButton.isHidden = false
                moreInfoNftLabel.isHidden = true
                expirationDateLabel.isHidden = false
                ownerLoginContainer.isHidden = true
            
            case .exchange:
                buyButton.isHidden = false
                moreInfoNftLabel.isHidden = false
                expirationDateLabel.isHidden = true
                originalTagView.isHidden = true
                leftNumberTagView.isHidden = true
        }
    }
    
    func getUrl(stringUrl: String) -> URL? {
        return URL(string: stringUrl)
    }
    
    @IBAction func tradingHistoryDidTap(_ sender: Any) {
        let vc = TradingHistoryViewController(nibName: "TradingHistoryViewController", bundle: nil)
//        vc.nft = items[indexPath.row]
        self.present(vc, animated: true, completion: nil)
                
        HapticHelper.vibro(.light)
    }
    
    @IBAction func moreOffersDidTap(_ sender: Any) {
        let vc = MoreOffersViewController(nibName: "MoreOffersViewController", bundle: nil)
//        vc.nft = items[indexPath.row]
        self.present(vc, animated: true, completion: nil)
                
        HapticHelper.vibro(.light)
    }
    
    @IBAction func dismissDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
        navigationController?.popViewController(animated: true)
    }
    
}

