//
//  PersonalDatViewController.swift
//  NftApp
//
//  Created by Yegor on 04.11.2021.
//

import UIKit

class PersonalDataViewController: UIViewController {

    var viewModel: SettingsViewModel? = nil
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var saveButton: AccentButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if viewModel == nil { viewModel = SettingsViewModelImpl() }
        bindData()
        
        setupStyle()
    }
    
    func bindData() {
        UserObject.user.bind {
            self.loginTextField.text = $0?.login
            self.emailTextField.text = $0?.email
        }
        
        viewModel?.errorMessage.bind {
            guard let errorMessage = $0 else { return }
            self.showMessage(message: errorMessage)
        }
    }
    
    func setupStyle() {
        loginTextField.applyTextFieldStyle()
        emailTextField.applyTextFieldStyle()
        
        saveButton.applyButtonEffects()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func saveDidTap(_ sender: Any) {
        if let login = loginTextField.text, let email = emailTextField.text {
            saveButton.loadingIndicator(isShow: true, titleButton: nil)

            viewModel?.personalUpdateDidTap(login: login, email: email, completion: { result in
                self.saveButton.loadingIndicator(isShow: false, titleButton: NSLocalizedString("Save", comment: "").uppercased())
                
                if result {
                    self.showMessage(message: NSLocalizedString("Saved", comment: ""), isHaptic: false)
                }
            })
        }
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        loginTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
    }
    
    @IBAction func dismissDidTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
