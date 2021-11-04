//
//  PasswordViewController.swift
//  NftApp
//
//  Created by Yegor on 04.11.2021.
//

import UIKit

class PasswordViewController: UIViewController {

    var viewModel: SettingsViewModel? = nil
    
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var saveButton: AccentButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if viewModel == nil { viewModel = SettingsViewModelImpl() }
        
        setupStyle()
    }
    
    func setupStyle() {
        oldPasswordTextField.applyTextFieldStyle()
        newPasswordTextField.applyTextFieldStyle()
        confirmPasswordTextField.applyTextFieldStyle()
        
        saveButton.applyButtonEffects()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func saveDidTap(_ sender: Any) {
        viewModel?.passwordUpdateDidTap()
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        oldPasswordTextField.resignFirstResponder()
        newPasswordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
    }
    
}
