//
//  DropShopViewController.swift
//  NftApp
//
//  Created by Yegor on 13.07.2021.
//

import UIKit

class DropShopViewController: UIViewController {

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
        tableView.register(UINib(nibName: "NftDropViewCell", bundle: nil), forCellReuseIdentifier: NftDropViewCell.cellIdentifier)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 150, right: 0)
        
        items.append(NftCellViewModel(title: "NFT #1", price: "500 РУБ", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://sun9-64.userapi.com/impg/b6b8-4ek3-HAYctsvHRXcpPPMNOsmW_dGq418g/dZ2rmaBjGdM.jpg?size=1080x1080&quality=96&sign=cff5e3de07aff007fa4e9f091737da4d&type=album"))
        items.append(NftCellViewModel(title: "NFT #2", price: "500 РУБ", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://sun9-13.userapi.com/impg/RnIxGWvqxgaaigGE6qa8biwFt941LsmD48c7KQ/FJsXIqTSPag.jpg?size=1080x1080&quality=96&sign=df30af1f666f0db0cce43e5fd08b62ed&type=album"))
        items.append(NftCellViewModel(title: "NFT #3", price: "500 РУБ", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://sun9-75.userapi.com/impg/WH1eWaouXisW-LsvaOBAQFqcxlhZqNll5caF7w/cAbqcwEVRXM.jpg?size=1080x1080&quality=96&sign=3a1d6db8a95833baed6530f1ecfcfa3a&type=album"))
        
        reload()
    }
    
    func reload() {
        tableView.reloadData()
    }
    
}

extension DropShopViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailNftViewController(nibName: "DetailNftViewController", bundle: nil)
        vc.nftCellViewModel = items[indexPath.row]
        vc.typeDetailNFT = .dropShop
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

extension DropShopViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NftDropViewCell", for: indexPath) as? NftDropViewCell else {
            assertionFailure("Cannot dequeue reusable cell")
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        HapticHelper.vibro(.light)
        
        cell.bind(viewModel: items[indexPath.row])
        
        return cell
    }
}
