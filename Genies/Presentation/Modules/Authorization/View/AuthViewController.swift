//
//  AuthViewController.swift
//  Genies
//
//  Created by Yegor on 10.07.2021.
//

import UIKit

class AuthViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.applyButtonStyle()
        loginButton.applyButtonEffects()
        
        signupButton.applyButtonEffects()
    }
    
}



