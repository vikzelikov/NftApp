//
//  ViewController.swift
//  NftApp
//
//  Created by Yegor on 07.06.2021.
//

import UIKit

class SignUpViewController: UIViewController {
    
    var viewModel: SignupViewModel?

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPassTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = SignupViewModelImpl()
        bindData()
        
        setupStyle()
    }
    
    private func setupStyle() {
        loginTextField.becomeFirstResponder()

        loginTextField.applyTextFieldStyle()
        emailTextField.applyTextFieldStyle()
        passwordTextField.applyTextFieldStyle()
        confirmPassTextField.applyTextFieldStyle()
        
        nextButton.applyButtonStyle()
        nextButton.applyButtonEffects()
    }

    @IBAction func nextButtonDidPress(_ sender: Any) {
        viewModel?.updateCredentials(
            login: loginTextField.text!,
            email: emailTextField.text!,
            password: passwordTextField.text!,
            confirmPassword: confirmPassTextField.text!
        )
        
//        viewModel?.inputCredentials()
        showHomeView()
    }
        
    func bindData() {
        viewModel?.isLoading.bind { [weak self] in
            if $0 {
                self?.nextButton.loadingIndicator(isShow: true, titleButton: nil)
            } else {
                self?.nextButton.loadingIndicator(isShow: false, titleButton: "NEXT")
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
    
    private func showPersonalDataView() {
        if let viewController = UIStoryboard(name: "Authorization", bundle: nil).instantiateViewController(withIdentifier: "PersonalDataViewController") as? PersonalDataViewController {
            if let navigator = self.navigationController {
                viewController.viewModel = self.viewModel
                    navigator.pushViewController(viewController, animated: true)
                }
            }
    }
    
    private func showHomeView() {
        let homeStoryboard = UIStoryboard(name: "TabBar", bundle: nil)
        guard let homePage = homeStoryboard.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController else { return }
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        appDelegate.window?.rootViewController = homePage
        navigationController?.pushViewController(homePage, animated: false)
    }
    
    @IBAction func dismissSignUp(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
