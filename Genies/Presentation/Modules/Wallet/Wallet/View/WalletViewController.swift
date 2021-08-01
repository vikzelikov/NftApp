//
//  WalletViewController.swift
//  Genies
//
//  Created by Yegor on 19.07.2021.
//

import UIKit

class WalletViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var settingsHeightTableView: NSLayoutConstraint!
    var items: [SettingCellViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.delaysContentTouches = false
        
        setupSettingsTableView()
        
        items.append(SettingCellViewModel(title: "History transactions", contentLabel: nil, iconContentView: UIImage(named: "right_arrow")))
        items.append(SettingCellViewModel(title: "Collection NFTs", contentLabel: nil, iconContentView: UIImage(named: "right_arrow")))
        
        reload()
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
    
    private func setupSettingsTableView() {
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        
        settingsTableView.estimatedRowHeight = settingsTableView.rowHeight
        settingsTableView.rowHeight = 60.0
        settingsTableView.separatorColor = UIColor.lightGray.withAlphaComponent(0.3)
        settingsTableView.separatorStyle = .singleLine
        settingsTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: settingsTableView.frame.size.width, height: 1))
        settingsTableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        settingsTableView.register(UINib(nibName: "SettingViewCell", bundle: nil), forCellReuseIdentifier: SettingViewCell.cellIdentifier)
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
            print(1)
        }

        tableView.deselectRow(at: indexPath, animated: true)
        HapticHelper.buttonVibro(.light)
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
        
        cell.backgroundColor = UIColor(named: "gray")
        cell.selectionStyle = UITableViewCell.SelectionStyle.default

        cell.bind(viewModel: items[indexPath.row])
                
        return cell
    }
}
