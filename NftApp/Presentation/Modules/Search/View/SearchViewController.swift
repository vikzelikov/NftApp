//
//  SearchViewController.swift
//  NftApp
//
//  Created by Yegor on 02.08.2021.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.becomeFirstResponder()
    }

}
