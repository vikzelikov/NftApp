//
//  HomeViewController.swift
//  NftApp
//
//  Created by Yegor on 08.06.2021.
//

import UIKit

class HomeViewController: UIViewController {
    
    var viewModel: HomeViewModel?

    @IBOutlet weak var userImageView: UIImageView! {
        didSet {
            userImageView.layer.cornerRadius = userImageView.frame.width / 2
        }
    }
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet{
            scrollView.delegate = self
        }
    }
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var loginSubtitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var miniTopButton: UIButton!
    @IBOutlet weak var collectionLabel: UILabel!
    @IBOutlet weak var observablesLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = HomeViewModelImpl()
        viewModel?.viewDidLoad()
        bindData()
        
        setupStyle()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "NftProfileViewCell", bundle: nil), forCellWithReuseIdentifier: "NftProfileViewCell")
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
        
        viewModel?.userViewModel.bind {
            guard let userViewModel = $0 else { return }
            
            self.loginLabel.text = userViewModel.login
            self.loginSubtitleLabel.text = "@\(userViewModel.login)"
        }
        
        viewModel?.followers.bind {
            self.followersLabel.text = "\($0.count)"
        }
        
        viewModel?.following.bind {
            self.followingLabel.text = "\($0.count)"
        }
    }
    
    func reload() {
        collectionView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        collectionViewHeight.constant = CGFloat(400)
    }
    
    @objc func collectionDidTap(_ sender: UITapGestureRecognizer) {
        checkoutCollections(selectedLabel: collectionLabel, unselectedLabel: observablesLabel)
    }
    
    @objc func observablesDidTap(_ sender: UITapGestureRecognizer) {
        checkoutCollections(selectedLabel: observablesLabel, unselectedLabel: collectionLabel)
    }
    
    private func checkoutCollections(selectedLabel: UILabel, unselectedLabel: UILabel) {
        let borderWidth = (UIScreen.main.bounds.width - 0) / 2
        selectedLabel.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor(named: "black") ?? UIColor.black, thickness: 1, width: borderWidth)
        unselectedLabel.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor(named: "gray") ?? UIColor.gray, thickness: 1, width: borderWidth)
        
        selectedLabel.textColor = UIColor(named: "black")
        unselectedLabel.textColor = UIColor.gray
    }
    
    @objc func shareDidTap(_ sender: UIButton) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        UIGraphicsEndImageContext()

        let textToShare = "Check out my app"

        // enter link to your app here
        if let myWebsite = URL(string: "https://showyouryup.com/@login") {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]

            activityVC.popoverPresentationController?.sourceView = sender as UIView
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    @objc func subscribeDidTap(_ sender: UIButton) {
        viewModel?.manageSubscribeDidTap(isFollow: true, completion: { result in
            print(result)
        })
    }
    
    private func setupStyle() {
        scrollView.delaysContentTouches = false
        
        let windowWidth: CGFloat = UIScreen.main.bounds.width
        let borderWidth = windowWidth / 2
        observablesLabel.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor(named: "gray") ?? UIColor.gray, thickness: 1, width: borderWidth)
        observablesLabel.textColor = UIColor.gray
        let observablesTap = UITapGestureRecognizer(target: self, action: #selector(observablesDidTap(_:)))
        observablesLabel?.isUserInteractionEnabled = true
        observablesLabel?.addGestureRecognizer(observablesTap)

        miniTopButton.applyButtonEffects()
        
        let followersTap = UITapGestureRecognizer(target: self, action: #selector(followersContainerDidTap(_:)))
        followersLabel?.isUserInteractionEnabled = true
        followersLabel?.addGestureRecognizer(followersTap)
        
        let followingsTap = UITapGestureRecognizer(target: self, action: #selector(followingContainerDidTap(_:)))
        followingLabel?.isUserInteractionEnabled = true
        followingLabel?.addGestureRecognizer(followingsTap)
        
        guard let isOtherUser = viewModel?.isOtherUser else { return }
        
        if !isOtherUser {
            miniTopButton.setTitle(NSLocalizedString("Follow", comment: ""), for: .normal)
            miniTopButton.setImage(nil, for: .normal)
            miniTopButton.addTarget(self, action: #selector(subscribeDidTap), for: .touchUpInside)

            observablesLabel.isHidden = true
            collectionLabel.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor(named: "gray") ?? UIColor.gray, thickness: 1, width: windowWidth)
            
            if (navigationController == nil) {
                backButton.isHidden = true
            } else {
                closeButton.isHidden = true
            }
        } else {
            refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
            scrollView.addSubview(refreshControl)

            miniTopButton.addTarget(self, action: #selector(shareDidTap), for: .touchUpInside)
            
            collectionLabel.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor(named: "black") ?? UIColor.black, thickness: 1, width: borderWidth)
            let collectionTap = UITapGestureRecognizer(target: self, action: #selector(collectionDidTap(_:)))
            collectionLabel?.isUserInteractionEnabled = true
            collectionLabel?.addGestureRecognizer(collectionTap)
            
            backButton.isHidden = true
            closeButton.isHidden = true
        }
    }
    
    @objc func followersContainerDidTap(_ sender: AnyObject) {
        let vc = FollowsViewController()
        vc.viewModel = FollowsViewModelImpl()
        vc.viewModel?.items.value = viewModel?.followers.value ?? []
        vc.viewModel?.typeFollows = .followers
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func followingContainerDidTap(_ sender: AnyObject) {
        let vc = FollowsViewController()
        vc.viewModel = FollowsViewModelImpl()
        vc.viewModel?.items.value = viewModel?.following.value ?? []
        vc.viewModel?.typeFollows = .following
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func refresh(_ sender: AnyObject) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.refreshControl.endRefreshing()
        }
    }
    
    @IBAction func dismissDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.didSelectItem(at: indexPath.row) { nftViewModel in
            let vc = DetailNftViewController()
            vc.viewModel = DetailNftViewModelImpl()
            vc.viewModel?.nftViewModel.value = nftViewModel
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
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

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = viewModel?.collectionNfts.value.count {
            return count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NftProfileViewCell", for: indexPath) as? NftProfileViewCell else { return UICollectionViewCell() }
        
        if let vm = viewModel?.collectionNfts.value[indexPath.row] {
            cell.bind(viewModel: vm)
        }
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            let size = (collectionView.frame.size.width - space) / 2 - 1
            return CGSize(width: size, height: size)
        }
}
