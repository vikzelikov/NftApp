//
//  AuthViewController.swift
//  NftApp
//
//  Created by Yegor on 10.07.2021.
//

import UIKit
import PassKit

class AuthViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
    }
    
    func setupStyle() {
        self.navigationController?.navigationBar.isHidden = true

        loginButton.applyButtonStyle()
        loginButton.applyButtonEffects()
        
        signupButton.applyButtonEffects()
    }
    
    @IBAction func loginDidTap(_ sender: Any) {
        let homeStoryboard = UIStoryboard(name: "Authorization", bundle: nil)
        guard let vc = homeStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func signupDidTap(_ sender: Any) {
        let homeStoryboard = UIStoryboard(name: "Authorization", bundle: nil)
        guard let vc = homeStoryboard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
   
    
    
    
    
    
    
    
    
 
    func displayDefaultAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
       let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func startApplePay() {
        // Open Apple Pay purchase
        let shoe = Shoe(name: "Карточка #213", price: 0.11)
        let paymentItem = PKPaymentSummaryItem.init(label: shoe.name, amount: NSDecimalNumber(value: shoe.price))
        let paymentNetworks = [PKPaymentNetwork.amex, .discover, .masterCard, .visa]
        
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
            let request = PKPaymentRequest()
            request.currencyCode = "USD" // 1
            request.countryCode = "US" // 2
            request.merchantIdentifier = "merchant.com.nft.dev" // 3
            request.merchantCapabilities = PKMerchantCapability.capability3DS // 4
            request.supportedNetworks = paymentNetworks // 5
            request.paymentSummaryItems = [paymentItem] // 6
            
            guard let paymentVC = PKPaymentAuthorizationViewController(paymentRequest: request) else {
                displayDefaultAlert(title: "Error", message: "Unable to present Apple Pay authorization.")
                return
            }
            
            paymentVC.delegate = self
            self.present(paymentVC, animated: true, completion: nil)
        }
    }
    
}

struct Shoe {
    var name: String
    var price: Double
}

extension AuthViewController: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        dismiss(animated: true, completion: nil)
    }
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        dismiss(animated: true, completion: nil)
        displayDefaultAlert(title: "Success!", message: "The Apple Pay transaction was complete.")
    }
}
