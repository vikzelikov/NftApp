//
//  CollectionViewCell2.swift
//  Genies
//
//  Created by Yegor on 29.07.2021.
//

import UIKit

class NftProfileViewCell: UICollectionViewCell {

    @IBOutlet weak var titleNft: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bind(viewModel: NftCellViewModel) {
        titleNft.text = viewModel.title
        imageView.image = UIImage(named: "ava")
    }

}
