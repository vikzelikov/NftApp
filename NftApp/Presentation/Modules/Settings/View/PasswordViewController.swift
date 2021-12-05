//
//  PasswordViewController.swift
//  NftApp
//
//  Created by Yegor on 04.11.2021.
//

import UIKit

class PasswordViewController: UIViewController {

    var viewModel: SettingsViewModel?
    
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var saveButton: AccentButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if viewModel == nil { viewModel = SettingsViewModelImpl() }
        bindData()
        
        setupStyle()
    }
    
    func bindData() {
        viewModel?.errorMessage.observe(on: self) { [weak self] errMessage in
            guard let errorMessage = errMessage else { return }
            self?.showMessage(message: errorMessage)
        }
    }
    
    func setupStyle() {
        oldPasswordTextField.applyTextFieldStyle()
        newPasswordTextField.applyTextFieldStyle()
        confirmPasswordTextField.applyTextFieldStyle()
        
        saveButton.applyButtonEffects()
        
        oldPasswordTextField.delegate = self
        newPasswordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func saveDidTap(_ sender: Any) {
        saveDidTap()
    }
    
    func saveDidTap() {
        if let oldPassword = oldPasswordTextField.text,
            let newPassword = newPasswordTextField.text,
            let confirmPassword = confirmPasswordTextField.text {
            
            saveButton.loadingIndicator(isShow: true, titleButton: nil)

            viewModel?.passwordUpdateDidTap(oldPassword: oldPassword,
                                            newPassword: newPassword,
                                            confirmPassword: confirmPassword, completion: { result in
                
                self.saveButton.loadingIndicator(
                    isShow: false,
                    titleButton: NSLocalizedString("Save", comment: "").uppercased()
                )
                
                if result {
                    self.showMessage(message: NSLocalizedString("Saved", comment: ""), isHaptic: false)
                }
            })
        }
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        oldPasswordTextField.resignFirstResponder()
        newPasswordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
    }
    
    @IBAction func dismissDidTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension PasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == oldPasswordTextField {
            textField.resignFirstResponder()
            newPasswordTextField.becomeFirstResponder()
        } else if textField == newPasswordTextField {
            textField.resignFirstResponder()
            confirmPasswordTextField.becomeFirstResponder()
        } else if textField == confirmPasswordTextField {
            saveDidTap()
        }
        
        return true
    }
}
