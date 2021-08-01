//
//  HomeHeader.swift
//  Genies
//
//  Created by Yegor on 26.07.2021.
//

import UIKit

import UIKit

class HomeHeader: UIView {

    @IBOutlet weak var userImageView: UIImageView! {
        didSet {
            userImageView.layer.cornerRadius = userImageView.frame.width / 2
        }
    }
    @IBOutlet weak var miniTopButton: UIButton!
    @IBOutlet weak var collectionContainer: UILabel!
    @IBOutlet weak var observablesContainer: UILabel!
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        setupStyle()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        let viewFromXib = Bundle.main.loadNibNamed("HomeHeader", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
    }
    
    private func setupStyle() {        
        let windowWidth: CGFloat = UIScreen.main.bounds.width
        let borderWidth = (windowWidth - 0) / 2
        collectionContainer.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.white, thickness: 1, width:
                                                    borderWidth)
        observablesContainer.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.lightGray.withAlphaComponent(0.2), thickness: 1, width:
                                                    borderWidth)

        miniTopButton.applyButtonEffects()
    }

}

