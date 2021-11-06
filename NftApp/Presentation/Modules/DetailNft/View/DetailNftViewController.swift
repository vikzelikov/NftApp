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
    @IBOutlet weak var expirationLabel: UILabel!
    @IBOutlet weak var ownerLoginContainer: UIStackView!
    @IBOutlet weak var ownerLoginLabel: UILabel!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var leftTagConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightTagConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.viewDidLoad()
        bindData()
        
        setupStyle()
        
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(descriptionDidTap(_:)))
        descriptionLabel?.isUserInteractionEnabled = true
        descriptionLabel?.addGestureRecognizer(tapAction)
    }
    
    func bindData() {
//        viewModel?.isLoading.bind { [weak self] in
//            guard let price = self?.viewModel?.nftViewModel.value?.edition.price else { return }
//            
//            if $0 {
//                self?.buyButton.loadingIndicator(isShow: true, titleButton: nil)
//            } else {
//                self?.buyButton.loadingIndicator(isShow: false, titleButton: "\(price)")
//            }
//        }
        
        viewModel?.errorMessage.bind {
            guard let errorMessage = $0 else { return }
            let alert = UIAlertController(title: "Error Message", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        viewModel?.nftViewModel.bind {
            guard let nftViewModel = $0 else { return }
            self.buyButton?.setTitle("\(Int(nftViewModel.edition.price ?? 0.0))", for: .normal)
            self.titleLabel?.text = nftViewModel.edition.name
            self.descriptionLabel?.text = nftViewModel.edition.description
            self.priceLabel.text = String(Int(nftViewModel.lastPrice ?? 0.0))
            
            if let count = nftViewModel.edition.count, let countNFTs = nftViewModel.edition.countNFTs {
                self.leftCountLabel.text = "x\(count - countNFTs) " + NSLocalizedString("left", comment: "")
            }
            
            if let url = URL(string: nftViewModel.edition.mediaUrl ?? "") {
                self.nftImageView.sd_setImage(with: url)
            }
            
            if let influencer = nftViewModel.edition.influencer?.user {
                self.ownerLoginLabel.text = influencer.login
                
                if let urlString = influencer.avatarUrl, let url = URL(string: urlString) {
                    self.ownerAvatarImage.contentMode = .scaleAspectFill
                    self.ownerAvatarImage.sd_setImage(with: url)
                } else {
                    self.ownerAvatarImage.contentMode = .scaleAspectFit
                    self.ownerAvatarImage.image = UIImage(named: "mini_icon")
                }
            }
        }
        
        viewModel?.expirationTime.bind {
            guard $0 >= 1 else {
//                self.dismiss(animated: true, completion: nil)
                return
            }
            
            let (d, h, m, s) = self.secondsToHoursMinutesSeconds(seconds: Int($0))
            var timeStr = NSLocalizedString("Expiration in", comment: "") + " \(d)d \(h)h \(m)m \(s)s"
            
            if d == 0 {
                timeStr = NSLocalizedString("Expiration in", comment: "") + " \(h)h \(m)m \(s)s"
            }
            
            self.expirationLabel.text = timeStr
        }
    }
    
    private func setupStyle() {
        checkoutView()

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
                expirationLabel.isHidden = true
                moreInfoNftLabel.isHidden = true
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
                expirationLabel.isHidden = false
                ownerLoginContainer.isHidden = false
            
            case .market:
                buyButton.isHidden = false
                moreInfoNftLabel.isHidden = false
                expirationLabel.isHidden = true
                originalTagView.isHidden = true
                leftCountTagView.isHidden = true
        }
    }
    
    func getUrl(stringUrl: String) -> URL? {
        return URL(string: stringUrl)
    }

    
    @IBAction func buyNftDidTap(_ sender: Any) {
        guard let price = viewModel?.nftViewModel.value?.edition.price else { return }
        
        buyButton.loadingIndicator(isShow: true, titleButton: nil)
   
        viewModel?.buyNftDidTap(completion: { _ in
            self.buyButton.loadingIndicator(isShow: false, titleButton: "\(price)")
        })
    }
    
    @objc func ownerLoginDidTap(_ sender: UITapGestureRecognizer) {
        if let influencer = viewModel?.nftViewModel.value?.edition.influencer?.user {
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            guard let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
            vc.viewModel = HomeViewModelImpl()
            vc.viewModel?.userViewModel.value = UserViewModel(id: influencer.id)
            navigationController?.pushViewController(vc, animated: true) ?? present(vc, animated: true, completion: nil)

            HapticHelper.vibro(.light)
        }
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
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int, Int) {
        return (seconds / 86400, (seconds % 86400) / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
}

