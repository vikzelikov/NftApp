//
//  WithdrawViewController.swift
//  NftApp
//
//  Created by Yegor on 01.08.2021.
//

import UIKit

class WithdrawViewController: UIViewController {

    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var withdrawButton: UIButton!
    @IBOutlet weak var calcAmountsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        
        amountTextField.addTarget(self, action: #selector(amountFieldDidChange), for: .editingChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func setupStyle() {
        withdrawButton.applyButtonStyle()
        withdrawButton.applyButtonEffects()
        
        amountTextField.delegate = self
    }
    
    @objc func amountFieldDidChange(_ sender: Any) {
        var calcTokens = 0
        
        if let amountString = amountTextField.text, let amount = Int(amountString) {
            calcTokens = amount / 3
            calcAmountsLabel.text = NSLocalizedString("You get", comment: "") + " \(calcTokens) T"
        }
        
        calcAmountsLabel.text = NSLocalizedString("You get", comment: "") + " \(calcTokens) USD"
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        amountTextField.resignFirstResponder()
    }

    @IBAction func dismissDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension WithdrawViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 4
    }
    
}
