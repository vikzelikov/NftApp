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
    @IBOutlet weak var errorLabel: UILabelPadding!
    
    let refreshControl = UIRefreshControl()
    var collectionView: UICollectionView?
    var storedOffsets = [Int: CGFloat]()
    var navigationControl: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = DropShopViewModelImpl()
        viewModel?.viewDidLoad()
        bindData()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupStyle()
    }
    
    func bindData() {
        viewModel?.items.bind {  [weak self] items in
            self?.tableView.isHidden = false
            self?.errorLabel.isHidden = true
            
            if items.isEmpty {
                self?.tableView.isHidden = true
                self?.errorLabel.text = NSLocalizedString("Nothing here", comment: "")
                self?.errorLabel.isHidden = false
            }
        }
        
        viewModel?.influencers.bind { [weak self] _ in
            self?.reloadInfluencers()
        }
        
        viewModel?.isLoading.bind {
            self.checkoutLoading(isShow: $0)
        }
        
        viewModel?.errorMessage.bind {
            guard let errorMessage = $0 else { return }
            self.showMessage(message: errorMessage)
        }
    }
    
    func checkoutLoading(isShow: Bool) {
        if isShow {
            self.tableView.isHidden = true
            self.errorLabel.isHidden = true
        }
    }
    
    func setupStyle() {
        errorLabel.padding = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)

        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.register(UINib(nibName: HeaderViewCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: HeaderViewCell.cellIdentifier)
        tableView.register(UINib(nibName: NftViewCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: NftViewCell.cellIdentifier)
        tableView.register(UINib(nibName: InfluencersCollectionView.cellIdentifier, bundle: nil), forCellReuseIdentifier: InfluencersCollectionView.cellIdentifier)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 150, right: 0)
        
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        tableView.refreshControl = refreshControl
    }
    
    @objc func refresh(_ sender: AnyObject) {
        viewModel?.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.refreshControl.endRefreshing()
        }
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    func reloadInfluencers() {
        collectionView?.reloadData()
    }
    
}

extension DropShopViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 { return }
        
        viewModel?.didSelectItem(at: indexPath.row - 3) { editionViewModel in
            let vc = DetailNftViewController(nibName: "DetailNftViewController", bundle: nil)
            vc.viewModel = DetailNftViewModelImpl()
            vc.viewModel?.nftViewModel.value = NftViewModel(id: editionViewModel.id, edition: editionViewModel)
            vc.viewModel?.typeDetailNFT = .dropShop
            self.navigationControl?.pushViewController(vc, animated: true)
        }

        HapticHelper.vibro(.light)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if indexPath.row == 0 { return }
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.applyTouchDownAnimation(cell: cell)
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if indexPath.row == 0 { return }
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.applyTouchUpAnimation(cell: cell)
    }
}

extension DropShopViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = viewModel?.items.value.count {
            return count + 3
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HeaderViewCell.cellIdentifier, for: indexPath) as? HeaderViewCell else { return UITableViewCell() }
            cell.headerLabel.text = "Influencers"
            cell.selectionStyle = .none
            return cell
            
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: InfluencersCollectionView.cellIdentifier, for: indexPath)
            cell.selectionStyle = .none
            return cell
            
        } else if indexPath.row == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HeaderViewCell.cellIdentifier, for: indexPath) as? HeaderViewCell else { return UITableViewCell() }
            cell.headerLabel.text = "NFTs"
            cell.selectionStyle = .none
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NftViewCell.cellIdentifier, for: indexPath) as? NftViewCell else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            HapticHelper.vibro(.light)
            
            if let items = viewModel?.items.value {
                if items.indices.contains(indexPath.row - 3) {
                    if let vm = viewModel?.items.value[indexPath.row - 3] {
                        cell.typeDetailNFT = .dropShop
                        cell.bindEdition(viewModel: vm)
                    }
                }
            }
            
            cell.removeItem = { [weak self] in
                self?.viewModel?.items.value.remove(at: indexPath.row - 3)
                let indexPath = IndexPath(item: indexPath.row, section: 0)
                self?.tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? InfluencersCollectionView else { return }

        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
        
        collectionView = tableViewCell.collectionView
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? InfluencersCollectionView else { return }
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
}

extension DropShopViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = viewModel?.influencers.value.prefix(10).count {
            return count + 1
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfluencerCollectionViewCell.cellIdentifier, for: indexPath) as? InfluencerCollectionViewCell else { return UICollectionViewCell() }

        if indexPath.row == 0 {
            cell.setupAll()
        } else {
            if let vm = viewModel?.influencers.value[indexPath.row - 1] {
                cell.bind(viewModel: vm)
            }
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            viewModel?.didSelectInfluencers(at: indexPath.row) { influencers in
                let vc = InfluencersViewController()
                vc.viewModel = InfluencersViewModelImpl()
                vc.viewModel?.items.value = influencers
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            viewModel?.didSelectInfluencer(at: indexPath.row - 1) { userViewModel in
                let storyboard = UIStoryboard(name: "Home", bundle: nil)
                guard let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
                vc.viewModel = HomeViewModelImpl()
                vc.viewModel?.userViewModel.value = userViewModel
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        HapticHelper.vibro(.light)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.applyTouchDownAnimation(cell: cell)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.applyTouchUpAnimation(cell: cell)
    }
}
