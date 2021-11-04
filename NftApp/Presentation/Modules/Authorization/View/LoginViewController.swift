//
//  LoginViewController.swift
//  NftApp
//
//  Created by Yegor on 09.07.2021.
//

import UIKit
import AuthenticationServices

class LoginViewController: UIViewController, ASAuthorizationControllerDelegate {
    
    var viewModel: LoginViewModel?
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var appleAuthView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = LoginViewModelImpl()
        bindData()
        
        setupStyle()
    }
    
    private func setupStyle() {
        self.navigationController?.navigationBar.isHidden = true

        setupSignInAppleButton()

        loginTextField.applyTextFieldStyle()
        passwordTextField.applyTextFieldStyle()
        
        loginButton.applyButtonStyle()
        loginButton.applyButtonEffects()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func loginDidTap(_ sender: Any) {
        viewModel?.updateCredentials(
            login: loginTextField.text!,
            password: passwordTextField.text!
        )

        viewModel?.inputCredentials()
    }
    
    @IBAction func signupDidTap(_ sender: Any) {
        let homeStoryboard = UIStoryboard(name: "Authorization", bundle: nil)
                guard let vc = homeStoryboard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else { return }
                navigationController?.pushViewController(vc, animated: true)
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
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        guard let page = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController else { return }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.window?.rootViewController = UINavigationController(rootViewController: page)
    }
    
    func setupSignInAppleButton() {
        if #available(iOS 13.0, *) {
            var authorizationButton: ASAuthorizationAppleIDButton
            if self.traitCollection.userInterfaceStyle == .dark {
                authorizationButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .white)
            } else {
                authorizationButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
            }
//            authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchDown)
            let appleAuthTap = UITapGestureRecognizer(target: self, action: #selector(handleAppleIdRequest))
            appleAuthTap.cancelsTouchesInView = false
            appleAuthView.addGestureRecognizer(appleAuthTap)
            authorizationButton.cornerRadius = 8
            authorizationButton.translatesAutoresizingMaskIntoConstraints = false
            appleAuthView.addSubview(authorizationButton)
            authorizationButton.centerXAnchor.constraint(equalTo: appleAuthView.centerXAnchor).isActive = true
            authorizationButton.centerYAnchor.constraint(equalTo: appleAuthView.centerYAnchor).isActive = true
            authorizationButton.widthAnchor.constraint(equalToConstant: 240).isActive = true
            authorizationButton.heightAnchor.constraint(equalToConstant: 40).isActive = true

        } else {
            appleAuthView.isHidden = true
        }
    }
    
    @objc func handleAppleIdRequest() {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
        }
    }
    
    @objc(authorizationController:didCompleteWithAuthorization:)
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
        }
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        loginTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @IBAction func dismissLogin(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

}
