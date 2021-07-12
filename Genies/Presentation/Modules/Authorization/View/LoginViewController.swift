//
//  LoginViewController.swift
//  Genies
//
//  Created by Yegor on 09.07.2021.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
    }
    
    private func setupStyle() {
        emailTextField.applyTextFieldStyle()
        passwordTextField.applyTextFieldStyle()
        
        loginButton.applyButtonStyle()
        loginButton.applyButtonEffects()
    }
    
    @IBAction func loginDidTap(_ sender: Any) {
        loginButton.loadingIndicator(isShow: true, titleButton: nil)
        
        // LOGiN
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showHome()
        }
    }
    
    @IBAction func dismissLogin(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func showHome() {
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        guard let homePage = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.window?.rootViewController = homePage
    }

}
