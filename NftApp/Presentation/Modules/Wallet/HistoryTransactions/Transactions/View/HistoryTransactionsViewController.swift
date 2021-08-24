//
//  HistoryTransactionsViewController.swift
//  NftApp
//
//  Created by Yegor on 01.08.2021.
//

import UIKit

class HistoryTransactionsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }

    @IBAction func dismissDidTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorColor = UIColor.lightGray.withAlphaComponent(0.3)
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 70, bottom: 0, right: 0)
        tableView.register(UINib(nibName: "TransactionViewCell", bundle: nil), forCellReuseIdentifier: TransactionViewCell.cellIdentifier)
    }
}

extension HistoryTransactionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = DetailTransactionViewController()
//        viewController.transaction = transactions[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    
        tableView.deselectRow(at: indexPath, animated: true)
        HapticHelper.vibro(.light)
    }
}

extension HistoryTransactionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionViewCell", for: indexPath) as? TransactionViewCell else {
            assertionFailure("Cannot dequeue reusable cell")
            return UITableViewCell()
        }
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.default

//        cell.bind(viewModel: items[indexPath.row])
                
        return cell
    }
}

