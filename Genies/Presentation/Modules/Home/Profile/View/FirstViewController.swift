//
//  FirstViewController.swift
//  Genies
//
//  Created by Yegor on 29.07.2021.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    var moveHeader: ((CGFloat) -> ())!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "CollectionViewCell2", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell2")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        collectionViewHeight.constant = CGFloat(2000)
    }
    
}




extension FirstViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell2", for: indexPath) as! CollectionViewCell2
//        cell.label.text = "\(indexPath.row)"
        cell.backgroundColor = UIColor.orange
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        scrollView.bounces = scrollView.contentOffset.y > 100

        let offset = scrollView.contentOffset.y
        var positionY = (-abs(scrollView.contentOffset.y + 450) + 0)

        if offset < -450 {
            positionY = (abs(scrollView.contentOffset.y + 450) + 0)
        }

        print("\(offset) \(positionY)")

        if positionY < -350 {
            positionY = -350
        }
        
//        moveHeader(positionY)
    }
}


extension FirstViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space) / 3.1
            return CGSize(width: size, height: size)
        }
}
