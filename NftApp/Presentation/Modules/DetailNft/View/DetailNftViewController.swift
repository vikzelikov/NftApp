//
//  DetailDropViewController.swift
//  NftApp
//
//  Created by Yegor on 15.07.2021.
//

import UIKit
import SDWebImage

class DetailNftViewController: UIViewController {
    
    var viewModel: DetailNftViewModel? = nil
    
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
    @IBOutlet weak var leftCountTagView: UIView!
    @IBOutlet weak var leftCountLabel: UILabel!
    @IBOutlet weak var moreInfoNftLabel: UIStackView!
    @IBOutlet weak var moreOffersButton: UIButton!
    @IBOutlet weak var expirationDateLabel: UILabel!
    @IBOutlet weak var ownerLoginContainer: UIStackView!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var leftTagConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightTagConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        
        bindData()
        
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(descriptionDidTap(_:)))
        descriptionLabel?.isUserInteractionEnabled = true
        descriptionLabel?.addGestureRecognizer(tapAction)
    }
    
    func bindData() {
        viewModel?.isLoading.bind { [weak self] in
            guard let price = self?.viewModel?.nftViewModel.value?.edition.price else { return }
            
            if $0 {
                self?.buyButton.loadingIndicator(isShow: true, titleButton: nil)
            } else {
                self?.buyButton.loadingIndicator(isShow: false, titleButton: "\(price)")
            }
        }
        
        viewModel?.errorMessage.bind {
            guard let errorMessage = $0 else { return }
            let alert = UIAlertController(title: "Error Message", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        viewModel?.nftViewModel.bind {
            guard let nftViewModel = $0 else { return }
            self.buyButton?.setTitle("\(nftViewModel.edition.price)", for: .normal)
            self.titleLabel?.text = nftViewModel.edition.name
            self.descriptionLabel?.text = nftViewModel.edition.description
            self.nftImageView.sd_setImage(with: URL(string: nftViewModel.edition.mediaUrl)!)
            self.leftCountLabel.text = "x\(nftViewModel.edition.count) " + NSLocalizedString("left", comment: "")
        }
    }
    
    private func setupStyle() {
        checkoutView()

        buyButton.applyButtonStyle()
        buyButton.applyButtonEffects()
        
        let ownerLoginTap = UITapGestureRecognizer(target: self, action: #selector(ownerLoginDidTap(_:)))
        ownerLoginContainer?.isUserInteractionEnabled = true
        ownerLoginContainer?.addGestureRecognizer(ownerLoginTap)
    }
    
    private func checkoutView() {
        guard let typeDetailNFT = viewModel?.typeDetailNFT else { return }
        
        switch typeDetailNFT {
            case .detail:
                leftCountTagView.isHidden = true
                moreOffersButton.isHidden = true
                originalTagView.isHidden = true
                expirationDateLabel.isHidden = true
                moreInfoNftLabel.isHidden = false
                buyButton.isHidden = true
                priceView.isHidden = false
                dismissButton.isHidden = true
                backButton.isHidden = false
                leftTagConstraint.isActive = false
                rightTagConstraint.constant = 15
                rightTagConstraint.priority = .required

            case .dropShop:
                buyButton.isHidden = false
                moreInfoNftLabel.isHidden = true
                expirationDateLabel.isHidden = false
                ownerLoginContainer.isHidden = true
            
            case .market:
                buyButton.isHidden = false
                moreInfoNftLabel.isHidden = false
                expirationDateLabel.isHidden = true
                originalTagView.isHidden = true
                leftCountTagView.isHidden = true
        }
    }
    
    func getUrl(stringUrl: String) -> URL? {
        return URL(string: stringUrl)
    }
    
    @IBAction func buyNftDidTap(_ sender: Any) {
        viewModel?.buyNftDidTap()
    }
    
    @objc func ownerLoginDidTap(_ sender: UITapGestureRecognizer) {
        // with user id
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        guard let profilePage = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
        profilePage.isOtherUser = true
        navigationController?.pushViewController(profilePage, animated: true) ?? present(profilePage, animated: true, completion: nil)

        HapticHelper.vibro(.light)
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
    
    @objc func descriptionDidTap(_ sender: UITapGestureRecognizer) {
        let vc = DetailDescriptionViewController()
        vc.descriptionNft = viewModel?.nftViewModel.value?.edition.description
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func dismissDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

