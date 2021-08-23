//
//  LoginViewController.swift
//  Genies
//
//  Created by Yegor on 09.07.2021.
//

import UIKit

class LoginViewController: UIViewController {
    
    var viewModel: LoginViewModel?
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = LoginViewModelImpl()
        bindData()
        
        setupStyle()
    }
    
    private func setupStyle() {
        loginTextField.applyTextFieldStyle()
        passwordTextField.applyTextFieldStyle()
        
        loginButton.applyButtonStyle()
        loginButton.applyButtonEffects()
    }
    
    @IBAction func loginDidTap(_ sender: Any) {
        viewModel?.updateCredentials(
            login: loginTextField.text!,
            password: passwordTextField.text!
        )
        
//        viewModel?.inputCredentials()
        showHomeView()
    }
    
    func bindData() {
        viewModel?.isLoading.bind { [weak self] in
            if $0 {
                self?.loginButton.loadingIndicator(isShow: true, titleButton: nil)
            } else {
                self?.loginButton.loadingIndicator(isShow: false, titleButton: "NEXT")
            }
        }
        
        viewModel?.isSuccess.bind { [weak self] in
            if $0 { self?.showHomeView() }
        }
            
        viewModel?.errorMessage.bind {
            guard let errorMessage = $0 else { return }
            let alert = UIAlertController(title: "Error Message", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func showHomeView() {
        let homeStoryboard = UIStoryboard(name: "TabBar", bundle: nil)
        guard let homePage = homeStoryboard.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController else { return }
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        appDelegate.window?.rootViewController = homePage
        navigationController?.pushViewController(homePage, animated: false)
    }
    
    @IBAction func dismissLogin(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

}
