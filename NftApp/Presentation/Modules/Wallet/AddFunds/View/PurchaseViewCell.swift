//
//  PurchaseViewCell.swift
//  NftApp
//
//  Created by Yegor on 22.11.2021.
//

import UIKit

class PurchaseViewCell: UITableViewCell {
    
    static let cellIdentifier = String(describing: PurchaseViewCell.self)
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tokensLabel: UILabel!
    @IBOutlet weak var fiatLabel: UILabel!
    
    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()

        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency

        return formatter
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bind(viewModel: InAppPurchase) {
//        let currency = InitialDataObject.data.value?.tokenCurrency ?? 0.0
        
        tokensLabel.text = "\(viewModel.price) T"
        fiatLabel.text = PurchaseViewCell.priceFormatter.string(from: viewModel.price)
        
        viewModel.isSelected ? setSelected() : resetSelected()
    }
    
    func setSelected() {
        mainView.alpha = 1
                        
        mainView.layer.borderWidth = 2
        mainView.layer.borderColor = UIColor(named: "orange")?.cgColor
    }
    
    func resetSelected() {
        mainView.alpha = 0.5

        mainView.layer.borderWidth = 0
        mainView.layer.borderColor = UIColor.clear.cgColor
    }
    
}
