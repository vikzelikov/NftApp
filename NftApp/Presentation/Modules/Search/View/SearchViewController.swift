//
//  SearchViewController.swift
//  NftApp
//
//  Created by Yegor on 02.08.2021.
//

import UIKit

class SearchViewController: UIViewController {
    
    var viewModel: SearchViewModel? = nil

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = SearchViewModelImpl()
        bindData()
        
        setupStyle()
    }
    
    func bindData() {
        viewModel?.items.bind { [weak self] _ in
            self?.reload()
        
//            self?.checkoutLoading(isShow: false)
//            self?.tableView.isHidden = false
//            self?.errorLabel.isHidden = true
        }
        
        viewModel?.isLoading.bind { _ in
//            self.checkoutLoading(isShow: $0)
        }
        
        viewModel?.errorMessage.bind {
            guard let errorMessage = $0 else { return }
            self.showMessage(message: errorMessage)
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
        tableView.register(UINib(nibName: SearchViewCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: SearchViewCell.cellIdentifier)
        
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
        viewModel?.didSelectItem(at: indexPath.row) { searchCellViewModel in
            switch searchCellViewModel.type {
            case .users:
                tableView.deselectRow(at: indexPath, animated: true)
                HapticHelper.vibro(.light)
                
                let storyboard = UIStoryboard(name: "Home", bundle: nil)
                guard let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
                vc.viewModel = HomeViewModelImpl()
                vc.viewModel?.userViewModel.value = UserViewModel(id: searchCellViewModel.id)
                self.navigationController?.pushViewController(vc, animated: true)
            
            case .editions:
                tableView.deselectRow(at: indexPath, animated: true)
                HapticHelper.vibro(.light)
                
                let vc = DetailNftViewController()
                vc.viewModel = DetailNftViewModelImpl()
                vc.viewModel?.typeDetailNFT = .dropShop
                vc.viewModel?.nftViewModel.value = NftViewModel(id: 0, edition: EditionViewModel(id: searchCellViewModel.id))
                self.navigationController?.pushViewController(vc, animated: true)
            
            case .nfts:
                tableView.deselectRow(at: indexPath, animated: true)
                HapticHelper.vibro(.light)
                
                let vc = DetailNftViewController()
                vc.viewModel = DetailNftViewModelImpl()
                vc.viewModel?.nftViewModel.value = NftViewModel(id: 0, edition: EditionViewModel(id: searchCellViewModel.id))
                self.navigationController?.pushViewController(vc, animated: true)
                
            default: break
            }
            
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = viewModel?.items.value.count {
            return count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchViewCell.cellIdentifier, for: indexPath) as? SearchViewCell else {
            assertionFailure("Cannot dequeue reusable cell")
            return UITableViewCell()
        }
        

        if let vm = viewModel?.items.value[indexPath.row] {
            if vm.type == .separator {
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
            }
            
            cell.bind(viewModel: vm)
        }
                
        return cell
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
