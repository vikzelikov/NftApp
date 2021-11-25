//
//  TransactionViewCell.swift
//  NftApp
//
//  Created by Yegor on 01.08.2021.
//

import UIKit

class TransactionViewCell: UITableViewCell {

    static let cellIdentifier = String(describing: TransactionViewCell.self)

    @IBOutlet weak var imageTransaction: UIImageView! {
        didSet {
            imageTransaction.layer.cornerRadius = imageTransaction.frame.width / 2
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bind(viewModel: TransactionViewModel) {
        var prefixAmount = ""
        
        switch viewModel.type {
        case TypeTransactions.buyTokens.rawValue : do {
            prefixAmount = "+"
            subtitleLabel.isHidden = true
            titleLabel?.text = NSLocalizedString("Purchase of Tokens", comment: "")
        }
            
        case TypeTransactions.withdrawTokens.rawValue : do {
            prefixAmount = "-"
            subtitleLabel.isHidden = true
            titleLabel?.text = NSLocalizedString("Withdraw tokens", comment: "")
        }
            
        case TypeTransactions.dropshop.rawValue : do {
            prefixAmount = "-"
            subtitleLabel.isHidden = true
            titleLabel?.text = NSLocalizedString("Dropshop", comment: "")
        }
            
        case TypeTransactions.market.rawValue : do {
            prefixAmount = "+"
            subtitleLabel.isHidden = true
            titleLabel?.text = NSLocalizedString("Market", comment: "")
        }
            
        default : do {}
        }

        amountLabel.text = prefixAmount + String(Int(viewModel.amount))

        let isoDate = viewModel.date
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        isoDateFormatter.formatOptions = [
            .withFullDate,
            .withFullTime,
            .withDashSeparatorInDate,
            .withFractionalSeconds]

        if let unixTime = isoDateFormatter.date(from: isoDate)?.timeIntervalSince1970 {
            let date = Date(timeIntervalSince1970: unixTime)
            let dayTimePeriodFormatter = DateFormatter()
            dayTimePeriodFormatter.dateFormat = "dd-MM-YYYY HH:mm"
            dateLabel.text = dayTimePeriodFormatter.string(from: date)
        }
    }
    
}
