//
//  HeaderView.swift
//  NftApp
//
//  Created by Yegor on 19.11.2021.
//

import UIKit

class HeaderView: UIView {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var rightArrow: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        let viewFromXib = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
    }
    
    func bind(title: String, showArrow: Bool = false) {
        headerLabel.text = title
        rightArrow.isHidden = !showArrow
    }
    
}
