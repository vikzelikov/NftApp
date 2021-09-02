//
//  AddFundsViewController.swift
//  NftApp
//
//  Created by Yegor on 01.08.2021.
//

import UIKit
import PassKit

class AddFundsViewController: UIViewController {

    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var applePayButton: UIButton!
    @IBOutlet weak var calcAmountsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupStyle()
        
        amountTextField.addTarget(self, action: #selector(amountFieldDidChange), for: .editingChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func setupStyle() {
        applePayButton.applyButtonEffects()
        applePayButton.adjustsImageWhenHighlighted = false
        
        amountTextField.delegate = self
    }
    
    @IBAction func applePayButtonDidTap(_ sender: Any) {
        startApplePay()
    }
    
    @objc func amountFieldDidChange(_ sender: Any) {
        var calcTokens = 0
        
        if let amountString = amountTextField.text, let amount = Int(amountString) {            
            calcTokens = amount * 3
            calcAmountsLabel.text = NSLocalizedString("You get", comment: "") + " \(calcTokens) T"
        }
        
        calcAmountsLabel.text = NSLocalizedString("You get", comment: "") + " \(calcTokens) T"
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        amountTextField.resignFirstResponder()
    }
    
    @IBAction func dismissDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    



    
    
    
    
    

    func displayDefaultAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    func startApplePay() {
        let paymentItem = PKPaymentSummaryItem.init(label: "Карточка #231", amount: NSDecimalNumber(value: 23.40))
        let paymentNetworks = [PKPaymentNetwork.amex, .discover, .masterCard, .visa]
        
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
            let request = PKPaymentRequest()
            request.currencyCode = "USD"
            request.countryCode = "US"
            request.merchantIdentifier = Constant.MERCHANT_ID
            request.merchantCapabilities = PKMerchantCapability.capability3DS
            request.supportedNetworks = paymentNetworks
            request.paymentSummaryItems = [paymentItem]
            
            guard let paymentVC = PKPaymentAuthorizationViewController(paymentRequest: request) else {
                displayDefaultAlert(title: "Error", message: "Unable to present Apple Pay authorization.")
                return
            }
            
            paymentVC.delegate = self
            self.present(paymentVC, animated: true, completion: nil)
        }
    }

}

extension AddFundsViewController: PKPaymentAuthorizationViewControllerDelegate {
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        dismiss(animated: true, completion: nil)
        displayDefaultAlert(title: "Success!", message: "The Apple Pay transaction was complete.")
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
