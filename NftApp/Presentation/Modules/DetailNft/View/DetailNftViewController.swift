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
            self.buyButton?.setTitle("\(Int(nftViewModel.edition.price))", for: .normal)
            self.titleLabel?.text = nftViewModel.edition.name
            self.descriptionLabel?.text = nftViewModel.edition.description
            self.nftImageView.sd_setImage(with: URL(string: nftViewModel.edition.mediaUrl)!)
            self.leftCountLabel.text = "x\(nftViewModel.edition.count - nftViewModel.edition.countNFTs) " + NSLocalizedString("left", comment: "")
            
            if let dateExpiration = TimeInterval($0?.edition.dateExpiration ?? "0") {
                let timeInterval = NSDate().timeIntervalSince1970
                let exp = dateExpiration / 1000
                
                let del = Int((exp - timeInterval))
                self.expiryTimeInterval = del

                self.setTime(deltaTime: del)
            }
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
    private var timer: Timer?
    private var deltaTime: Int = 0
    private var expiryTimeInterval: Int? {
        didSet {
            startTimer()
        }
    }
    func startTimer() {
        if let interval = expiryTimeInterval {
            deltaTime = interval
            
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onComplete), userInfo: nil, repeats: true)
            
            guard let t = timer else { return }
            RunLoop.current.add(t, forMode: RunLoop.Mode.common)
        }
    }

    @objc func onComplete() {
        guard deltaTime >= 1 else {
            dismiss(animated: true, completion: nil)
            timer?.invalidate()
            timer = nil
            return
        }
        
        deltaTime -= 1
        
        setTime(deltaTime: deltaTime)
    }
    
    func setTime(deltaTime: Int) {
        let (d, h, m, s) = secondsToHoursMinutesSeconds(seconds: Int(deltaTime))
        var timeStr = NSLocalizedString("Expiration in", comment: "") + " \(d)d \(h)h \(m)m \(s)s"
        
        if d == 0 {
            timeStr = NSLocalizedString("Expiration in", comment: "") + " \(h)h \(m)m \(s)s"
        }
        
        expirationLabel.text = timeStr
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int, Int) {
        return (seconds / 86400, (seconds % 86400) / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    @IBAction func buyNftDidTap(_ sender: Any) {
        viewModel?.buyNftDidTap()
    }
    
    @objc func ownerLoginDidTap(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
        vc.viewModel = HomeViewModelImpl()
        vc.viewModel?.userViewModel.value = nil
        navigationController?.pushViewController(vc, animated: true) ?? present(vc, animated: true, completion: nil)

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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        timer?.invalidate()
        timer = nil
    }
    
}

