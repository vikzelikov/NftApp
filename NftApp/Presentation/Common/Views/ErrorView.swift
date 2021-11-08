//
//  ErrorView.swift
//  NftApp
//
//  Created by Yegor on 07.11.2021.
//

import UIKit

class ErrorView: UIView {
    
    @IBOutlet weak var errorLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        let viewFromXib = Bundle.main.loadNibNamed("ErrorView", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
    }
    
}
