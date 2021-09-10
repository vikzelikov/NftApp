//
//  NftProfileViewCell.swift
//  NftApp
//
//  Created by Yegor on 29.07.2021.
//

import UIKit
import SDWebImage

class NftProfileViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainView: UIView!
    
    var mainImageView : UIImageView  = {
        var imageView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var imageViewHeight = NSLayoutConstraint()
    var imageRatioWidth = CGFloat()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addSubview(mainImageView)
//        mainView.layer.shadowColor = UIColor(named: "gray")?.cgColor
//        mainView.layer.shadowOpacity = 1
//        mainView.layer.shadowOffset = .zero
//        mainView.layer.shadowRadius = 5
        
        mainImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        mainImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        mainImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        mainImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        mainImageView.layer.cornerRadius = 12
    }
    
    func bind(viewModel: NftCellViewModel) {
        if let url = viewModel.imageUrl {
            mainImageView.sd_setImage(with: URL(string: url)!)
        }
    }
}

extension UIImage {
    func getImageRatio() -> CGFloat {
        let imageRatio = CGFloat(self.size.width / self.size.height)
        return imageRatio
    }
}
