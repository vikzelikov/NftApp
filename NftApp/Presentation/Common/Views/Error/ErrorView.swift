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
        guard
            let viewFromXib = Bundle.main.loadNibNamed("ErrorView", owner: self, options: nil),
            let view = viewFromXib.first as? UIView
        else {
            fatalError("Error cast \(self)")
        }
        
        view.frame = self.bounds
        addSubview(view)
    }
    
}
