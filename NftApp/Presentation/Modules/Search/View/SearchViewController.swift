//
//  SearchViewController.swift
//  NftApp
//
//  Created by Yegor on 02.08.2021.
//

import UIKit

class SearchViewController: UIViewController {
    
    var viewModel: SearchViewModel?

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        AppDIContainer.shared.makeSearchScene()
        
        viewModel = DIContainer.shared.resolve(type: SearchViewModel.self)
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
        navigationController?.navigationBar.isHidden = true

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.keyboardDismissMode = .onDrag
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(
            UINib(nibName: SearchViewCell.cellIdentifier, bundle: nil),
            forCellReuseIdentifier: SearchViewCell.cellIdentifier
        )
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
    }
    
    func reload() {
        tableView.reloadData()
    }
    
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didSelectItem(section: indexPath.section, at: indexPath.row) { searchCellViewModel in
            switch searchCellViewModel.type {
            case .users:
                let storyboard = UIStoryboard(name: "Home", bundle: nil)
                guard
                    let vc = storyboard
                        .instantiateViewController(withIdentifier: "HomeViewController")
                        as? HomeViewController
                else {
                    return
                }
                vc.viewModel = HomeViewModelImpl()
                vc.viewModel?.userViewModel.value = User(id: searchCellViewModel.id)
                self.navigationController?.pushViewController(vc, animated: true)
            
            case .editions:
                let vc = DetailNftViewController()
                var nft = Nft(nft: .defaultValue)
                nft.edition.id = searchCellViewModel.id
                vc.viewModel = DetailNftViewModelImpl()
                vc.viewModel?.typeDetailNFT = .dropShop
                vc.viewModel?.nftViewModel.value = nft
                self.navigationController?.pushViewController(vc, animated: true)
            
            case .nfts:
                let vc = DetailNftViewController()
                var nft = Nft(nft: .defaultValue)
                nft.edition.id = searchCellViewModel.id
                vc.viewModel = DetailNftViewModelImpl()
                vc.viewModel?.nftViewModel.value = nft
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        HapticHelper.vibro(.light)
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = HeaderView()
        guard let headers = viewModel?.headers else { return nil }
        
        switch section {
        case 0:
            if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
                header.bind(title: headers[section])
            }
        case 1:
            if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
                header.bind(title: headers[section])
            }
        default: break
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            if self.tableView(tableView, numberOfRowsInSection: section) == 0 { return 0 }
        case 1:
            if self.tableView(tableView, numberOfRowsInSection: section) == 0 { return 0 }
        default: break
        }
        
        return 50
    }
    
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = viewModel?.items.value[section].count {
            return count
        } else {
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let count = viewModel?.items.value.count {
            return count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let vm = viewModel?.items.value[indexPath.section][indexPath.row] {
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchViewCell.cellIdentifier, for: indexPath)
            guard
                let cell = cell as? SearchViewCell
            else {
                return UITableViewCell()
            }
            
            cell.bind(viewModel: vm)
            
            return cell
        }
        
        return UITableViewCell()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }

        viewModel?.searchDidTap(keyWord: searchText)

        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
    }
}
