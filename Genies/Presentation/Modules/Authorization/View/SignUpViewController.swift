//
//  ViewController.swift
//  Genies
//
//  Created by Yegor on 07.06.2021.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var phoneContainer: UIView!
    @IBOutlet weak var emailContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        phoneTextField.becomeFirstResponder()
    }
    
    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            phoneTextField.becomeFirstResponder()
            phoneContainer.isHidden = false
            emailContainer.isHidden = true
        } else {
            emailTextField.becomeFirstResponder()
            phoneContainer.isHidden = true
            emailContainer.isHidden = false
        }
    }

    @IBAction func nextButtonDidPress(_ sender: Any) {
//        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
//        guard let homePage = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
//        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        appDelegate.window?.rootViewController = homePage
    }
    
    @IBAction func dismissSignUp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}


