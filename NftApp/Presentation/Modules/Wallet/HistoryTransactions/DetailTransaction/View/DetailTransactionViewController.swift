//
//  DetailTransactionViewController.swift
//  NftApp
//
//  Created by Yegor on 01.08.2021.
//

import UIKit

class DetailTransactionViewController: UIViewController {
    
    var viewModel: DetailTransactionViewModel? = nil
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var destinationView: UIStackView!
    @IBOutlet weak var checkLinkLabel: UILabel!
    @IBOutlet weak var checkLinkView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.viewDidLoad()
        bindData()
        
        setupStyle()
    }
    
    func bindData() {
        viewModel?.transactionViewModel.bind {
            guard let transactionViewModel = $0 else { return }
                        
            switch transactionViewModel.type {
            case TypeTransactions.buyTokens.rawValue : do {
                self.destinationView.isHidden = true
                self.checkLinkView.isHidden = true
                self.titleLabel?.text = NSLocalizedString("Buy tokens", comment: "")
            }
                
            case TypeTransactions.withdrawTokens.rawValue: do {
                self.checkLinkView.isHidden = true
                self.destinationLabel.text = transactionViewModel.destination ?? "-"
                self.titleLabel?.text = NSLocalizedString("Withdraw tokens", comment: "")
            }
                
            case TypeTransactions.dropshop.rawValue: do {
                self.destinationView.isHidden = true
                self.titleLabel?.text = NSLocalizedString("Dropshop", comment: "")
                
                if let id = transactionViewModel.blockchainTransactionId {
                    self.checkLinkLabel.text = id
                } else {
                    self.checkLinkView.isHidden = true
                }
            }
                
            case TypeTransactions.market.rawValue: do {
                self.destinationView.isHidden = true
                self.checkLinkLabel.text = "true"
                self.titleLabel?.text = NSLocalizedString("Market", comment: "")
                
                if let id = transactionViewModel.blockchainTransactionId {
                    self.checkLinkLabel.text = id
                } else {
                    self.checkLinkView.isHidden = true
                }
            }
                
            default: break
            }

            self.amountLabel.text = String(Int(transactionViewModel.amount))

            let isoDate = transactionViewModel.date
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
                self.dateLabel.text = dayTimePeriodFormatter.string(from: date)
            }
        }
    }
    
    func setupStyle() {
        let checkLinkTap = UITapGestureRecognizer(target: self, action: #selector(checkLinkDidTap(_:)))
        checkLinkView?.isUserInteractionEnabled = true
        checkLinkView?.addGestureRecognizer(checkLinkTap)
    }
    
    @objc func checkLinkDidTap(_ sender: UIButton) {
        guard let id = viewModel?.transactionViewModel.value?.blockchainTransactionId else { return }
        
        if let link = URL(string: "https://flowscan.org/transaction/\(id)") {
            UIApplication.shared.open(link)
        }
    }
    
    @IBAction func dismissDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
        navigationController?.popViewController(animated: true)
    }
    
}
