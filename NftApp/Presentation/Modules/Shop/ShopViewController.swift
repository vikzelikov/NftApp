//
//  ShopViewController.swift
//  NftApp
//
//  Created by Yegor on 13.07.2021.
//

import UIKit

class ShopViewController: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSlideScrollView()
        
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: fix this
    private func setupSlideScrollView() {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height:  view.frame.size.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(2), height: view.frame.height - 150)
        scrollView.isPagingEnabled = true
        
        let dropShop = DropShopViewController(nibName: "DropShopViewController", bundle: nil)
        addViewController(vc: dropShop, x: 0)
        
        let exchange = ExchangeViewController(nibName: "ExchangeViewController", bundle: nil)
        addViewController(vc: exchange, x: view.frame.width)
    }
    
    private func addViewController(vc: UIViewController, x: CGFloat) {
        vc.view.frame = CGRect(x: x, y: -1, width: view.frame.size.width, height:  view.frame.size.height)
        self.addChild(vc)
        scrollView.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
}

extension ShopViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(floorf(Float(scrollView.contentOffset.x / scrollView.frame.size.width)))
    }
}
