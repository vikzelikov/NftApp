//
//  HistoryTransactionsViewController.swift
//  Genies
//
//  Created by Yegor on 01.08.2021.
//

import UIKit

class HistoryTransactionsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func dismissDidTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
