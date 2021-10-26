//
//  HomeViewController.swift
//  NftApp
//
//  Created by Yegor on 08.06.2021.
//

import UIKit

class HomeViewController: UIViewController {
    
    var viewModel: HomeViewModel?
    
    @IBOutlet weak var tableView: UITableView!
    let headerView = ProfileHeaderView(frame: CGRect(x: 0, y: -431, width: UIScreen.main.bounds.size.width, height: 431))

    var items:[String] = ["","","","","","","","",""]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        viewModel = HomeViewModelImpl()
        viewModel?.viewDidLoad()
        bindData()
        
        setupStyle()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: NftProfileViewCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: NftProfileViewCell.cellIdentifier)
        tableView.contentInset = UIEdgeInsets(top: 431, left: 0, bottom: 0, right: 0)

        headerView.contentMode = .scaleAspectFill
        headerView.clipsToBounds = true
        tableView.addSubview(headerView)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bindData() {
        viewModel?.collectionNfts.bind {
            [weak self] _ in self?.reload()
        
//            self?.checkoutLoading(isShow: false)
//            self?.tableView.isHidden = false
//            self?.errorLabel.isHidden = true
        }
        
        viewModel?.isLoading.bind { _ in 
//            self.checkoutLoading(isShow: $0)
        }
        
        viewModel?.errorMessage.bind {
            guard let errorMessage = $0 else { return }
            let alert = UIAlertController(title: "Error Message", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func setupStyle() {
        
    }
    
    func reload() {
        tableView.reloadData()
    }
    
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didSelectItem(at: indexPath.row) { nftViewModel in
            let vc = DetailNftViewController()
            vc.viewModel = DetailNftViewModelImpl()
            vc.viewModel?.nftViewModel.value = nftViewModel
            self.navigationController?.pushViewController(vc, animated: true)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var positionY = -abs(scrollView.contentOffset.y + 400)
        
        if positionY > -350 {
            positionY = -431
        } else {
            positionY = scrollView.contentOffset.y - 380
        }

        headerView.frame = CGRect(x: 0, y: positionY, width: UIScreen.main.bounds.size.width, height: 431)
    }
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = viewModel?.collectionNfts.value.count {
            return items.count
        } else {
            return items.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NftProfileViewCell.cellIdentifier, for: indexPath) as? NftProfileViewCell else { return UITableViewCell() }
        
//        if let vm = viewModel?.collectionNfts.value[indexPath.row] {
//            cell.bind(viewModel: vm)
//        }
        
        return cell
    }
}
