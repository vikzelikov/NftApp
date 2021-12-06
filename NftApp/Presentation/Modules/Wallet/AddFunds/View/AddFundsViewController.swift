//
//  AddFundsViewController.swift
//  NftApp
//
//  Created by Yegor on 01.08.2021.
//

import UIKit

class AddFundsViewController: UIViewController {
    
    var viewModel: AddFundsViewModel?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: AccentButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = AddFundsViewModelImpl()
        viewModel?.viewDidLoad()
        
        bindData()

        setupStyle()
    }
    
    func setupStyle() {
        if #available(iOS 13.0, *) {
            loadingIndicator.style = .large
        } else {
            loadingIndicator.style = .gray
        }

        nextButton.applyButtonEffects()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.register(
            UINib(nibName: PurchaseViewCell.cellIdentifier, bundle: nil),
            forCellReuseIdentifier: PurchaseViewCell.cellIdentifier
        )
        
    }
    
    func bindData() {
        viewModel?.products.observe(on: self) { [weak self] products in
            if !products.isEmpty {
                self?.tableView.isHidden = false
                self?.tableView.reloadData()
            }
        }
        
        viewModel?.errorMessage.observe(on: self) { [weak self] errMessage in
            guard let errorMessage = errMessage else { return }
            self?.showMessage(message: errorMessage)
        }
        
        viewModel?.isLoading.observe(on: self) { [weak self] isLoading in
            isLoading ? self?.loadingIndicator.startAnimating() : self?.loadingIndicator.stopAnimating()
        }
    }
        
    @IBAction func continueDidTap(_ sender: Any) {
        nextButton.loadingIndicator(isShow: true, titleButton: nil)

        viewModel?.nextDidTap { result in
            if result {
                self.showMessage(message: NSLocalizedString("Successful purchase", comment: ""), isHaptic: false)
            }
            
            self.nextButton.loadingIndicator(isShow: false, titleButton: "GET")
        }
    }
    
    @IBAction func dismissDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}

extension AddFundsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.productDidTap(index: indexPath.row)
        
        HapticHelper.vibro(.light)
    }
}

extension AddFundsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = viewModel?.products.value.count {
            return count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PurchaseViewCell.cellIdentifier, for: indexPath)
        guard
            let cell = cell as? PurchaseViewCell
        else {
            assertionFailure("Cannot dequeue reusable cell")
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none

        if let vm = viewModel?.products.value[indexPath.row] {
            cell.bind(viewModel: vm)
        }
                
        return cell
    }
}
