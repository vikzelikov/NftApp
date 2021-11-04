//
//  ProfileViewController.swift
//  NftApp
//
//  Created by Yegor on 18.07.2021.
//

import UIKit
import MessageUI

class SettingsViewController: UIViewController {

    var viewModel: SettingsViewModel? = nil

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var walletButton: UIButton!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var telegramButton: UIButton!
    @IBOutlet weak var personalDataTableView: UITableView!
    @IBOutlet weak var otherSettingsTableView: UITableView!
    @IBOutlet weak var heightPersonalDataTableView: NSLayoutConstraint!
    @IBOutlet weak var heightOtherSettingsTableView: NSLayoutConstraint!
    var items: [SettingCellViewModel] = []
    var items1: [SettingCellViewModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = SettingsViewModelImpl()
        viewModel?.viewDidLoad()
        bindData()
        
        setupStyle()
    }
    
    func bindData() {
        UserObject.user.bind {
            self.balanceLabel.text = String($0?.balance ?? 0.0)
        }
    }
    
    func setupStyle() {
        self.scrollView.delaysContentTouches = false
        
        walletButton.applyButtonEffects()

        setupPersonalDataTableView()
        setupOtherSettingsTableView()
        
        telegramButton.layer.cornerRadius = telegramButton.frame.width / 2
    }
    
    @IBAction func walletButtonDidTap(_ sender: Any) {
        let viewController = WalletViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                
        heightPersonalDataTableView.constant = personalDataTableView.contentSize.height
        heightOtherSettingsTableView.constant = otherSettingsTableView.contentSize.height
    }
    
    func setupOtherSettingsTableView() {
        otherSettingsTableView.delegate = self
        otherSettingsTableView.dataSource = self
        
        otherSettingsTableView.estimatedRowHeight = otherSettingsTableView.rowHeight
        otherSettingsTableView.rowHeight = 60.0
        otherSettingsTableView.separatorColor = UIColor.lightGray.withAlphaComponent(0.3)
        otherSettingsTableView.separatorStyle = .singleLine
        otherSettingsTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: otherSettingsTableView.frame.size.width, height: 1))
        otherSettingsTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: otherSettingsTableView.frame.size.width, height: 1))
        otherSettingsTableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        otherSettingsTableView.register(UINib(nibName: SettingViewCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: SettingViewCell.cellIdentifier)
        
        items.append(SettingCellViewModel(title: "Personal information", contentLabel: nil, iconContentView: UIImage(named: "right_arrow")))
        items.append(SettingCellViewModel(title: "Password", contentLabel: nil, iconContentView: UIImage(named: "right_arrow")))
        
        if #available(iOS 15.0, *) {
            otherSettingsTableView.sectionHeaderTopPadding = 0.0
        }
    }
    
    func setupPersonalDataTableView() {
        personalDataTableView.delegate = self
        personalDataTableView.dataSource = self
        
        personalDataTableView.estimatedRowHeight = personalDataTableView.rowHeight
        personalDataTableView.rowHeight = 60.0
        personalDataTableView.separatorColor = UIColor.lightGray.withAlphaComponent(0.3)
        personalDataTableView.separatorStyle = .singleLine
        personalDataTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: personalDataTableView.frame.size.width, height: 1))
        personalDataTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: personalDataTableView.frame.size.width, height: 1))
        personalDataTableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        personalDataTableView.register(UINib(nibName: SettingViewCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: SettingViewCell.cellIdentifier)
        
        items1.append(SettingCellViewModel(title: NSLocalizedString("Support", comment: ""), contentLabel: nil, iconContentView: UIImage(named: "right_arrow")))
        items1.append(SettingCellViewModel(title: NSLocalizedString("Logout", comment: ""), contentLabel: nil, iconContentView: UIImage(named: "right_arrow")))
        
        if #available(iOS 15.0, *) {
            personalDataTableView.sectionHeaderTopPadding = 0.0
        }
    }
    
    
    @IBAction func searchDidTap(_ sender: Any) {
        let vc = SearchViewController()
        present(vc, animated: true, completion: nil)
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView === personalDataTableView {
            switch indexPath.row {
            case 0:
                let vc = PersonalDataViewController()
                navigationController?.pushViewController(vc, animated: true)
            case 1:
                let vc = PasswordViewController()
                navigationController?.pushViewController(vc, animated: true)
            default: break
                
            }
        } else if tableView === otherSettingsTableView {
            switch indexPath.row {
            
            case 0: openEmailApp()
                
            case 1: logout()
                
            default: break
                
            }
        }

        tableView.deselectRow(at: indexPath, animated: true)
        HapticHelper.vibro(.light)
    }
    
    func openEmailApp() {
        let recipientEmail = "support@showyouryup.com"
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([recipientEmail])
            present(mail, animated: true)
        } else if let url = URL(string: "mailto:\(recipientEmail)") {
            UIApplication.shared.open(url)
        }
    }
    
    func logout() {
        let alert = UIAlertController(title: NSLocalizedString("Warning", comment: ""), message: NSLocalizedString("Do you want to logout?", comment: ""), preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default, handler: { _ in
              
            self.viewModel?.logoutDidTap()

            let storyboard = UIStoryboard(name: "Authorization", bundle: nil)
            guard let page = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else { return }
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            appDelegate.window?.rootViewController = UINavigationController(rootViewController: page)
            
        }))

        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingViewCell.cellIdentifier, for: indexPath) as? SettingViewCell else {
                assertionFailure("Cannot dequeue reusable cell")
                return UITableViewCell()
            }
            
            cell.backgroundColor = UIColor(named: "clear")
            cell.selectionStyle = UITableViewCell.SelectionStyle.default

            cell.bind(viewModel: items[indexPath.row])
                    
            return cell
        } else if tableView === otherSettingsTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingViewCell.cellIdentifier, for: indexPath) as? SettingViewCell else {
                assertionFailure("Cannot dequeue reusable cell")
                return UITableViewCell()
            }
            
            cell.backgroundColor = UIColor(named: "clear")
            cell.selectionStyle = UITableViewCell.SelectionStyle.default

            cell.bind(viewModel: items1[indexPath.row])
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
