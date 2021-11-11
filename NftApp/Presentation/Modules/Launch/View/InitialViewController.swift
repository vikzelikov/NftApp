//
//  InitialViewController.swift
//  NftApp
//
//  Created by Yegor on 26.08.2021.
//

import UIKit

class InitialViewController: UIViewController {
    
    var viewModel: InitialViewModel?
    
    let loadingIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var reloadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = InitialViewModelImpl()
        viewModel?.initial(isDelay: false)
        bindData()
        
        setupStyle()
    }
    
    func setupStyle() {
        reloadButton.applyButtonEffects()
        
        if #available(iOS 13.0, *) {
            loadingIndicator.style = .large
        } else {
            loadingIndicator.style = .gray
        }
        loadingIndicator.center = self.view.center
        self.view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func bindData() {
        viewModel?.isShowHome.bind { [weak self] in
            guard let isShowHome = $0 else { return }
            
            isShowHome ? self?.showHomeView() : self?.showAuthView()
        }
        
        viewModel?.errorMessage.bind {
            guard let errorMessage = $0 else { return }
            
            self.checkoutLoading(isShow: false)
            
            self.errorLabel.text = errorMessage
        }
        
        viewModel?.isLoading.bind {
            self.checkoutLoading(isShow: $0)
        }
    }
    
    func checkoutLoading(isShow: Bool) {
        if isShow {
            self.loadingIndicator.startAnimating()
            self.errorLabel.isHidden = true
            self.reloadButton.isHidden = true
        } else {
            self.loadingIndicator.stopAnimating()
            self.errorLabel.isHidden = false
            self.reloadButton.isHidden = false
        }
    }
    
    @IBAction func reloadDidTap(_ sender: Any) {
        viewModel?.initial(isDelay: true)
    }
    
    private func showAuthView() {
        let storyboard = UIStoryboard(name: "Authorization", bundle: nil)
        guard let page = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.window?.rootViewController = UINavigationController(rootViewController: page)
    }
    
    private func showHomeView() {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        guard let page = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController else { return }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.window?.rootViewController = UINavigationController(rootViewController: page)
    }
    
}
