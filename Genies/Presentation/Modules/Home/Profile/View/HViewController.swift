//
//  HViewController.swift
//  Genies
//
//  Created by Yegor on 26.07.2021.
//

import UIKit

class HViewController: UIViewController {

    @IBOutlet weak var pageScrollView: UIScrollView!
    let headerView = HomeHeader(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 450))
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        pageScrollView.contentInset = UIEdgeInsets(top: 450, left: 0, bottom: 0, right: 0)
        
        headerView.contentMode = .scaleAspectFill
        headerView.clipsToBounds = true
//        self.view.addSubview(headerView)
        
        setupSlideScrollView()
    }

    private func setupSlideScrollView() {
        pageScrollView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height:  view.frame.size.height)
        pageScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(2), height: view.frame.height)
        pageScrollView.isPagingEnabled = true
        
        let dropShop = FirstViewController(nibName: "FirstViewController", bundle: nil)
        dropShop.moveHeader = moveHeader
    

        addViewController(vc: dropShop, x: 0)

        let exchange = FirstViewController(nibName: "FirstViewController", bundle: nil)
        addViewController(vc: exchange, x: view.frame.width)
    }
    
    private func addViewController(vc: UIViewController, x: CGFloat) {
        vc.view.frame = CGRect(x: x, y: 0, width: view.frame.size.width, height:  view.frame.size.height)
        self.addChild(vc)
        pageScrollView.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
    private func moveHeader(positionY: CGFloat) {
        headerView.frame = CGRect(x: 0, y: positionY, width: UIScreen.main.bounds.size.width, height: 450)
    }
}



class TestViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
