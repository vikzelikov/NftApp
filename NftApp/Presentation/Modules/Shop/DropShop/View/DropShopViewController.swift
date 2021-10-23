//
//  DropShopViewController.swift
//  NftApp
//
//  Created by Yegor on 13.07.2021.
//

import UIKit

class DropShopViewController: UIViewController {
    var storedOffsets = [Int: CGFloat]()
    var viewModel: DropShopViewModel? = nil
    
    let influencers: [String] = ["bloger", "morgen", "bloger#1231", "blogerbloger123", "bloger", "bloger", "bloger"]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    let loadingIndicator1 = UIActivityIndicatorView()
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = DropShopViewModelImpl()
        bindData()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupStyle()
    }
    
    func bindData() {
        viewModel?.getEditions()
        
        viewModel?.items.bind {
            [weak self] _ in self?.reload()
        
            self?.checkoutLoading(isShow: false)
            self?.tableView.isHidden = false
            self?.errorLabel.isHidden = true
        }
        
        viewModel?.isLoading.bind {
            self.checkoutLoading(isShow: $0)
        }
        
        viewModel?.errorMessage.bind {
            guard let errorMessage = $0 else { return }
            
            self.checkoutLoading(isShow: false)
            self.tableView.isHidden = true
            self.errorLabel.text = errorMessage
            self.errorLabel.isHidden = false
        }
    }
    
    func checkoutLoading(isShow: Bool) {
        if isShow {
            self.loadingIndicator.startAnimating()
            self.tableView.isHidden = true
            self.errorLabel.isHidden = true
        } else {
            self.loadingIndicator.stopAnimating()
        }
    }
    
    func setupStyle() {
        loadingIndicator.startAnimating()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.register(UINib(nibName: NftDropViewCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: NftDropViewCell.cellIdentifier)
        tableView.register(UINib(nibName: InfluencersCollectionView.cellIdentifier, bundle: nil), forCellReuseIdentifier: InfluencersCollectionView.cellIdentifier)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 150, right: 0)
    }
    
    func reload() {
        tableView.reloadData()
    }
    
}

extension DropShopViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 { return }
        
        viewModel?.didSelectItem(at: indexPath.row - 1) { nftViewModel in
            let vc = DetailNftViewController(nibName: "DetailNftViewController", bundle: nil)
            vc.viewModel = DetailNftViewModelImpl()
            vc.viewModel?.nftViewModel.value = nftViewModel
            vc.viewModel?.typeDetailNFT = .dropShop
            self.present(vc, animated: true, completion: nil)
        }
        
        HapticHelper.vibro(.light)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if indexPath.row == 0 { return }
        
        let cell = tableView.cellForRow(at: indexPath)
        UIView.animate(withDuration: 0.1) {
            cell?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if indexPath.row == 0 { return }
        
        let cell = tableView.cellForRow(at: indexPath)
        UIView.animate(withDuration: 0.1, delay: 0.1) {
            cell?.transform = .identity
        }
    }
}

extension DropShopViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = viewModel?.items.value.count {
            return count + 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: InfluencersCollectionView.cellIdentifier, for: indexPath)
            cell.selectionStyle = .none
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NftDropViewCell.cellIdentifier, for: indexPath) as? NftDropViewCell else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            HapticHelper.vibro(.light)
            
            if let vm = viewModel?.items.value[indexPath.row - 1] {
                cell.bind(viewModel: vm)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? InfluencersCollectionView else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? InfluencersCollectionView else { return }

        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
}

extension DropShopViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return influencers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfluencerCollectionViewCell.cellIdentifier, for: indexPath) as? InfluencerCollectionViewCell else { return UICollectionViewCell() }

        cell.bind(name: influencers[indexPath.row])

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        viewModel?.didSelectItem(at: indexPath.row - 1) { nftViewModel in
//            let vc = DetailNftViewController(nibName: "DetailNftViewController", bundle: nil)
//            vc.viewModel = DetailNftViewModelImpl()
//            vc.viewModel?.nftViewModel.value = nftViewModel
//            vc.viewModel?.typeDetailNFT = .dropShop
//            self.present(vc, animated: true, completion: nil)
//        }
        
        HapticHelper.vibro(.light)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.1) {
            cell?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.1, delay: 0.1) {
            cell?.transform = .identity
        }
    }
}
