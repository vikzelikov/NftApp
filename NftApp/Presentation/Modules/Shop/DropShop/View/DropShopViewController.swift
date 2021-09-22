//
//  DropShopViewController.swift
//  NftApp
//
//  Created by Yegor on 13.07.2021.
//

import UIKit

class DropShopViewController: UIViewController {
    
    var viewModel: DropShopViewModel? = nil
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = DropShopViewModelImpl()
        bindData()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupStyle()
        
        reload()
    }
    
    func bindData() {
        viewModel?.getEditions()
        
//        viewModel?.isLoading.bind { [weak self] in
//            if $0 {
////                self?.loginButton.loadingIndicator(isShow: true, titleButton: nil)
//            } else {
////                self?.loginButton.loadingIndicator(isShow: false, titleButton: "NEXT")
//            }
//        }
            
        viewModel?.errorMessage.bind {
            guard let errorMessage = $0 else { return }
            let alert = UIAlertController(title: "Error Message", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func setupStyle() {
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.register(UINib(nibName: "NftDropViewCell", bundle: nil), forCellReuseIdentifier: NftDropViewCell.cellIdentifier)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 150, right: 0)
    }
    
    func reload() {
        tableView.reloadData()
    }
    
}

extension DropShopViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didSelectItem(at: indexPath.row) { nftViewModel in
            let vc = DetailNftViewController(nibName: "DetailNftViewController", bundle: nil)
            vc.viewModel = DetailNftViewModelImpl()
            vc.viewModel?.nftViewModel.value = nftViewModel
            vc.typeDetailNFT = .dropShop
            self.present(vc, animated: true, completion: nil)
        }
        
        HapticHelper.vibro(.light)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        UIView.animate(withDuration: 0.1) {
            cell?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        UIView.animate(withDuration: 0.1, delay: 0.1) {
            cell?.transform = .identity
        }
    }
}

extension DropShopViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = viewModel?.items.value.count {
            return count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NftDropViewCell", for: indexPath) as? NftDropViewCell else {
            assertionFailure("Cannot dequeue reusable cell")
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        HapticHelper.vibro(.light)
        
        if let vm = viewModel?.items.value[indexPath.row] {
            cell.bind(viewModel: vm)
        }
        
        return cell
    }
}
