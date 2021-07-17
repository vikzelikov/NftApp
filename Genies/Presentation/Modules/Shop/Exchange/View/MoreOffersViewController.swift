//
//  MoreOffersViewController.swift
//  Genies
//
//  Created by Yegor on 17.07.2021.
//

import UIKit

class MoreOffersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var items: [NftCellViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.register(UINib(nibName: "OfferPriceViewCell", bundle: nil), forCellReuseIdentifier: OfferPriceViewCell.cellIdentifier)
        
        items.append(NftCellViewModel(title: "Footwear by Lego", price: "100 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://i.ibb.co/K0G7h0d/image-removebg-preview-2-2.png"))
        items.append(NftCellViewModel(title: "Jacket by Lego", price: "50 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://i.ibb.co/LNxks2f/image-33.png"))
        items.append(NftCellViewModel(title: "Footwear by Lego", price: "80 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://i.ibb.co/HzXYLpz/image-43.png"))
        
        items.append(NftCellViewModel(title: "Footwear by Lego", price: "10 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://i.ibb.co/K0G7h0d/image-removebg-preview-2-2.png"))
        items.append(NftCellViewModel(title: "Jacket by Lego", price: "80 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://i.ibb.co/LNxks2f/image-33.png"))
        items.append(NftCellViewModel(title: "Footwear by Lego", price: "60 USD", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, imageUrl: "https://i.ibb.co/HzXYLpz/image-43.png"))
        
        reload()
    }
        
    func reload() {
        tableView.reloadData()
    }

    @IBAction func dismissDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension MoreOffersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = OfferPriceViewCell(nibName: "OfferPriceViewCell", bundle: nil)
//        vc.clothes = items[indexPath.row]
//        self.present(vc, animated: true, completion: nil)
                
//        HapticHelper.buttonVibro(.light)
    }
    
//    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath)
//
//        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
//        UIView.animate(withDuration: 0.1) {
//            cell?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
//        }
//    }
//
//    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath)
//        UIView.animate(withDuration: 0.1, delay: 0.1) {
//            cell?.transform = .identity
//        }
//    }
}

extension MoreOffersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OfferPriceViewCell", for: indexPath) as? OfferPriceViewCell else {
            assertionFailure("Cannot dequeue reusable cell")
            return UITableViewCell()
        }

        cell.bind(viewModel: items[indexPath.row])
        
        HapticHelper.buttonVibro(.light)
        
        return cell
    }
}
