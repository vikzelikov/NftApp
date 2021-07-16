//
//  DetailDropViewController.swift
//  Genies
//
//  Created by Yegor on 15.07.2021.
//

import UIKit

class DetailDropViewController: UIViewController {
    
    var clothes: ClothesCellViewModel? = nil

    @IBOutlet weak var clothesImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var balanceView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buyButton.applyButtonStyle()
        buyButton.applyButtonEffects()
        
        if let price = clothes?.price {
            buyButton?.setTitle("\(price)", for: .normal)
        }
            
        titleLabel?.text = clothes?.title
        descriptionLabel?.text = clothes?.description
        if let stringUrl = clothes?.imageUrl {
            if let url = getUrl(stringUrl: stringUrl) {
                clothesImageView.sd_setImage(with: url)
            }
        }
    }
    
    func getUrl(stringUrl: String) -> URL? {
        return URL(string: stringUrl)
    }
    
    @IBAction func dismissDetailView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

