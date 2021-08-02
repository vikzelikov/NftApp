//
//  ProfileViewController.swift
//  Genies
//
//  Created by Yegor on 18.07.2021.
//

import UIKit

class SettingsViewController: UIViewController {


    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var walletButton: UIButton!
    @IBOutlet weak var telegramButton: UIButton!
    @IBOutlet weak var personalDataTableView: UITableView!
    @IBOutlet weak var otherSettingsTableView: UITableView!
    @IBOutlet weak var heightPersonalDataTableView: NSLayoutConstraint!
    @IBOutlet weak var heightOtherSettingsTableView: NSLayoutConstraint!
    var items: [SettingCellViewModel] = []
    var items1: [SettingCellViewModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.delaysContentTouches = false
        
        walletButton.applyButtonStyle()
        walletButton.applyButtonEffects()

        setupPersonalDataTableView()
        
        setupOtherSettingsTableView()
        
        
        
        items.append(SettingCellViewModel(title: "E-mail", contentLabel: "vikzeawhjhjhbjhbhhghlikov@yandex.ru", iconContentView: nil))
        items.append(SettingCellViewModel(title: "Password", contentLabel: nil, iconContentView: UIImage(named: "right_arrow")))
        items.append(SettingCellViewModel(title: "Pin code", contentLabel: nil, iconContentView: UIImage(named: "right_arrow")))
        
        items1.append(SettingCellViewModel(title: "Contact developer", contentLabel: nil, iconContentView: UIImage(named: "mail")))
        items1.append(SettingCellViewModel(title: "Share application", contentLabel: nil, iconContentView: UIImage(named: "share")))

    
        
        telegramButton.layer.cornerRadius = telegramButton.frame.width / 2

        reload()
    }
    
    @IBAction func walletButtonDidTap(_ sender: Any) {
        let viewController = WalletViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func reload() {
        personalDataTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                
        heightPersonalDataTableView.constant = personalDataTableView.contentSize.height
        heightOtherSettingsTableView.constant = otherSettingsTableView.contentSize.height
    }
    
    private func setupOtherSettingsTableView() {
        otherSettingsTableView.delegate = self
        otherSettingsTableView.dataSource = self
        
        otherSettingsTableView.estimatedRowHeight = otherSettingsTableView.rowHeight
        otherSettingsTableView.rowHeight = 60.0
        otherSettingsTableView.separatorColor = UIColor.lightGray.withAlphaComponent(0.3)
        otherSettingsTableView.separatorStyle = .singleLine
        otherSettingsTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: otherSettingsTableView.frame.size.width, height: 1))
        otherSettingsTableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
//        personalDataTableView.register(SettingViewCell.self, forCellReuseIdentifier: SettingViewCell.cellIdentifier)
        otherSettingsTableView.register(UINib(nibName: "SettingViewCell", bundle: nil), forCellReuseIdentifier: SettingViewCell.cellIdentifier)
    }
    
    private func setupPersonalDataTableView() {
        personalDataTableView.delegate = self
        personalDataTableView.dataSource = self
        
        personalDataTableView.estimatedRowHeight = personalDataTableView.rowHeight
        personalDataTableView.rowHeight = 60.0
        personalDataTableView.separatorColor = UIColor.lightGray.withAlphaComponent(0.3)
        personalDataTableView.separatorStyle = .singleLine
        personalDataTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: personalDataTableView.frame.size.width, height: 1))
        personalDataTableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
//        personalDataTableView.register(SettingViewCell.self, forCellReuseIdentifier: SettingViewCell.cellIdentifier)
        personalDataTableView.register(UINib(nibName: "SettingViewCell", bundle: nil), forCellReuseIdentifier: SettingViewCell.cellIdentifier)
    }
    
    
    @IBAction func searchDidTap(_ sender: Any) {
        let vc = SearchViewController()
        present(vc, animated: true, completion: nil)
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = DetailNftViewController(nibName: "DetailNftViewController", bundle: nil)
//        vc.clothes = items[indexPath.row]
//        vc.isForDropShop = true
//        self.present(vc, animated: true, completion: nil)

        tableView.deselectRow(at: indexPath, animated: true)
        HapticHelper.vibro(.light)
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === personalDataTableView {
            return items.count
        } else if tableView === otherSettingsTableView {
            return items1.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView === personalDataTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingViewCell", for: indexPath) as? SettingViewCell else {
                assertionFailure("Cannot dequeue reusable cell")
                return UITableViewCell()
            }
            
            cell.backgroundColor = UIColor(named: "gray")
            cell.selectionStyle = UITableViewCell.SelectionStyle.default

            cell.bind(viewModel: items[indexPath.row])
                    
            return cell
        } else if tableView === otherSettingsTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingViewCell", for: indexPath) as? SettingViewCell else {
                assertionFailure("Cannot dequeue reusable cell")
                return UITableViewCell()
            }
            
            cell.backgroundColor = UIColor(named: "gray")
            cell.selectionStyle = UITableViewCell.SelectionStyle.default

            cell.bind(viewModel: items1[indexPath.row])
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
