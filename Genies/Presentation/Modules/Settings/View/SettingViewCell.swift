//
//  TestViewCell.swift
//  Genies
//
//  Created by Yegor on 19.07.2021.
//

import UIKit

class SettingViewCell: UITableViewCell {

    static let cellIdentifier = String(describing: SettingViewCell.self)
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bind(viewModel: SettingCellViewModel) {
        titleLabel?.text = viewModel.title
        contentLabel?.text = viewModel.contentLabel
    }
    
}
