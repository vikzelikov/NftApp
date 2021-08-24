//
//  NftProfileViewCell.swift
//  NftApp
//
//  Created by Yegor on 29.07.2021.
//

import UIKit

class NftProfileViewCell: UICollectionViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleNft: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainView.layer.shadowColor = UIColor(named: "gray")?.cgColor
        mainView.layer.shadowOpacity = 1
        mainView.layer.shadowOffset = .zero
        mainView.layer.shadowRadius = 5
    }
    
    func bind(viewModel: NftCellViewModel) {
        titleNft.text = viewModel.title
//        imageView.image = UIImage(named: "ava")
//        if let stringUrl = viewModel.imageUrl {
//            if let url = getUrl(stringUrl: stringUrl) {
//                imageView.sd_setImage(with: url)
//            }
//        }
    }
    
    func getUrl(stringUrl: String) -> URL? {
        return URL(string: stringUrl)
    }

}
