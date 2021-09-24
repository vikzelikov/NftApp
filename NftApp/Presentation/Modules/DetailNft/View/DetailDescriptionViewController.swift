//
//  DetailDescriptionViewController.swift
//  NftApp
//
//  Created by Yegor on 24.09.2021.
//

import UIKit

class DetailDescriptionViewController: UIViewController {

    var descriptionNft: String? = nil
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionLabel.text = descriptionNft
    }

    @IBAction func dismissDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
