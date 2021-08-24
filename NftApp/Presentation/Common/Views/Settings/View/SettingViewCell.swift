//
//  TestViewCell.swift
//  NftApp
//
//  Created by Yegor on 19.07.2021.
//

import UIKit

class SettingViewCell: UITableViewCell {

    static let cellIdentifier = String(describing: SettingViewCell.self)
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var iconContentView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bind(viewModel: SettingCellViewModel) {
        titleLabel?.text = viewModel.title

        if viewModel.contentLabel != nil {
            contentLabel?.text = viewModel.contentLabel
        } else if viewModel.iconContentView != nil {
            iconContentView?.image = viewModel.iconContentView
            
            contentLabel.isHidden = true
            iconContentView.isHidden = false
        }
    }
    
}
