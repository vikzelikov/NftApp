//
//  TableViewCell.swift
//  Genies
//
//  Created by Yegor on 24.07.2021.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    static let cellIdentifier = String(describing: TableViewCell.self)

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bind(viewModel: String) {
        label.text = viewModel
    }
}
