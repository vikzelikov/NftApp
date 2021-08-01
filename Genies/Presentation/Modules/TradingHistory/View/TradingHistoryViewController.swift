//
//  TradingHistoryViewController.swift
//  Genies
//
//  Created by Yegor on 17.07.2021.
//

import UIKit

class TradingHistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var items: [HistoryCellViewModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.register(UINib(nibName: "HistoryViewCell", bundle: nil), forCellReuseIdentifier: HistoryViewCell.cellIdentifier)
        
        items.append(HistoryCellViewModel(loginOwner: "some login", datePurchase: "12/12/2012", price: "1234 USD"))
        items.append(HistoryCellViewModel(loginOwner: "some login", datePurchase: "12/12/2012", price: "1234 USD"))
        items.append(HistoryCellViewModel(loginOwner: "some login", datePurchase: "12/12/2012", price: "1234 USD"))
        items.append(HistoryCellViewModel(loginOwner: "some login", datePurchase: "12/12/2012", price: "1234 USD"))
        items.append(HistoryCellViewModel(loginOwner: "some login", datePurchase: "12/12/2012", price: "1234 USD"))
        items.append(HistoryCellViewModel(loginOwner: "some login", datePurchase: "12/12/2012", price: "1234 USD"))
        items.append(HistoryCellViewModel(loginOwner: "some login", datePurchase: "12/12/2012", price: "1234 USD"))
        items.append(HistoryCellViewModel(loginOwner: "some login", datePurchase: "12/12/2012", price: "1234 USD"))

        
        reload()
        
    }
    
    func reload() {
        tableView.reloadData()
    }

    @IBAction func dismissDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}

extension TradingHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = OfferPriceViewCell(nibName: "OfferPriceViewCell", bundle: nil)
//        vc.clothes = items[indexPath.row]
//        self.present(vc, animated: true, completion: nil)
                
//        HapticHelper.buttonVibro(.light)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)

        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
//        UIView.animate(withDuration: 0.1) {
//            cell?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
//        }
    }
//
//    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath)
//        UIView.animate(withDuration: 0.1, delay: 0.1) {
//            cell?.transform = .identity
//        }
//    }
}

extension TradingHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryViewCell", for: indexPath) as? HistoryViewCell else {
            assertionFailure("Cannot dequeue reusable cell")
            return UITableViewCell()
        }

        cell.bind(viewModel: items[indexPath.row])
        
        HapticHelper.vibro(.light)
        
        return cell
    }
}

