//
//  WalletViewController.swift
//  NftApp
//
//  Created by Yegor on 19.07.2021.
//

import UIKit

class WalletViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var fiatBalanceLabel: UILabel!
    @IBOutlet weak var historyTransactions: UIView!
    var items: [SettingCellViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        bindData()
        
        setupStyle()
    }
    
    func bindData() {
        UserObject.user.observe(on: self) { [weak self] userViewModel in
            if let balance = userViewModel?.balance {
                if balance == 0 {
                    self?.balanceLabel.text = "0.0"
                } else {
                    self?.balanceLabel.text = balance.rounded(toPlaces: 2).clean
                }
            }
            
            let currency = InitialDataObject.data.value?.tokenCurrency ?? 0.0
            self?.fiatBalanceLabel.text = "~ \(((userViewModel?.balance ?? 0.0) / currency).rounded(toPlaces: 2).clean) \(NSLocalizedString("RUB", comment: ""))"
        }
    }
    
    @IBAction func addFundsDidTap(_ sender: Any) {
        let vc = AddFundsViewController(nibName: "AddFundsViewController", bundle: nil)
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func withdrawDidTap(_ sender: Any) {
        let vc = WithdrawViewController(nibName: "WithdrawViewController", bundle: nil)
        self.present(vc, animated: true, completion: nil)
    }

    private func setupStyle() {
        scrollView.delaysContentTouches = false
        
        let historyTransactionsTap = UITapGestureRecognizer(target: self, action: #selector(historyTransactionsDidTap(_:)))
        historyTransactions?.isUserInteractionEnabled = true
        historyTransactions?.addGestureRecognizer(historyTransactionsTap)

    }
    
    @objc func historyTransactionsDidTap(_ sender: UITapGestureRecognizer) {
        let viewController = HistoryTransactionsViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func dismissDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)

        navigationController?.popViewController(animated: true)
    }
}
