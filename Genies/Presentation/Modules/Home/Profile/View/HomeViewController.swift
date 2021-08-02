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
    
    let refreshControl = UIRefreshControl()
    var items: [NftCellViewModel] = []
    var isOtherUser = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        setupStyle()
    
        if isOtherUser {
            miniTopButton.setTitle("Follow", for: .normal)
            miniTopButton.setImage(nil, for: .normal)
            
            observablesLabel.isHidden = true
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "NftProfileViewCell", bundle: nil), forCellWithReuseIdentifier: "NftProfileViewCell")
        
        items.append(NftCellViewModel(title: "Footwear by Lego", price: "100 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry of the printing of the printing of the printing of the printing", date: nil, imageUrl: "https://i.ibb.co/K0G7h0d/image-removebg-preview-2-2.png"))
        items.append(NftCellViewModel(title: "Jacket by Lego", price: "50 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://i.ibb.co/LNxks2f/image-33.png"))
        items.append(NftCellViewModel(title: "Footwear by Lego", price: "80 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://i.ibb.co/HzXYLpz/image-43.png"))
        
        items.append(NftCellViewModel(title: "Footwear by Lego", price: "10 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://i.ibb.co/K0G7h0d/image-removebg-preview-2-2.png"))
        items.append(NftCellViewModel(title: "Jacket by Lego", price: "80 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://i.ibb.co/LNxks2f/image-33.png"))
        items.append(NftCellViewModel(title: "Footwear by Lego", price: "60 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://i.ibb.co/HzXYLpz/image-43.png"))
        
        items.append(NftCellViewModel(title: "Footwear by Lego", price: "40 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://i.ibb.co/K0G7h0d/image-removebg-preview-2-2.png"))
        items.append(NftCellViewModel(title: "Jacket by Lego", price: "35 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://i.ibb.co/LNxks2f/image-33.png"))
        items.append(NftCellViewModel(title: "Footwear by Lego", price: "20 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://i.ibb.co/HzXYLpz/image-43.png"))
        
        items.append(NftCellViewModel(title: "Footwear by Lego", price: "10 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://i.ibb.co/K0G7h0d/image-removebg-preview-2-2.png"))
        items.append(NftCellViewModel(title: "Jacket by Lego", price: "100 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://i.ibb.co/LNxks2f/image-33.png"))
        items.append(NftCellViewModel(title: "Footwear by Lego", price: "10 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://i.ibb.co/HzXYLpz/image-43.png"))
        
        items.append(NftCellViewModel(title: "Footwear by Lego", price: "100 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://i.ibb.co/K0G7h0d/image-removebg-preview-2-2.png"))
        items.append(NftCellViewModel(title: "Jacket by Lego", price: "60 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://i.ibb.co/LNxks2f/image-33.png"))
        items.append(NftCellViewModel(title: "Footwear by Lego", price: "100 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://i.ibb.co/HzXYLpz/image-43.png"))
        
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
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        scrollView.addSubview(refreshControl)
        
        let windowWidth: CGFloat = UIScreen.main.bounds.width
        var borderWidth = windowWidth / 2
        if isOtherUser { borderWidth = windowWidth}
        collectionLabel.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.white, thickness: 1, width: borderWidth)
        observablesLabel.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.lightGray.withAlphaComponent(0.2), thickness: 1, width: borderWidth)
        observablesLabel.textColor = UIColor.gray
        
        let collectionTap = UITapGestureRecognizer(target: self, action: #selector(collectionDidTap(_:)))
        collectionLabel?.isUserInteractionEnabled = true
        collectionLabel?.addGestureRecognizer(collectionTap)
        
        let observablesTap = UITapGestureRecognizer(target: self, action: #selector(observablesDidTap(_:)))
        observablesLabel?.isUserInteractionEnabled = true
        observablesLabel?.addGestureRecognizer(observablesTap)

        miniTopButton.applyButtonEffects()
        miniTopButton.addTarget(self, action: #selector(shareDidTap), for: .touchUpInside)
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
