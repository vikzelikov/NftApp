//
//  AddFundsViewModel.swift
//  NftApp
//
//  Created by Yegor on 01.08.2021.
//

import Foundation
import PassKit

protocol AddFundsViewModel : BaseViewModel {
    
    var isSuccess: Observable<Bool> { get }
    
    func updateCredentials(amount: Double, paymentData: PKPayment)
        
    func inputData()
    
}

class AddFundsViewModelImpl: AddFundsViewModel {
    private let walletUseCase: WalletUseCase
    
    private var addFundsRequest = AddFundsRequest() {
        didSet {
            amount = addFundsRequest.amount
            paymentData = addFundsRequest.paymentData
        }
    }
    
    private var amount: Double = 0.0
    private var paymentData: PKPayment = PKPayment()

    var isLoading: Observable<Bool> = Observable(false)
    var isSuccess: Observable<Bool> = Observable(false)
    var errorMessage: Observable<String?> = Observable(nil)
    
    init() {
        walletUseCase = WalletUseCaseImpl()
    }
    
    func updateCredentials(amount: Double, paymentData: PKPayment) {
        addFundsRequest.amount = amount
        addFundsRequest.paymentData = paymentData
    }
    
    private func addFunds() {
        self.isLoading.value = true
        
        walletUseCase.addFunds(request: addFundsRequest, completion: { result in
            switch result {
            case .success(let isSuccess):
                NSLog("OK Signup: \(isSuccess)")
                self.isSuccess.value = true
            case .failure(let error):
                self.isSuccess.value = false
                NSLog("ERROR: \(String(describing: SignupViewModel.self)) \(error)")
                if let error = error as? ErrorMessage, let code = error.code {
                    switch code {
                    case let c where c >= HttpCode.internalServerError:
                        self.errorMessage.value = NSLocalizedString("defaultError", comment: "")
                    case HttpCode.badRequest:
                        let message = error.errorDTO?.message
                        self.errorMessage.value = message
                    default:
                        self.errorMessage.value = NSLocalizedString("defaultError", comment: "")
                    }
                } else {
                    self.errorMessage.value = NSLocalizedString("defaultError", comment: "")
                }

            }

            self.isLoading.value = false
        })
    }
    
    func inputData() {
        if amount <= 0 || amount > 9999  {
            errorMessage.value = "Please provide correct amount"
            isSuccess.value = false
            return
        }

        addFunds()
    }
    
}
