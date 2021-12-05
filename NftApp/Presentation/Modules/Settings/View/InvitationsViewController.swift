//
//  InvitationsViewController.swift
//  NftApp
//
//  Created by Yegor on 17.11.2021.
//

import UIKit

class InvitationsViewController: UIViewController {

    var viewModel: SettingsViewModel?
    
    @IBOutlet weak var inviteTextField: UITextField!
    @IBOutlet weak var saveButton: AccentButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if viewModel == nil { viewModel = SettingsViewModelImpl() }
        bindData()
        
        setupStyle()
    }
    
    func bindData() {
        UserObject.user.observe(on: self) { [weak self] userViewModel in
            self?.inviteTextField.text = userViewModel?.inviteWord
        }
        
        viewModel?.errorMessage.observe(on: self) { [weak self] errMessage in
            guard let errorMessage = errMessage else { return }
            self?.showMessage(message: errorMessage)
        }
    }
    
    func setupStyle() {
        inviteTextField.applyTextFieldStyle()
        
        saveButton.applyButtonEffects()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func saveDidTap(_ sender: Any) {
        if let inviteWord = inviteTextField.text {
            saveButton.loadingIndicator(isShow: true, titleButton: nil)

            viewModel?.invitationsUpdateDidTap(inviteWord: inviteWord, completion: { result in
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
        inviteTextField.resignFirstResponder()
    }
    
    @IBAction func dismissDidTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
