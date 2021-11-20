//
//  InviteView.swift
//  NftApp
//
//  Created by Yegor on 13.11.2021.
//

import UIKit

class EarlyAccessView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        let viewFromXib = Bundle.main.loadNibNamed("EarlyAccessView", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
    }
    
    func viewDidLoad() {
        HapticHelper.longHaptic()
    }

}
