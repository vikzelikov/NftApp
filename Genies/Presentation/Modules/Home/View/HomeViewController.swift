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
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        setupStyle()
        
        miniTopButton.addTarget(self, action: #selector(shareDidTap), for: .touchUpInside)
        
//        miniTopButton.setTitle("Follow", for: .normal)
//        miniTopButton.setImage(nil, for: .normal)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        collectionViewHeight.constant = CGFloat(2000)
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
        let borderWidth = (windowWidth - 0) / 2
        collectionLabel.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.white, thickness: 1, width:
                                                    borderWidth)
        observablesLabel.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.lightGray.withAlphaComponent(0.2), thickness: 1, width:
                                                    borderWidth)

        miniTopButton.applyButtonEffects()
    }

    @objc func refresh(_ sender: AnyObject) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.refreshControl.endRefreshing()
        }
    }
    
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell2
        cell.label.text = "\(indexPath.row)"
        cell.backgroundColor = UIColor.orange
        return cell
    }
}


extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space) / 2.1
            return CGSize(width: size, height: size)
        }
}
