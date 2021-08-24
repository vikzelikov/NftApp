//
//  ExchangeViewController.swift
//  NftApp
//
//  Created by Yegor on 13.07.2021.
//

import UIKit

class ExchangeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var items: [NftCellViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.register(UINib(nibName: "NftExchangeViewCell", bundle: nil), forCellReuseIdentifier: NftExchangeViewCell.cellIdentifier)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 150, right: 0)

        
        items.append(NftCellViewModel(title: "Card name", price: "100 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://icons-for-free.com/iconfiles/png/512/boy+guy+man+icon-1320166733913205010.png"))
        items.append(NftCellViewModel(title: "Card name", price: "50 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://icons-for-free.com/iconfiles/png/512/boy+guy+man+icon-1320166733913205010.png"))
        items.append(NftCellViewModel(title: "Card name", price: "80 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://icons-for-free.com/iconfiles/png/512/boy+guy+man+icon-1320166733913205010.png"))
        
        items.append(NftCellViewModel(title: "Card name", price: "10 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://icons-for-free.com/iconfiles/png/512/boy+guy+man+icon-1320166733913205010.png"))
        items.append(NftCellViewModel(title: "Card name", price: "80 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://icons-for-free.com/iconfiles/png/512/boy+guy+man+icon-1320166733913205010.png"))
        items.append(NftCellViewModel(title: "Card name", price: "60 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://icons-for-free.com/iconfiles/png/512/boy+guy+man+icon-1320166733913205010.png"))
        
        reload()
        
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    @IBAction func filterDidTap(_ sender: Any) {
        showFilterBottomSheet()
    }
    
    private func showFilterBottomSheet() {
        let bottomSheet = FilterSheetViewController()
        bottomSheet.modalPresentationStyle = .custom
        bottomSheet.transitioningDelegate = self
        self.present(bottomSheet, animated: true, completion: nil)
    }
}


extension ExchangeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailNftViewController(nibName: "DetailNftViewController", bundle: nil)
        vc.nftCellViewModel = items[indexPath.row]
        vc.typeDetailNFT = .exchange
        self.present(vc, animated: true, completion: nil)
                
        HapticHelper.vibro(.light)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        UIView.animate(withDuration: 0.1) {
            cell?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        UIView.animate(withDuration: 0.1, delay: 0.1) {
            cell?.transform = .identity
        }
    }
}

extension ExchangeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NftExchangeViewCell", for: indexPath) as? NftExchangeViewCell else {
            assertionFailure("Cannot dequeue reusable cell")
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        HapticHelper.vibro(.light)
        
        cell.bind(viewModel: items[indexPath.row])
                
        return cell
    }
}

extension ExchangeViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        FilterSheetController(presentedViewController: presented, presenting: presenting)
    }
}
