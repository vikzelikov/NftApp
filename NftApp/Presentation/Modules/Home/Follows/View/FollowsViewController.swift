//
//  FollowsViewController.swift
//  NftApp
//
//  Created by Yegor on 03.08.2021.
//

import UIKit

class FollowsViewController: UIViewController {

    var viewModel: FollowsViewModel?

    @IBOutlet weak var followsTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        viewModel?.viewDidLoad()
        bindData()
        
        setupStyle()
    }
    
    func bindData() {
        viewModel?.items.observe(on: self) { [weak self] _ in
            self?.reload()
        }
        
//        viewModel?.isLoading.observe(on: self) { [weak self] _ in
//            self.checkoutLoading(isShow: $0)
//        }
        
        viewModel?.errorMessage.observe(on: self) { [weak self] errMessage in
            guard let errorMessage = errMessage else { return }
            self?.showMessage(message: errorMessage)
        }
    }
    
    func setupStyle() {
        if viewModel?.typeFollows == .following {
            followsTitleLabel?.text = NSLocalizedString("Following", comment: "")
        } else {
            followsTitleLabel?.text = NSLocalizedString("Followers", comment: "")
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorColor = UIColor.lightGray.withAlphaComponent(0.3)
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 70, bottom: 0, right: 0)
        tableView.register(
            UINib(nibName: FollowsViewCell.cellIdentifier, bundle: nil),
            forCellReuseIdentifier: FollowsViewCell.cellIdentifier
        )
        
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
            let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
            guard
                 let vc = vc as? HomeViewController
            else {
                return
            }
            vc.viewModel = HomeViewModelImpl()
            vc.viewModel?.userViewModel.value = userViewModel
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
        let cell = tableView.dequeueReusableCell(withIdentifier: FollowsViewCell.cellIdentifier, for: indexPath)
        guard
            let cell = cell as? FollowsViewCell
        else {
            fatalError("Cannot dequeue reusable cell")
        }
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.default

        if let vm = viewModel?.items.value[indexPath.row] {
            cell.bind(viewModel: vm)
        }
                
        return cell
    }
}
