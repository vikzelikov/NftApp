//
//  HomeViewController.swift
//  NftApp
//
//  Created by Yegor on 08.06.2021.
//

import UIKit

class HomeViewController: UIViewController {
    
    var viewModel: HomeViewModel?
    var headerView: ProfileHeaderView?
    
    @IBOutlet weak var tableView: UITableView!
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        headerView = ProfileHeaderView()
        if viewModel == nil { viewModel = HomeViewModelImpl() }
        viewModel?.viewDidLoad()
        bindData()
        
        setupHeader()
        
        setupStyle()
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
    
    // MARK: fix this
    func setupStyle() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: NftViewCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: NftViewCell.cellIdentifier)
        tableView.contentInset = UIEdgeInsets(top: 431, left: 0, bottom: 0, right: 0)
        
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        tableView.refreshControl = refreshControl
        tableView.refreshControl?.bounds.origin.y = 431
    }
    
    func setupHeader() {
        guard let header = headerView else { return }
        header.viewModel = viewModel
        header.navigationController = navigationController
        tableView.addSubview(header)
        header.viewDidLoad()
        
        header.shareButtonDidTap = { [weak self] sender in
            self?.shareDidTap(sender)
        }
        
        header.dismissDidTap = { [weak self] in
            self?.dismissDidTap()
        }
        
        header.userImageDidTap = { [self] in
            ImagePickerHelper().pickImage(self) { image in
                self.headerView?.userImageView.image = image
                
                self.viewModel?.updateAvatar(request: UpdateAvatarRequest(image: image), completion: { _ in })
            }
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        viewModel?.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.refreshControl.endRefreshing()
        }
    }
    
    func shareDidTap(_ sender: UIButton) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        UIGraphicsEndImageContext()

        let textToShare = "Check out my app"

        // enter link to your app here
        if let myWebsite = URL(string: "https://showyouryup.com") {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]

            activityVC.popoverPresentationController?.sourceView = sender as UIView
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    func dismissDidTap() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
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
    
    // MARK: fix this
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var positionY = -abs(scrollView.contentOffset.y + 400)

        if positionY > -350 {
            positionY = -431
        } else {
            positionY = scrollView.contentOffset.y - 380
        }

        headerView?.frame = CGRect(x: 0, y: positionY, width: UIScreen.main.bounds.size.width, height: 431)
    }
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = viewModel?.collectionNfts.value.count {
            return count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NftViewCell.cellIdentifier, for: indexPath) as? NftViewCell else { return UITableViewCell() }
        
        if let vm = viewModel?.collectionNfts.value[indexPath.row] {
            cell.bind(viewModel: vm)
        }
        
        cell.selectionStyle = .none
        HapticHelper.vibro(.light)
        
        return cell
    }
}

struct UpdateAvatarRequest {
    var image: UIImage
}
