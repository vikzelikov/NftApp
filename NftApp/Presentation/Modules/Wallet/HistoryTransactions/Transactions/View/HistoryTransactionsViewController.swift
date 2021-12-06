//
//  HistoryTransactionsViewController.swift
//  NftApp
//
//  Created by Yegor on 01.08.2021.
//

import UIKit

class HistoryTransactionsViewController: UIViewController {
    
    var viewModel: HistoryTransactionsViewModel?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorLabel: UILabelPadding!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = HistoryTransactionsViewModelImpl()
        viewModel?.viewDidLoad()
        bindData()
        
        setupStyle()
    }
    
    func bindData() {
        viewModel?.items.observe(on: self) { [weak self] items in
            self?.reload()
        
            self?.tableView.isHidden = false
            self?.errorLabel.isHidden = true
            
            if items.isEmpty {
                self?.tableView.isHidden = true
                self?.errorLabel.text = NSLocalizedString("Nothing here", comment: "")
                self?.errorLabel.isHidden = false
            }
        }
        
        viewModel?.errorMessage.observe(on: self) { [weak self] errMessage in
            guard let errorMessage = errMessage else { return }
            self?.showMessage(message: errorMessage)
        }
    }
    
    func setupStyle() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorColor = UIColor.lightGray.withAlphaComponent(0.3)
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 70, bottom: 0, right: 0)
        tableView.register(
            UINib(nibName: "TransactionViewCell", bundle: nil),
            forCellReuseIdentifier: TransactionViewCell.cellIdentifier
        )
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
        }
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    @IBAction func dismissDidTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension HistoryTransactionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didSelectItem(at: indexPath.row) { transactionViewModel in
            let vc = DetailTransactionViewController()
            vc.viewModel = DIContainer.shared.resolve(type: DetailTransactionViewModel.self)
            vc.viewModel?.transactionViewModel.value = transactionViewModel
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        HapticHelper.vibro(.light)
    }
}

extension HistoryTransactionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = viewModel?.items.value.count {
            return count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView
                .dequeueReusableCell(withIdentifier: "TransactionViewCell", for: indexPath)
                as? TransactionViewCell
        else {
            assertionFailure("Cannot dequeue reusable cell")
            return UITableViewCell()
        }
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.default

        if let vm = viewModel?.items.value[indexPath.row] {
            cell.bind(viewModel: vm)
        }
                
        return cell
    }
}
