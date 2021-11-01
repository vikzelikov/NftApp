//
//  FollowsViewController.swift
//  NftApp
//
//  Created by Yegor on 03.08.2021.
//

import UIKit

class FollowsViewController: UIViewController {

    var viewModel: FollowsViewModel? = nil

    @IBOutlet weak var followsTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        viewModel?.viewDidLoad()
        bindData()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupStyle()
    }
    
    func bindData() {
        viewModel?.items.bind {
            [weak self] _ in self?.reload()
        
//            self?.checkoutLoading(isShow: false)
//            self?.tableView.isHidden = false
//            self?.errorLabel.isHidden = true
        }
        
        viewModel?.isLoading.bind { _ in 
//            self.checkoutLoading(isShow: $0)
        }
        
        viewModel?.errorMessage.bind { _ in
//            guard let errorMessage = $0 else { return }
            
//            self.checkoutLoading(isShow: false)
//            self.tableView.isHidden = true
//            self.errorLabel.text = errorMessage
//            self.errorLabel.isHidden = false
        }
    }
    
    func setupStyle() {
        if viewModel?.typeFollows == .following {
            followsTitleLabel?.text = NSLocalizedString("Following", comment: "")
        } else {
            followsTitleLabel?.text = NSLocalizedString("Followers", comment: "")
        }
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorColor = UIColor.lightGray.withAlphaComponent(0.3)
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 70, bottom: 0, right: 0)
        tableView.register(UINib(nibName: "FollowsViewCell", bundle: nil), forCellReuseIdentifier: FollowsViewCell.cellIdentifier)
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
        }
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    @IBAction func searchDidTap(_ sender: Any) {
        
    }
    
    @IBAction func dismissDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
        navigationController?.popViewController(animated: true)
    }
}

extension FollowsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didSelectItem(at: indexPath.row) { userViewModel in
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            guard let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
            vc.viewModel = HomeViewModelImpl()
            vc.viewModel?.userViewModel.value = userViewModel
//            vc.viewModel?.typeFollows.value = self.viewModel?.typeFollows ?? TypeFollows.none
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        HapticHelper.vibro(.light)
    }
}

extension FollowsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = viewModel?.items.value.count {
            return count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FollowsViewCell", for: indexPath) as? FollowsViewCell else {
            assertionFailure("Cannot dequeue reusable cell")
            return UITableViewCell()
        }
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.default

        if let vm = viewModel?.items.value[indexPath.row] {
            cell.bind(viewModel: vm)
        }
                
        return cell
    }
}
