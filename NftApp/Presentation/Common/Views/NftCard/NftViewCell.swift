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
    var removeItem: (() -> Void)?

    private var timer: Timer?
    private var expirationTime: Int = 0
    private var expiryTimeInterval: Int? {
        didSet {
            startTimer()
        }
    }

    @IBOutlet weak var influencerImage: UIImageView! {
        didSet {
            influencerImage.layer.cornerRadius = influencerImage.frame.width / 2
        }
    }
    @IBOutlet weak var view: UIView!
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
    
    func bindNft(viewModel: Nft) {
        if typeDetailNFT == .detail {
            let price = Int(viewModel.lastPrice)
            priceLabel?.text = "\(price) T"
        }
        
        setEdition(viewModel: viewModel.edition)
    }
    
    func bindEdition(viewModel: Edition) {
        setEdition(viewModel: viewModel)
    }

    private func setEdition(viewModel: Edition) {
        titleNftLabel?.text = viewModel.name
        
        if typeDetailNFT == .dropShop {
            let price = Int(viewModel.price ?? 0.0)
            let currency = InitialDataObject.data.value?.tokenCurrency ?? 0.0
            priceLabel?.text = "\(price) T"
            priceFiatLabel?.text = "\((Double(price) / currency).rounded(toPlaces: 2))"
                + "\(NSLocalizedString("RUB", comment: ""))"
        }
        
        if let url = URL(string: viewModel.mediaUrl) {
            nftImage.load(with: url)
        }
        
        if let influencer = viewModel.influencer?.user {
            influencerLabel.text = influencer.login
            
            if let urlString = influencer.avatarUrl, let url = URL(string: urlString) {
                influencerImage.contentMode = .scaleAspectFill
                influencerImage.load(with: url)
                
            } else {
                influencerImage.contentMode = .scaleAspectFit
                influencerImage.image = UIImage(named: "mini_icon")
            }
        }
        
        if typeDetailNFT == .dropShop {
            if let dateExpiration = TimeInterval(viewModel.dateExpiration) {
                let timeInterval = NSDate().timeIntervalSince1970
                let exp = dateExpiration / 1000
                
                if timeInterval < exp {
                    expirationView.isHidden = false
                } else {
                    expirationView.isHidden = true
                }
                
                let del = Int((exp - timeInterval))
                expiryTimeInterval = del

                setTime(dTime: del)
            }
        } else {
            expirationView.isHidden = true
        }
    }
    
    private func startTimer() {
        if let interval = expiryTimeInterval {
            expirationTime = interval
            
            timer = Timer.scheduledTimer(
                timeInterval: 1.0,
                target: self,
                selector: #selector(onComplete),
                userInfo: nil,
                repeats: true
            )
            
            guard let t = timer else { return }
            RunLoop.current.add(t, forMode: RunLoop.Mode.common)
        }
    }

    @objc func onComplete() {
        guard expirationTime >= 1 else {
            removeItem?()
            timer?.invalidate()
            timer = nil
            return
        }
        
        expirationTime -= 1
        
        setTime(dTime: expirationTime)
    }
    
    func setTime(dTime: Int) {
        let (d, h, m, s) = (dTime / 86400, (dTime % 86400) / 3600, (dTime % 3600) / 60, (dTime % 3600) % 60)
        var timeStr = "\(d)d \(h)h \(m)m \(s)s"
        
        if d == 0 {
            timeStr = "\(h)h \(m)m \(s)s"
        }
        
        expirationLabel.text = timeStr
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        timer?.invalidate()
        timer = nil
    }
    
}
