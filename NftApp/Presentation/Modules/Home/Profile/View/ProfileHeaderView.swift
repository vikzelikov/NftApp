//
//  ProfileHeaderViewController.swift
//  NftApp
//
//  Created by Yegor on 26.10.2021.
//

import UIKit

class ProfileHeaderView: UIView {
    
    var viewModel: HomeViewModel?
    var navigationController: UINavigationController?
    var shareButtonDidTap: ((_ sender: UIButton) -> Void)?
    var dismissDidTap: (() -> Void)?
    var userImageDidTap: (() -> Void)?
    var collectionDidTap: (() -> Void)?
    var observablesDidTap: (() -> Void)?
    var createdDidTap: (() -> Void)?
    var isModal = false
    
    @IBOutlet weak var userImageView: UIImageView! {
        didSet {
            userImageView.layer.cornerRadius = userImageView.frame.width / 2
        }
    }
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var loginSubtitleLabel: UILabel!
    @IBOutlet weak var miniTopButton: UIButton!
    @IBOutlet weak var collectionLabel: UILabel!
    @IBOutlet weak var observablesLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var countNftsLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        let viewFromXib = Bundle.main.loadNibNamed("ProfileHeaderView", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
    }
    
    func viewDidLoad() {
        setupStyle()
        
        bindData()
    }
    
    func bindData() {
        viewModel?.userViewModel.observe(on: self) { [weak self] userVM in
            guard let userViewModel = userVM else { return }
            
            self?.loginLabel.text = userViewModel.login
            self?.loginSubtitleLabel.text = userViewModel.flowAddress ?? "@\(userViewModel.login ?? "")"
            self?.countNftsLabel.text = "\(Int(userViewModel.countNFTs ?? 0))"
            if let avatarUrl = userViewModel.avatarUrl, let url = URL(string: avatarUrl) {
                self?.userImageView.contentMode = .scaleAspectFill
                self?.userImageView.load(with: url)
            }
            
            self?.checkoutView()
        }
        
        viewModel?.followers.observe(on: self) { [weak self] followers in
            self?.followersLabel.text = "\(followers.count)"
        }
        
        viewModel?.following.observe(on: self) { [weak self] following in
            self?.followingLabel.text = "\(following.count)"
        }
        
        viewModel?.typeFollows.observe(on: self) { [weak self] (requester, user) in
            if user == TypeFollows.none {
                self?.miniTopButton.setTitle(NSLocalizedString("Follow", comment: ""), for: .normal)
            }
            
            if requester == TypeFollows.none && user == TypeFollows.followers {
                self?.miniTopButton.setTitle(NSLocalizedString("Follow back", comment: ""), for: .normal)
            }
            
            if requester == TypeFollows.followers {
                self?.miniTopButton.setTitle(NSLocalizedString("Unfollow", comment: ""), for: .normal)
            }
        }
    }
    
    @objc func loginSubtitleDidTap(_ sender: UITapGestureRecognizer) {
        guard let flowAddress = viewModel?.userViewModel.value?.flowAddress else { return }
        
        if let link = URL(string: "https://flowscan.org/account/\(flowAddress)") {
            UIApplication.shared.open(link)
        }
    }
    
    @objc func collectionDidTap(_ sender: UITapGestureRecognizer) {
        collectionDidTap?()
        
        checkoutList(selectedLabel: collectionLabel)
    }
    
    @objc func observablesDidTap(_ sender: UITapGestureRecognizer) {
        observablesDidTap?()
        
        checkoutList(selectedLabel: observablesLabel)
    }
    
    @objc func createdDidTap(_ sender: UITapGestureRecognizer) {
        createdDidTap?()
        
        checkoutList(selectedLabel: createdLabel)
    }
    
    private func checkoutList(selectedLabel: UILabel) {
        let countHeaders = getCountHeaders()
        
        HapticHelper.vibro(.light)
        
        let borderWidth = UIScreen.main.bounds.width / countHeaders
        collectionLabel.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor(named: "gray") ?? UIColor.gray, thickness: 1, width: borderWidth)
        observablesLabel.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor(named: "gray") ?? UIColor.gray, thickness: 1, width: borderWidth)
        createdLabel.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor(named: "gray") ?? UIColor.gray, thickness: 1, width: borderWidth)
        
        collectionLabel.textColor = UIColor.gray
        observablesLabel.textColor = UIColor.gray
        createdLabel.textColor = UIColor.gray
        
        var borderColor = UIColor(named: "black")
        if countHeaders == 1 {
            borderColor = UIColor(named: "gray")
        }
        selectedLabel.layer.addBorder(edge: UIRectEdge.bottom, color: borderColor ?? UIColor.black, thickness: 1, width: borderWidth)
        selectedLabel.textColor = UIColor(named: "black")
    }
    
    @objc func userImageDidTap(_ sender: UITapGestureRecognizer) {
        viewModel?.userImageDidTap { result in
            if result { self.userImageDidTap?() }
        }
    }
    
    @objc func shareDidTap(_ sender: UIButton) {
        shareButtonDidTap?(sender)
    }
    
    @objc func subscribeDidTap(_ sender: UIButton) {
        miniTopButton.isEnabled = false
        viewModel?.manageSubscribeDidTap(completion: { _ in
            self.miniTopButton.isEnabled = true
        })
    }
    
    private func setupStyle() {
        miniTopButton.applyButtonEffects()
        
        let followersTap = UITapGestureRecognizer(target: self, action: #selector(followersContainerDidTap(_:)))
        followersLabel?.isUserInteractionEnabled = true
        followersLabel?.addGestureRecognizer(followersTap)
        
        let followingsTap = UITapGestureRecognizer(target: self, action: #selector(followingContainerDidTap(_:)))
        followingLabel?.isUserInteractionEnabled = true
        followingLabel?.addGestureRecognizer(followingsTap)
        
        let loginSubtitleTap = UITapGestureRecognizer(target: self, action: #selector(loginSubtitleDidTap(_:)))
        loginSubtitleLabel?.isUserInteractionEnabled = true
        loginSubtitleLabel?.addGestureRecognizer(loginSubtitleTap)
        
        let userImageTap = UITapGestureRecognizer(target: self, action: #selector(userImageDidTap(_:)))
        userImageView?.isUserInteractionEnabled = true
        userImageView?.addGestureRecognizer(userImageTap)
        
        let collectionTap = UITapGestureRecognizer(target: self, action: #selector(collectionDidTap(_:)))
        collectionLabel?.isUserInteractionEnabled = true
        collectionLabel?.addGestureRecognizer(collectionTap)
        
        let observablesTap = UITapGestureRecognizer(target: self, action: #selector(observablesDidTap(_:)))
        observablesLabel?.isUserInteractionEnabled = true
        observablesLabel?.addGestureRecognizer(observablesTap)
        
        let createdTap = UITapGestureRecognizer(target: self, action: #selector(createdDidTap(_:)))
        createdLabel?.isUserInteractionEnabled = true
        createdLabel?.addGestureRecognizer(createdTap)
        
        if let count = navigationController?.viewControllers.count {
            if count < 2 { backButton.isHidden = true }
        } else {
            backButton.isHidden = true
            if isModal { closeButton.isHidden = false }
        }
                
        checkoutView()
    }
    
    func checkoutView() {
        guard let userViewModel = viewModel?.userViewModel.value else { return }
        
        if userViewModel.id == Constant.USER_ID {
            // it's me
            miniTopButton.addTarget(self, action: #selector(shareDidTap), for: .touchUpInside)
        }
        
        if userViewModel.id != Constant.USER_ID {
            // other user
            miniTopButton.setTitle(NSLocalizedString("Follow", comment: ""), for: .normal)
            miniTopButton.setImage(nil, for: .normal)
            miniTopButton.addTarget(self, action: #selector(subscribeDidTap), for: .touchUpInside)

            observablesLabel.isHidden = true
        }

        if userViewModel.influencerId != nil {
            collectionLabel.isUserInteractionEnabled = true
            createdLabel.isHidden = false
        } else if userViewModel.id != Constant.USER_ID {
            collectionLabel.isUserInteractionEnabled = false
        }
        
        if let typeList = viewModel?.typeListNfts.value {
            switch typeList {
            case .collection:
                checkoutList(selectedLabel: collectionLabel)
            case .observables:
                checkoutList(selectedLabel: observablesLabel)
            case .created:
                checkoutList(selectedLabel: createdLabel)
            }
        }
    }
    
    func getCountHeaders() -> CGFloat {
        var count = 0
        
        if !collectionLabel.isHidden { count += 1 }
        if !observablesLabel.isHidden { count += 1 }
        if !createdLabel.isHidden { count += 1 }
        
        return CGFloat(count)
    }
    
    @objc func followersContainerDidTap(_ sender: AnyObject) {
        if let followers = viewModel?.followers.value {
            if !followers.isEmpty {
                let vc = FollowsViewController()
                vc.viewModel = FollowsViewModelImpl()
                vc.viewModel?.userViewModel.value = viewModel?.userViewModel.value
                vc.viewModel?.typeFollows = .followers
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @objc func followingContainerDidTap(_ sender: AnyObject) {
        if let following = viewModel?.following.value {
            if !following.isEmpty {
                let vc = FollowsViewController()
                vc.viewModel = FollowsViewModelImpl()
                vc.viewModel?.userViewModel.value = viewModel?.userViewModel.value
                vc.viewModel?.typeFollows = .following
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func dismissDidTap(_ sender: Any) {
        dismissDidTap?()
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        dismissDidTap?()
    }

}
