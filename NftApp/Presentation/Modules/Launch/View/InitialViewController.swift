//
//  InitialViewController.swift
//  NftApp
//
//  Created by Yegor on 26.08.2021.
//

import UIKit

class InitialViewController: UIViewController {
    
    var viewModel: InitialViewModel?
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = InitialViewModelImpl()
        
        viewModel?.initial()
        
        bindData()
    }
    
    func bindData() {        
        viewModel?.isShowHome.bind { [weak self] in
            guard let isShowHome = $0 else { return }
            
            if isShowHome {
                self?.showHomeView()
            } else {
                self?.showAuthView()
            }
        }
        
        viewModel?.errorMessage.bind {
            guard let errorMessage = $0 else { return }
            
            self.errorLabel.text = errorMessage
            self.errorLabel.isHidden = false
            self.loadingIndicator.stopAnimating()
        }
    }
    
    private func showAuthView() {
        let authStoryboard = UIStoryboard(name: "Authorization", bundle: nil)
        guard let page = authStoryboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else { return }
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        appDelegate.window?.rootViewController = page
        
        page.modalPresentationStyle = .fullScreen
        present(page, animated: true, completion: nil)
    }
    
    private func showHomeView() {
        let homeStoryboard = UIStoryboard(name: "TabBar", bundle: nil)
        guard let page = homeStoryboard.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController else { return }
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        appDelegate.window?.rootViewController = page
        
        page.modalPresentationStyle = .fullScreen
        present(page, animated: true, completion: nil)
    }
    
}
