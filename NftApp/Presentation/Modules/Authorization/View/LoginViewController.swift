//
//  LoginViewController.swift
//  NftApp
//
//  Created by Yegor on 09.07.2021.
//

import UIKit
import AuthenticationServices

class LoginViewController: UIViewController {
    
    var viewModel: LoginViewModel?
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var appleAuthView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = LoginViewModelImpl()
        viewModel?.viewDidload()
        bindData()
        
        setupStyle()
    }
    
    func setupStyle() {
        self.navigationController?.navigationBar.isHidden = true

        setupSignInAppleButton()

        loginTextField.applyTextFieldStyle()
        passwordTextField.applyTextFieldStyle()
        
        loginButton.applyButtonStyle()
        loginButton.applyButtonEffects()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        loginTextField.delegate = self
        passwordTextField.delegate = self
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
            $0 ? self?.loginButton.loadingIndicator(isShow: true, titleButton: nil)
            : self?.loginButton.loadingIndicator(isShow: false, titleButton: "NEXT")
        }
        
        viewModel?.isSuccess.bind { [weak self] in
            if $0 { self?.showInitialView() }
        }
        
        viewModel?.isSetupInvite.bind { [weak self] in
            if $0 { self?.setupInviteView() }
        }
            
        viewModel?.errorMessage.bind {
            guard let errorMessage = $0 else { return }
            self.showMessage(message: errorMessage)
        }
    }
    
    func showInitialView() {
        let storyboard = UIStoryboard(name: "Initial", bundle: nil)
        guard let page = storyboard.instantiateViewController(withIdentifier: "InitialViewController") as? InitialViewController else { return }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.window?.rootViewController = UINavigationController(rootViewController: page)
    }
    
    func setupInviteView() {
        dismissKeyboard()
        
        let inviteView = InviteView(frame: view.bounds)
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.contentView.addSubview(inviteView)
        blurEffectView.alpha = 0
        view.addSubview(blurEffectView)
        
        inviteView.viewDidLoad()

        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            blurEffectView.alpha = 1.0
        })
    }
    
    @objc func dismissKeyboard () {
        loginTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @IBAction func dismissLogin(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            viewModel?.updateCredentials(
                login: loginTextField.text!,
                password: passwordTextField.text!
            )

            viewModel?.inputCredentials()
            
            textField.resignFirstResponder()
        }
        
        return true
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    func setupSignInAppleButton() {
        if #available(iOS 13.0, *) {
            var authorizationButton: ASAuthorizationAppleIDButton
            if self.traitCollection.userInterfaceStyle == .dark {
                authorizationButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .white)
            } else {
                authorizationButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
            }

            let appleAuthTap = UITapGestureRecognizer(target: self, action: #selector(handleAppleIdRequest))
            appleAuthTap.cancelsTouchesInView = false
            appleAuthView.addGestureRecognizer(appleAuthTap)
            authorizationButton.cornerRadius = 10
            authorizationButton.translatesAutoresizingMaskIntoConstraints = false
            appleAuthView.addSubview(authorizationButton)
            authorizationButton.centerXAnchor.constraint(equalTo: appleAuthView.centerXAnchor).isActive = true
            authorizationButton.centerYAnchor.constraint(equalTo: appleAuthView.centerYAnchor).isActive = true
            authorizationButton.widthAnchor.constraint(equalToConstant: 220).isActive = true
            authorizationButton.heightAnchor.constraint(equalToConstant: 45).isActive = true

        } else {
            appleAuthView.isHidden = true
        }
    }
    
    @objc func handleAppleIdRequest() {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
        }
    }
    
    @objc(authorizationController:didCompleteWithAuthorization:)
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let appleId = appleIDCredential.user
            viewModel?.appleAuthDidTap(appleId: appleId)
        }
    }
}
