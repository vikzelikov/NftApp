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
    
    func bindNft(viewModel: NftViewModel) {
        titleNftLabel?.text = viewModel.edition.name
        
        let price = Int(viewModel.price ?? 0.0)
        let currency = InitialDataObject.data.value?.tokenCurrency ?? 0.0
        priceLabel?.text = "\(price) T"
        priceFiatLabel?.text = "\((Double(price) / currency).rounded(toPlaces: 2)) \(NSLocalizedString("RUB", comment: ""))"
        
        if let urlString = viewModel.edition.mediaUrl, let url = URL(string: urlString) {
            nftImage.load(with: url)
        }
        
        if typeDetailNFT == .detail {
            expirationView.isHidden = true
        }
        
        if let influencer = viewModel.edition.influencer?.user {
            influencerLabel.text = influencer.login
            
            if let urlString = influencer.avatarUrl, let url = URL(string: urlString) {
                influencerImage.contentMode = .scaleAspectFill
                influencerImage.load(with: url)
            } else {
                influencerImage.contentMode = .scaleAspectFit
                influencerImage.image = UIImage(named: "mini_icon")
            }
        }
    }
    
    func bindEdition(viewModel: EditionViewModel) {
        titleNftLabel?.text = viewModel.name
        
        let price = Int(viewModel.price ?? 0.0)
        let currency = InitialDataObject.data.value?.tokenCurrency ?? 0.0
        priceLabel?.text = "\(price) T"
        priceFiatLabel?.text = "\((Double(price) / currency).rounded(toPlaces: 2)) \(NSLocalizedString("RUB", comment: ""))"
        
        if let urlString = viewModel.mediaUrl, let url = URL(string: urlString) {
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

        if let exp = viewModel.dateExpiration, let dateExpiration = TimeInterval(exp) {
            let timeInterval = NSDate().timeIntervalSince1970
            let exp = dateExpiration / 1000
            
            let del = Int((exp - timeInterval))
            expiryTimeInterval = del

            setTime(deltaTime: del)
        }
    }
    
    private func startTimer() {
        if let interval = expiryTimeInterval {
            expirationTime = interval
            
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onComplete), userInfo: nil, repeats: true)
            
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
        
        setTime(deltaTime: expirationTime)
    }
    
    func setTime(deltaTime: Int) {
        let (d, h, m, s) = secondsToHoursMinutesSeconds(seconds: Int(deltaTime))
        var timeStr = "\(d)d \(h)h \(m)m \(s)s"
        
        if d == 0 {
            timeStr = "\(h)h \(m)m \(s)s"
        }
        
        expirationLabel.text = timeStr
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int, Int) {
        return (seconds / 86400, (seconds % 86400) / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        timer?.invalidate()
        timer = nil
    }
    
}
