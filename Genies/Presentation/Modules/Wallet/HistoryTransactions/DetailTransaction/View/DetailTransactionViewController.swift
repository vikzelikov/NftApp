//
//  DetailTransactionViewController.swift
//  Genies
//
//  Created by Yegor on 01.08.2021.
//

import UIKit

class DetailTransactionViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func dismissDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
        navigationController?.popViewController(animated: true)
    }
    
}
