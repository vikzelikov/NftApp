//
//  AuthViewController.swift
//  NftApp
//
//  Created by Yegor on 10.07.2021.
//

import UIKit

class AuthViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
    }
    
    func setupStyle() {
        self.navigationController?.navigationBar.isHidden = true

        loginButton.applyButtonStyle()
        loginButton.applyButtonEffects()
        
        signupButton.applyButtonEffects()
    }
    
    @IBAction func loginDidTap(_ sender: Any) {        
        let homeStoryboard = UIStoryboard(name: "Authorization", bundle: nil)
        guard let vc = homeStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func signupDidTap(_ sender: Any) {
        let homeStoryboard = UIStoryboard(name: "Authorization", bundle: nil)
        guard let vc = homeStoryboard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
    
    
    
    
    
    
    
    
 
