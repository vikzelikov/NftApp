//
//  ViewController.swift
//  Genies
//
//  Created by Yegor on 07.06.2021.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPassTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        emailTextField.becomeFirstResponder()
        
        setupStyle()
    }
    
    private func setupStyle() {
        emailTextField.applyTextFieldStyle()
        passwordTextField.applyTextFieldStyle()
        confirmPassTextField.applyTextFieldStyle()
        
        nextButton.applyButtonStyle()
        nextButton.applyButtonEffects()
    }

    @IBAction func nextButtonDidPress(_ sender: Any) {
        let vc = PersonalDataViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func dismissSignUp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}


