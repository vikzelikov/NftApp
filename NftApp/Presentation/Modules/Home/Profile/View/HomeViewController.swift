//
//  HomeViewController.swift
//  NftApp
//
//  Created by Yegor on 08.06.2021.
//

import UIKit

class HomeViewController: UIViewController {
    
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
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var miniTopButton: UIButton!
    @IBOutlet weak var collectionLabel: UILabel!
    @IBOutlet weak var observablesLabel: UILabel!
    @IBOutlet weak var followersContainer: UIStackView!
    @IBOutlet weak var followingContainer: UIStackView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    let refreshControl = UIRefreshControl()
    var items: [NftCellViewModel] = []
    var isOtherUser = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "NftProfileViewCell", bundle: nil), forCellWithReuseIdentifier: "NftProfileViewCell")
        
        items.append(NftCellViewModel(id: 0, price: 0.0, serialNumber: 0, isForCell: false, edition: EditionCellViewModel(id: 0, influencerId: 0, count: 0, name: "NFT #1", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, price: 500, dateExpiration: nil, mediaUrl: "https://sun9-64.userapi.com/impg/b6b8-4ek3-HAYctsvHRXcpPPMNOsmW_dGq418g/dZ2rmaBjGdM.jpg?size=1080x1080&quality=96&sign=cff5e3de07aff007fa4e9f091737da4d&type=album")))
        
        items.append(NftCellViewModel(id: 0, price: 0.0, serialNumber: 0, isForCell: false, edition: EditionCellViewModel(id: 0, influencerId: 0, count: 0, name: "NFT #2", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, price: 500, dateExpiration: nil, mediaUrl: "https://sun9-13.userapi.com/impg/RnIxGWvqxgaaigGE6qa8biwFt941LsmD48c7KQ/FJsXIqTSPag.jpg?size=1080x1080&quality=96&sign=df30af1f666f0db0cce43e5fd08b62ed&type=album")))
        
        items.append(NftCellViewModel(id: 0, price: 0.0, serialNumber: 0, isForCell: false, edition: EditionCellViewModel(id: 0, influencerId: 0, count: 0, name: "NFT #3", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, price: 500, dateExpiration: nil, mediaUrl: "https://sun9-75.userapi.com/impg/WH1eWaouXisW-LsvaOBAQFqcxlhZqNll5caF7w/cAbqcwEVRXM.jpg?size=1080x1080&quality=96&sign=3a1d6db8a95833baed6530f1ecfcfa3a&type=album")))
        

        reload()
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
        if let myWebsite = URL(string: "https://mydomain.com/@login") {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]

            activityVC.popoverPresentationController?.sourceView = sender as UIView
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    @objc func subscribeDidTap(_ sender: UIButton) {
        // new subscribe
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
        
        let followsTap = UITapGestureRecognizer(target: self, action: #selector(followsContainerDidTap(_:)))
        followersContainer?.isUserInteractionEnabled = true
        followersContainer?.addGestureRecognizer(followsTap)
        
        
        if isOtherUser {
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
    
    @objc func followsContainerDidTap(_ sender: AnyObject) {
        let vc = FollowsViewController()
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
        let vc = DetailNftViewController()
        vc.viewModel = DetailNftViewModelImpl()
        vc.viewModel?.nftViewModel.value = items[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
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
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NftProfileViewCell", for: indexPath) as? NftProfileViewCell else { return UICollectionViewCell() }
        
        cell.bind(viewModel: items[indexPath.row])
        
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
