//
//  AddFundsViewController.swift
//  NftApp
//
//  Created by Yegor on 01.08.2021.
//

import UIKit
import PassKit
import TinkoffASDKUI
import TinkoffASDKCore

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
        startApplePay()
    }
    
    @objc func amountFieldDidChange(_ sender: Any) {
        var calcAmounts = 0
        
        if let amountString = amountTextField.text, let amount = Int(amountString) {
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

    func displayDefaultAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    func startApplePay() {

        let credentional = AcquiringSdkCredential(terminalKey: "1632305973794DEMO", publicKey: "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAv5yse9ka3ZQE0feuGtemYv3IqOlLck8zHUM7lTr0za6lXTszRSXfUO7jMb+L5C7e2QNFs+7sIX2OQJ6a+HG8kr+jwJ4tS3cVsWtd9NXpsU40PE4MeNr5RqiNXjcDxA+L4OsEm/BlyFOEOh2epGyYUd5/iO3OiQFRNicomT2saQYAeqIwuELPs1XpLk9HLx5qPbm8fRrQhjeUD5TLO8b+4yCnObe8vy/BMUwBfq+ieWADIjwWCMp2KTpMGLz48qnaD9kdrYJ0iyHqzb2mkDhdIzkim24A3lWoYitJCBrrB2xM05sm9+OdCI1f7nPNJbl5URHobSwR94IRGT7CJcUjvwIDAQAB")
        // конфигурация для старта sdk
        let acquiringSDKConfiguration = AcquiringSdkConfiguration(credential: credentional)
        // включаем логи, результаты работы запросов пишутся в консоль
        acquiringSDKConfiguration.logger = AcquiringLoggerDefault()
        
        let paymentInitData = PaymentInitData(amount: 12.12, orderId: "qwef", customerKey: "werfwerf")
        print("1")
        if let sdk = try? AcquiringUISDK.init(configuration: acquiringSDKConfiguration) {
            print("2")
            // SDK проинициализировалось, можно приступать к работе
            sdk.presentPaymentApplePay(on: self, paymentData: paymentInitData, viewConfiguration: AcquiringViewConfiguration.init(), paymentConfiguration: AcquiringUISDK.ApplePayConfiguration.init(), completionHandler: { result in
                print("3")
            })
            
        }
        
        
//        AcquiringUISDK.presentPaymentApplePay(on presentingViewController: UIViewController,
//                                            paymentData data: PaymentInitData,
//                                            viewConfiguration: AcquiringViewConfigration,
//                                            paymentConfiguration: AcquiringUISDK.ApplePayConfiguration,
//                                            completionHandler: @escaping PaymentCompletionHandler)


        
//        if let amountString = amountTextField.text, let amount = Int(amountString) {
//            let paymentItem = PKPaymentSummaryItem.init(label: "Пополнение баланса", amount: NSDecimalNumber(value: amount))
//            let paymentNetworks = [PKPaymentNetwork.amex, .discover, .masterCard, .visa]
//
//            if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
//                let request = PKPaymentRequest()
//                request.currencyCode = "RUB"
//                request.countryCode = "RU"
//                request.merchantIdentifier = Constant.MERCHANT_ID
//                request.merchantCapabilities = PKMerchantCapability.capability3DS
//                request.supportedNetworks = paymentNetworks
//                request.paymentSummaryItems = [paymentItem]
//
//                guard let paymentVC = PKPaymentAuthorizationViewController(paymentRequest: request) else {
//                    displayDefaultAlert(title: "Error", message: "Unable to present Apple Pay authorization.")
//                    return
//                }
//
//                paymentVC.delegate = self
//                self.present(paymentVC, animated: true, completion: nil)
//            }
//        }
    }

}
struct MyAwesomeStyle: Style {
    var bigButtonStyle: ButtonStyle
    

}



extension AddFundsViewController: PKPaymentAuthorizationViewControllerDelegate {
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
        
//        var status: PKPaymentAuthorizationStatus = .failure
//
//        guard let vm = viewModel else { return }
//        vm.isSuccess.bind { isSuccess in
//            if isSuccess { status = .success }
//
//            completion(PKPaymentAuthorizationResult(status: status, errors: nil))
//        }
//
//        if let amountString = amountTextField.text, let amount = Int(amountString) {
//            viewModel?.updateCredentials(amount: Double(amount), paymentData: payment)
//        }
//
//        viewModel?.inputData()
        
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

