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
    private var deltaTime: Int = 0
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
        
        if typeDetailNFT == .detail {
            expirationView.isHidden = true
        }
    }
    
    func bindEdition(viewModel: EditionViewModel) {
        titleNftLabel?.text = viewModel.name
        priceLabel?.text = String(viewModel.price)
        nftImage.sd_setImage(with: URL(string: viewModel.mediaUrl)!)

        if let dateExpiration = TimeInterval(viewModel.dateExpiration) {
            let timeInterval = NSDate().timeIntervalSince1970
            let exp = dateExpiration / 1000
            
            let del = Int((exp - timeInterval))
            expiryTimeInterval = del

            setTime(deltaTime: del)
        }
    }
    
    private func startTimer() {
        if let interval = expiryTimeInterval {
            deltaTime = interval
            
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onComplete), userInfo: nil, repeats: true)
            
            guard let t = timer else { return }
            RunLoop.current.add(t, forMode: RunLoop.Mode.common)
        }
    }

    @objc func onComplete() {
        guard deltaTime >= 1 else {
            removeItem?()
            timer?.invalidate()
            timer = nil
            return
        }
        
        deltaTime -= 1
        
        setTime(deltaTime: deltaTime)
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
