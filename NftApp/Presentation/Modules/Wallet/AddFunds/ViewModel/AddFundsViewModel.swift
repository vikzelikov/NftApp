//
//  AddFundsViewModel.swift
//  NftApp
//
//  Created by Yegor on 01.08.2021.
//

import Foundation
import PassKit
import TinkoffASDKUI
import TinkoffASDKCore

protocol AddFundsViewModel : BaseViewModel {
        
    var isSuccess: Observable<Bool> { get }
    
    func applePayButtonDidTap(completion: @escaping (AcquiringUISDK, AcquiringUISDK.ApplePayConfiguration, PaymentInitData) -> Void)
    
    func updateData(amount: Double)
    
}

class AddFundsViewModelImpl: AddFundsViewModel {
    private let walletUseCase: WalletUseCase
    
    private var addFundsRequest = AddFundsRequest() {
        didSet {
            amount = addFundsRequest.amount
        }
    }
    
    private var amount: Double = 0.0
    private var tinkoffSdk: AcquiringUISDK? = nil
    private lazy var paymentApplePayConfiguration = AcquiringUISDK.ApplePayConfiguration()

    var isLoading: Observable<Bool> = Observable(false)
    var isSuccess: Observable<Bool> = Observable(false)
    var errorMessage: Observable<String?> = Observable(nil)
    
    init() {
        walletUseCase = WalletUseCaseImpl()
        
        let credentional = AcquiringSdkCredential(terminalKey: Constant.TERMINAL_KEY_T, publicKey: Constant.PUBLIC_KEY_T)
        let acquiringSDKConfiguration = AcquiringSdkConfiguration(credential: credentional, server: .prod)
        tinkoffSdk = try? AcquiringUISDK.init(configuration: acquiringSDKConfiguration)
        paymentApplePayConfiguration.merchantIdentifier = Constant.MERCHANT_ID
    }
    
    func updateData(amount: Double) {
        addFundsRequest.amount = amount
    }
    
    private func addFunds() {
//        self.isLoading.value = true
//        
//        walletUseCase.addFunds(request: addFundsRequest, completion: { result in
//            switch result {
//            case .success(let isSuccess):
//                NSLog("OK Signup: \(isSuccess)")
//                self.isSuccess.value = true
//            case .failure(let error):
//                self.isSuccess.value = false
//                NSLog("ERROR: \(String(describing: SignupViewModel.self)) \(error)")
//                if let error = error as? ErrorMessage, let code = error.code {
//                    switch code {
//                    case let c where c >= HttpCode.internalServerError:
//                        self.errorMessage.value = NSLocalizedString("defaultError", comment: "")
//                    case HttpCode.badRequest:
//                        let message = error.errorDTO?.message
//                        self.errorMessage.value = message
//                    default:
//                        self.errorMessage.value = NSLocalizedString("defaultError", comment: "")
//                    }
//                } else {
//                    self.errorMessage.value = NSLocalizedString("defaultError", comment: "")
//                }
//
//            }
//
//            self.isLoading.value = false
//        })
    }
    
    private func checkData() {
        if amount <= 1 || amount > 9999  {
            errorMessage.value = "Please provide correct amount"
            isSuccess.value = false
            return
        }

        addFunds()
    }
    
    func applePayButtonDidTap(completion: @escaping (AcquiringUISDK, AcquiringUISDK.ApplePayConfiguration, PaymentInitData) -> Void) {
        checkData()
        
        if let sdk = tinkoffSdk {
            let paymentData = createPaymentData()
            
            completion(sdk, paymentApplePayConfiguration, paymentData)
        }
    }
    
    private func createPaymentData() -> PaymentInitData {
        let amount = NSDecimalNumber(value: amount)
        let randomOrderId = String(Int64(arc4random())) + "id\(Constant.USER_ID)"
        var paymentData = PaymentInitData(amount: amount, orderId: randomOrderId, customerKey: "1")
        paymentData.description = "Yup NFT"
        paymentData.paymentFormData = ["LOL": "456", "TEST": "dhdrthdr"]
//        paymentData.addPaymentData(["userid": "456", "567567": "dhdrthdr"])

        var receiptItems: [Item] = []
        let item: Item = Item(amount: amount.int64Value * 100,
                              price: amount.int64Value * 100,
                              name: "Purchase of tokens",
                              tax: .vat10)
        
       receiptItems.append(item)
                   
       paymentData.receipt = Receipt(shopCode: nil,
                                      email: "example@example.com",
                                      taxation: .osn,
                                      phone: nil,
                                      items: receiptItems,
                                      agentData: nil,
                                      supplierInfo: nil,
                                      customer: "1234",
                                      customerInn: nil)

        return paymentData
    }
    
}
