//
//  ViewController.swift
//  Genies
//
//  Created by Yegor on 07.06.2021.
//

import UIKit

class AuthViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.becomeFirstResponder()
    }
    
    

    @IBAction func nextButtonDidPress(_ sender: Any) {
//        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
//        guard let homePage = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
//        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        appDelegate.window?.rootViewController = homePage
    }
    
    @IBAction func dismissSignUp(_ sender: Any) {
        navigationController?.popViewController(animated: true)

        dismiss(animated: true, completion: nil)
    }
    
}
