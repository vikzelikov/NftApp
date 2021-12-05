//
//  HomeViewController.swift
//  NftApp
//
//  Created by Yegor on 08.06.2021.
//

import UIKit
import SkeletonView

class HomeViewController: UIViewController {
    
    var viewModel: HomeViewModel?
    var headerView: ProfileHeaderView?
    
    @IBOutlet weak var tableView: UITableView!
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView = ProfileHeaderView()
        if viewModel == nil { viewModel = HomeViewModelImpl() }
        viewModel?.viewDidLoad(isRefresh: false)
        bindData()
        
        setupHeader()

        setupStyle()
    }
    
    func bindData() {
        viewModel?.itemsNfts.observe(on: self) { [weak self] _ in
            self?.reload()
        }
        
        viewModel?.isLoading.observe(on: self) { [weak self] isLoading in
            if isLoading {
                DispatchQueue.main.async {
                    let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .topLeftBottomRight)
                    self?.tableView.showAnimatedGradientSkeleton(animation: animation)
                    self?.tableView.allowsSelection = false
                }
            } else {
                self?.tableView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.3))
                self?.tableView.stopSkeletonAnimation()
                self?.tableView.allowsSelection = true
            }
        }
        
        viewModel?.errorMessage.observe(on: self) { [weak self] errMessage in
            guard let errorMessage = errMessage else { return }
            self?.showMessage(message: errorMessage)
        }
    }

    // MARK: fix this
    func setupStyle() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = UIScreen.main.bounds.width - 30
        tableView.rowHeight = UIScreen.main.bounds.width - 30
        tableView.register(UINib(nibName: NftViewCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: NftViewCell.cellIdentifier)
        tableView.register(UINib(nibName: PlaceholderViewCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: PlaceholderViewCell.cellIdentifier)
        tableView.contentInset = UIEdgeInsets(top: 380, left: 0, bottom: 0, right: 0)
        
        if !self.isModal {
            refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
            tableView.addSubview(refreshControl)
            tableView.refreshControl = refreshControl
            tableView.refreshControl?.bounds.origin.y = 370
        }
    }
    
    func setupHeader() {
        guard let header = headerView else { return }
        header.viewModel = viewModel
        header.navigationController = navigationController
        header.isModal = self.isModal
        tableView.addSubview(header)
        header.viewDidLoad()
        
        header.shareButtonDidTap = { [weak self] sender in
            self?.shareDidTap(sender)
        }
        
        header.dismissDidTap = { [weak self] in
            self?.dismissDidTap()
        }
        
        header.collectionDidTap = { [weak self] in
            self?.viewModel?.selectListDidTap(typeListNfts: .collection)
        }
        
        header.observablesDidTap = { [weak self] in
            self?.viewModel?.selectListDidTap(typeListNfts: .observables)
        }
        
        header.createdDidTap = { [weak self] in
            self?.viewModel?.selectListDidTap(typeListNfts: .created)
        }
        
        header.userImageDidTap = { [self] in
            ImagePickerHelper().pickImage(self) { image in
                self.headerView?.userImageView.image = image
                self.headerView?.userImageView.contentMode = .scaleAspectFill
                
                self.viewModel?.updateAvatar(request: UploadMediaRequest(image: image), completion: { _ in })
            }
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        viewModel?.viewDidLoad(isRefresh: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.refreshControl.endRefreshing()
        }
    }
    
    func shareDidTap(_ sender: UIButton) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        UIGraphicsEndImageContext()

        let textToShare = "Yup NFT"

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
            if let typeList = self.viewModel?.typeListNfts.value {
                let vc = DetailNftViewController()
                vc.viewModel = DetailNftViewModelImpl()
                vc.viewModel?.nftViewModel.value = nftViewModel
                vc.viewModel?.typeDetailNFT = (typeList == .created ? .dropShop : .detail)
                    
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        HapticHelper.vibro(.light)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.applyTouchDownAnimation(cell: cell)
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.applyTouchUpAnimation(cell: cell)
    }
    
    // MARK: fix this
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var positionY = scrollView.contentOffset.y

        if positionY < -50 {
            positionY = -380
        } else {
            positionY = scrollView.contentOffset.y - 330
        }

        headerView?.frame = CGRect(x: 0, y: positionY, width: UIScreen.main.bounds.size.width, height: 370)
    }
    
}

extension HomeViewController: SkeletonTableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let collectionNFTs = self.viewModel?.itemsNfts.value {
            if collectionNFTs.isEmpty {
                return 1
            }
        }
        
        if let count = viewModel?.itemsNfts.value.count {
            return count
        } else {
            // for show error message
            return 1
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return NftViewCell.cellIdentifier
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let collectionNFTs = self.viewModel?.itemsNfts.value {
            if collectionNFTs.isEmpty {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaceholderViewCell.cellIdentifier, for: indexPath) as? PlaceholderViewCell else { return UITableViewCell() }
                cell.label.text = NSLocalizedString("Nothing here", comment: "")
                cell.selectionStyle = .none
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: NftViewCell.cellIdentifier, for: indexPath) as? NftViewCell else { return UITableViewCell() }
                
                if let vm = viewModel?.itemsNfts.value[indexPath.row] {
                    if let typeList = self.viewModel?.typeListNfts.value {
                        if typeList == .collection || typeList == .observables {
                            cell.typeDetailNFT = .detail
                            cell.bindNft(viewModel: vm)
                        }
                        
                        if typeList == .created {
                            cell.typeDetailNFT = .dropShop
                            cell.bindEdition(viewModel: vm.edition)
                        }
                    }
                }
                
                cell.selectionStyle = .none
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
}

struct UploadMediaRequest {
    
    var image: UIImage
    
}
