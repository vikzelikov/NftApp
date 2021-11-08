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
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = SignupViewModelImpl()
        bindData()
        
        setupStyle()
    }
    
    private func setupStyle() {
        self.scrollView.delaysContentTouches = false

        loginTextField.becomeFirstResponder()

        loginTextField.applyTextFieldStyle()
        emailTextField.applyTextFieldStyle()
        passwordTextField.applyTextFieldStyle()
        confirmPassTextField.applyTextFieldStyle()
        
        nextButton.applyButtonEffects()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        loginTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPassTextField.delegate = self
    }

    @IBAction func nextButtonDidPress(_ sender: Any) {
        viewModel?.updateCredentials(
            login: loginTextField.text!,
            email: emailTextField.text!,
            password: passwordTextField.text!,
            confirmPassword: confirmPassTextField.text!
        )
        
        viewModel?.inputCredentials()
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
            if $0 { self?.showInitialView() }
        }
            
        viewModel?.errorMessage.bind {
            guard let errorMessage = $0 else { return }
            self.showError(error: errorMessage)
        }
    }
    
    private func showPersonalDataView() {
        if let viewController = UIStoryboard(name: "Authorization", bundle: nil).instantiateViewController(withIdentifier: "PersonalViewController") as? PersonalViewController {
            if let navigator = self.navigationController {
                viewController.viewModel = self.viewModel
                    navigator.pushViewController(viewController, animated: true)
                }
            }
    }
    
    private func showInitialView() {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        guard let page = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController else { return }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.window?.rootViewController = UINavigationController(rootViewController: page)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        loginTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPassTextField.resignFirstResponder()
    }
    
    @IBAction func dismissSignUp(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginTextField {
            textField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            confirmPassTextField.becomeFirstResponder()
        } else if textField == confirmPassTextField {
            viewModel?.updateCredentials(
                login: loginTextField.text!,
                email: emailTextField.text!,
                password: passwordTextField.text!,
                confirmPassword: confirmPassTextField.text!
            )
            
            viewModel?.inputCredentials()
            
            textField.resignFirstResponder()
        }
        
        return true
    }
}
