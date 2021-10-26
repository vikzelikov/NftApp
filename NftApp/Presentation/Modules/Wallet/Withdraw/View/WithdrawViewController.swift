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
        withdrawButton.applyButtonEffects()
        
        amountTextField.delegate = self
        
        calcAmountsLabel.text = NSLocalizedString("You get", comment: "") + " \(0) USD"
    }
    
    @objc func amountFieldDidChange(_ sender: Any) {
        var calcAmounts = 0.0
        
        if let amountString = amountTextField.text, let amount = Double(amountString) {
            calcAmounts = amount / 3
            calcAmounts = Double(round(100 * calcAmounts) / 100)
            calcAmountsLabel.text = NSLocalizedString("You get", comment: "") + " \(calcAmounts) T"
        }
        
        calcAmountsLabel.text = NSLocalizedString("You get", comment: "") + " \(calcAmounts) РУБ"
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
