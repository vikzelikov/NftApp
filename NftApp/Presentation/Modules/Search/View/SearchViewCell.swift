//
//  SearchViewCell.swift
//  NftApp
//
//  Created by Yegor on 05.11.2021.
//

import UIKit

class SearchViewCell: UITableViewCell {

    static let cellIdentifier = String(describing: SearchViewCell.self)
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var searchImageView: UIImageView! {
        didSet {
            searchImageView.layer.cornerRadius = searchImageView.frame.width / 2
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bind(viewModel: SearchCellViewModel) {
        titleLabel?.text = viewModel.title
        
        if let subtitle = viewModel.subtitle {
            subtitleLabel.isHidden = false
            subtitleLabel.text = subtitle
        } else {
            subtitleLabel.isHidden = true
        }
        
        if let mediaUrl = viewModel.mediaUrl, let url = URL(string: mediaUrl) {
            searchImageView.contentMode = .scaleAspectFill
            searchImageView.sd_setImage(with: url)
        } else {
            searchImageView.contentMode = .scaleAspectFit
            searchImageView.image = UIImage(named: "mini_icon")
        }
        
        if viewModel.type == .separator {
            headerLabel?.text = viewModel.title
            headerLabel.isHidden = false
            titleLabel.isHidden = true
            searchImageView.isHidden = true
        } else {
            headerLabel.isHidden = true
            titleLabel.isHidden = false
            searchImageView.isHidden = false
        }
    }
    
}
