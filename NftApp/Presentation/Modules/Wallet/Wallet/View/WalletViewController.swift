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
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var settingsHeightTableView: NSLayoutConstraint!
    var items: [SettingCellViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        bindData()
        
        setupStyle()
        
        items.append(SettingCellViewModel(title: NSLocalizedString("History transactions", comment: ""), contentLabel: nil, iconContentView: UIImage(named: "right_arrow")))
//        items.append(SettingCellViewModel(title: "Collection NFTs", contentLabel: nil, iconContentView: UIImage(named: "right_arrow")))
        
        reload()
    }
    
    func bindData() {
        UserObject.user.bind {
            self.balanceLabel.text = String($0?.balance ?? 0.0)
            
            let currency = InitialDataObject.data.value?.tokenCurrency ?? 0.0
            self.fiatBalanceLabel.text = "~ \(((($0?.balance ?? 0.0) / currency) * 100) / 100) \(NSLocalizedString("RUB", comment: ""))"
        }
    }
    
    func reload() {
        settingsTableView.reloadData()
    }
    
    @IBAction func addFundsDidTap(_ sender: Any) {
        let vc = AddFundsViewController(nibName: "AddFundsViewController", bundle: nil)
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func withdrawDidTap(_ sender: Any) {
        let vc = WithdrawViewController(nibName: "WithdrawViewController", bundle: nil)
        self.present(vc, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        settingsHeightTableView.constant = settingsTableView.contentSize.height
    }
    
    private func setupStyle() {
        scrollView.delaysContentTouches = false

        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        
        settingsTableView.estimatedRowHeight = settingsTableView.rowHeight
        settingsTableView.rowHeight = 60.0
        settingsTableView.separatorColor = UIColor.lightGray.withAlphaComponent(0.3)
        settingsTableView.separatorStyle = .singleLine
        settingsTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: settingsTableView.frame.size.width, height: 1))
        settingsTableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        settingsTableView.register(UINib(nibName: SettingViewCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: SettingViewCell.cellIdentifier)
        
        if #available(iOS 15.0, *) {
            settingsTableView.sectionHeaderTopPadding = 0.0
        }
    }
    
    @IBAction func dismissDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)

        navigationController?.popViewController(animated: true)
    }
}

extension WalletViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let viewController = HistoryTransactionsViewController()
            navigationController?.pushViewController(viewController, animated: true)
        case 1:
            let viewController = CollectionNftViewController()
            navigationController?.pushViewController(viewController, animated: true)
        default:
            let viewController = HistoryTransactionsViewController()
            navigationController?.pushViewController(viewController, animated: true)
        }

        tableView.deselectRow(at: indexPath, animated: true)
        HapticHelper.vibro(.light)
    }
}

extension WalletViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingViewCell", for: indexPath) as? SettingViewCell else {
            assertionFailure("Cannot dequeue reusable cell")
            return UITableViewCell()
        }
        
        cell.backgroundColor = UIColor(named: "clear")
        cell.selectionStyle = UITableViewCell.SelectionStyle.default

        cell.bind(viewModel: items[indexPath.row])
                
        return cell
    }
}
