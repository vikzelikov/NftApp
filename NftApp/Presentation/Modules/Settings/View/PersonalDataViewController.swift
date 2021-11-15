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
        UserObject.user.observe(on: self) { [weak self] userViewModel in
            self?.loginTextField.text = userViewModel?.login
            self?.emailTextField.text = userViewModel?.email
        }
        
        viewModel?.errorMessage.observe(on: self) { [weak self] errMessage in
            guard let errorMessage = errMessage else { return }
            self?.showMessage(message: errorMessage)
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
