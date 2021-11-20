//
//  InviteView.swift
//  NftApp
//
//  Created by Yegor on 13.11.2021.
//

import UIKit

class InviteView: UIView {
    
    var viewModel: InviteViewModel?
    
    @IBOutlet weak var nextButton: AccentButton!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var inviteTextField: UITextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        let viewFromXib = Bundle.main.loadNibNamed("InviteView", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
    }
    
    func viewDidLoad() {
        viewModel = InviteViewModelImpl()
        bindData()
        
        setupStyle()
        
        HapticHelper.longHaptic()
    }
    
    func bindData() {
        viewModel?.isLoading.observe(on: self) { [weak self] isLoading in
            isLoading ? self?.nextButton.loadingIndicator(isShow: true, titleButton: nil)
            : self?.nextButton.loadingIndicator(isShow: false, titleButton: "NEXT")
        }
        
        viewModel?.isSuccess.observe(on: self) { [weak self] isSuccess in
            if isSuccess { self?.showInitialView() }
        }
            
        viewModel?.errorMessage.observe(on: self) { [weak self] errMessage in
            guard let errorMessage = errMessage else { return }
            self?.inviteTextField.layer.borderColor = UIColor(named: "orange")?.cgColor
            self?.inviteTextField.text = ""
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self?.inviteTextField.layer.borderColor = UIColor.gray.withAlphaComponent(0.2).cgColor
            }
            
            self?.showMessage(message: errorMessage)
        }
    }
    
    func setupStyle() {
        inviteTextField.delegate = self
        inviteTextField.borderStyle = .none
        inviteTextField.layer.borderColor = UIColor.gray.withAlphaComponent(0.2).cgColor
        inviteTextField.layer.borderWidth = 1.0
        inviteTextField.layer.cornerRadius = 12
        
        nextButton.applyButtonEffects()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func nextDidTap(_ sender: Any) {
        if let inviteWord = inviteTextField.text {
            viewModel?.nextDidTap(inviteWord: inviteWord)
        }
    }
    
    func showInitialView() {
        let storyboard = UIStoryboard(name: "Initial", bundle: nil)
        guard let page = storyboard.instantiateViewController(withIdentifier: "InitialViewController") as? InitialViewController else { return }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.window?.rootViewController = UINavigationController(rootViewController: page)
    }
    
    @objc func dismissKeyboard () {
        inviteTextField.resignFirstResponder()
    }
    
}

extension InviteView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         if textField == inviteTextField {
             if let inviteWord = inviteTextField.text {
                 viewModel?.nextDidTap(inviteWord: inviteWord)
             }
            
            textField.resignFirstResponder()
        }
        
        return true
    }
}
