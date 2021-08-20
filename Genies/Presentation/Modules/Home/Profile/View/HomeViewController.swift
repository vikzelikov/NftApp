//
//  HomeViewController.swift
//  Genies
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
    
    let refreshControl = UIRefreshControl()
    var items: [NftCellViewModel] = []
    var isOtherUser = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserUseCaseImpl().getUser( completion: { result in
            switch result {
            case .success(let isSuccess):
                NSLog("OK Signup!!!!: \(isSuccess)")
            case .failure(let error):
                NSLog("ERROR!!!!: \(String(describing: SignupViewModel.self)) \(error)")
                if let error = error as? ErrorMessage, let code = error.code {
                    switch code {
                    case let c where c >= HttpCode.internalServerError:
                        print( NSLocalizedString("defaultError", comment: ""))
                    case HttpCode.badRequest:
                        print( error.errorDTO?.message)
                    case HttpCode.unauthorized:
                        print("авторизуйся")
                    default:
                        print( NSLocalizedString("defaultError", comment: ""))
                    }
                }

            }
        })
 
        setupStyle()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "NftProfileViewCell", bundle: nil), forCellWithReuseIdentifier: "NftProfileViewCell")
        
        items.append(NftCellViewModel(title: "Card name", price: "100 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://icons-for-free.com/iconfiles/png/512/boy+guy+man+icon-1320166733913205010.png"))
        items.append(NftCellViewModel(title: "Card name", price: "50 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://icons-for-free.com/iconfiles/png/512/boy+guy+man+icon-1320166733913205010.png"))
        items.append(NftCellViewModel(title: "Card name", price: "80 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://icons-for-free.com/iconfiles/png/512/boy+guy+man+icon-1320166733913205010.png"))
        
        items.append(NftCellViewModel(title: "Card name", price: "10 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://icons-for-free.com/iconfiles/png/512/boy+guy+man+icon-1320166733913205010.png"))
        items.append(NftCellViewModel(title: "Card name", price: "80 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://icons-for-free.com/iconfiles/png/512/boy+guy+man+icon-1320166733913205010.png"))
        items.append(NftCellViewModel(title: "Card name", price: "60 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://icons-for-free.com/iconfiles/png/512/boy+guy+man+icon-1320166733913205010.png"))
        items.append(NftCellViewModel(title: "Card name", price: "100 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://icons-for-free.com/iconfiles/png/512/boy+guy+man+icon-1320166733913205010.png"))
        items.append(NftCellViewModel(title: "Card name", price: "50 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://icons-for-free.com/iconfiles/png/512/boy+guy+man+icon-1320166733913205010.png"))
        items.append(NftCellViewModel(title: "Card name", price: "80 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://icons-for-free.com/iconfiles/png/512/boy+guy+man+icon-1320166733913205010.png"))
        
        items.append(NftCellViewModel(title: "Card name", price: "10 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://icons-for-free.com/iconfiles/png/512/boy+guy+man+icon-1320166733913205010.png"))
        items.append(NftCellViewModel(title: "Card name", price: "80 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://icons-for-free.com/iconfiles/png/512/boy+guy+man+icon-1320166733913205010.png"))
        items.append(NftCellViewModel(title: "Card name", price: "60 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://icons-for-free.com/iconfiles/png/512/boy+guy+man+icon-1320166733913205010.png"))
        items.append(NftCellViewModel(title: "Card name", price: "100 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://icons-for-free.com/iconfiles/png/512/boy+guy+man+icon-1320166733913205010.png"))
        items.append(NftCellViewModel(title: "Card name", price: "50 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://icons-for-free.com/iconfiles/png/512/boy+guy+man+icon-1320166733913205010.png"))
        items.append(NftCellViewModel(title: "Card name", price: "80 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://icons-for-free.com/iconfiles/png/512/boy+guy+man+icon-1320166733913205010.png"))
        
        items.append(NftCellViewModel(title: "Card name", price: "10 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://icons-for-free.com/iconfiles/png/512/boy+guy+man+icon-1320166733913205010.png"))
        items.append(NftCellViewModel(title: "Card name", price: "80 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://icons-for-free.com/iconfiles/png/512/boy+guy+man+icon-1320166733913205010.png"))
        items.append(NftCellViewModel(title: "Card name", price: "60 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://icons-for-free.com/iconfiles/png/512/boy+guy+man+icon-1320166733913205010.png"))
        
        reload()
    }
    
    func reload() {
        collectionView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        collectionViewHeight.constant = CGFloat(2000)
    }
    
    @objc func collectionDidTap(_ sender: UITapGestureRecognizer) {
        checkoutCollections(selectedLabel: collectionLabel, unselectedLabel: observablesLabel)
    }
    
    @objc func observablesDidTap(_ sender: UITapGestureRecognizer) {
        checkoutCollections(selectedLabel: observablesLabel, unselectedLabel: collectionLabel)
    }
    
    private func checkoutCollections(selectedLabel: UILabel, unselectedLabel: UILabel) {
        let borderWidth = (UIScreen.main.bounds.width - 0) / 2
        selectedLabel.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.white, thickness: 1, width: borderWidth)
        unselectedLabel.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor(named: "gray") ?? UIColor.gray, thickness: 1, width: borderWidth)
        
        selectedLabel.textColor = UIColor.white
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
        observablesLabel.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.lightGray.withAlphaComponent(0.2), thickness: 1, width: borderWidth)
        observablesLabel.textColor = UIColor.gray
        
        let observablesTap = UITapGestureRecognizer(target: self, action: #selector(observablesDidTap(_:)))
        observablesLabel?.isUserInteractionEnabled = true
        observablesLabel?.addGestureRecognizer(observablesTap)

        miniTopButton.applyButtonEffects()
        
        let followsTap = UITapGestureRecognizer(target: self, action: #selector(followsContainerDidTap(_:)))
        followersContainer?.isUserInteractionEnabled = true
        followersContainer?.addGestureRecognizer(followsTap)
        
        
        if isOtherUser {
            miniTopButton.setTitle("Follow", for: .normal)
            miniTopButton.setImage(nil, for: .normal)
            miniTopButton.addTarget(self, action: #selector(subscribeDidTap), for: .touchUpInside)

            observablesLabel.isHidden = true
            collectionLabel.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.lightGray.withAlphaComponent(0.2), thickness: 1, width: windowWidth)
        } else {
            refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
            scrollView.addSubview(refreshControl)

            miniTopButton.addTarget(self, action: #selector(shareDidTap), for: .touchUpInside)
            collectionLabel.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.white, thickness: 1, width: borderWidth)
            
            let collectionTap = UITapGestureRecognizer(target: self, action: #selector(collectionDidTap(_:)))
            collectionLabel?.isUserInteractionEnabled = true
            collectionLabel?.addGestureRecognizer(collectionTap)
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
}

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = DetailNftViewController()
        viewController.nftCellViewModel = items[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
//        let vc = storyboard?.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
//        navigationController?.pushViewController(vc, animated: true)

        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NftProfileViewCell", for: indexPath) as! NftProfileViewCell
        cell.backgroundColor = UIColor(named: "gray")
        cell.layer.cornerRadius = 12
        
        cell.bind(viewModel: items[indexPath.row])
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            let size = (collectionView.frame.size.width - space) / 2 - 5
            return CGSize(width: size, height: size)
        }
}
