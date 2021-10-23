//
//  AddFundsViewController.swift
//  NftApp
//
//  Created by Yegor on 01.08.2021.
//

import UIKit
import PassKit
import TinkoffASDKUI

class AddFundsViewController: UIViewController {
    
    var viewModel: AddFundsViewModel?

    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var applePayView: UIView!
    @IBOutlet weak var calcAmountsLabel: UILabel!
    private var applePayButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = AddFundsViewModelImpl()
        
        bindData()

        setupStyle()
        
        amountTextField.addTarget(self, action: #selector(amountFieldDidChange), for: .editingChanged)
        calcTokens()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func setupStyle() {
        if self.traitCollection.userInterfaceStyle == .dark {
            applePayButton = PKPaymentButton(paymentButtonType: .buy, paymentButtonStyle: .white)
        } else {
            applePayButton = PKPaymentButton(paymentButtonType: .buy, paymentButtonStyle: .black)
        }
        
        if let applePayButton = applePayButton {
            applePayView.addSubview(applePayButton)
            applePayButton.translatesAutoresizingMaskIntoConstraints = false
            applePayButton.applyButtonEffects()
            NSLayoutConstraint.activate([
                applePayButton.widthAnchor.constraint(equalTo: self.applePayView.widthAnchor, multiplier: 1),
            ])
            applePayButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
            applePayButton.layer.cornerRadius = 12
            applePayButton.clipsToBounds = true
            
            applePayButton.addTarget(self, action: #selector(self.applePayButtonDidTap), for: .touchUpInside)
        }
        
        amountTextField.delegate = self
        
        calcAmountsLabel.text = NSLocalizedString("You get", comment: "") + " \(0) T"
    }
    
    func bindData() {
        viewModel?.errorMessage.bind {
            guard let errorMessage = $0 else { return }
            let alert = UIAlertController(title: "Error Message", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func applePayButtonDidTap() {
        calcTokens()
        
        viewModel?.applePayButtonDidTap { sdk, applePayConfigs, paymentData in
            sdk.presentPaymentApplePay(on: self, paymentData: paymentData, viewConfiguration: AcquiringViewConfiguration(), paymentConfiguration: applePayConfigs, completionHandler: { response in

                print(response)
            })
        }
    }
    
    @objc func amountFieldDidChange(_ sender: Any) {
        calcTokens()
    }
    
    func calcTokens() {
        var calcAmounts = 0
        
        if let amountString = amountTextField.text, let amount = Int(amountString) {
            viewModel?.updateData(amount: Double(amount))

            calcAmounts = amount * 3
            calcAmountsLabel.text = NSLocalizedString("You get", comment: "") + " \(calcAmounts) T"
        }
        
        calcAmountsLabel.text = NSLocalizedString("You get", comment: "") + " \(calcAmounts) T"
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        amountTextField.resignFirstResponder()
    }
    
    @IBAction func dismissDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}

extension AddFundsViewController: UITextFieldDelegate {
    
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
