//
//  ViewController.swift
//  Genies
//
//  Created by Yegor on 07.06.2021.
//

import UIKit

class AuthViewController: UIViewController {
    
    @IBOutlet weak var const: NSLayoutConstraint!
    @IBOutlet weak var phoneBox: UILabel!
    @IBOutlet weak var emailBox: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLabelTap()
        
//        emailTextField.becomeFirstResponder()
        
        emailBox.addBottomBorderWithColor(color: UIColor.red, width: 1.0)
        phoneBox.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.gray, thickness: 1, width: const.constant)
    }
    
    
    @objc func phoneBoxTapped(_ sender: UITapGestureRecognizer) {
        phoneBox.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.red, thickness: 1, width: const.constant)
        emailBox.addBottomBorderWithColor(color: UIColor.gray, width: 1.0)
    }
    
    @objc func emailBoxTapped(_ sender: UITapGestureRecognizer) {
        phoneBox.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.gray, thickness: 1, width: const.constant)
        emailBox.addBottomBorderWithColor(color: UIColor.red, width: 1.0)
    }
        
    func setupLabelTap() {
        let phoneBoxTap = UITapGestureRecognizer(target: self, action: #selector(phoneBoxTapped(_:)))
        phoneBox.isUserInteractionEnabled = true
        phoneBox.addGestureRecognizer(phoneBoxTap)

        let emailBoxTap = UITapGestureRecognizer(target: self, action: #selector(emailBoxTapped(_:)))
        emailBox.isUserInteractionEnabled = true
        emailBox.addGestureRecognizer(emailBoxTap)
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


