//
//  AddFundsViewModel.swift
//  NftApp
//
//  Created by Yegor on 01.08.2021.
//

import Foundation
import StoreKit

protocol AddFundsViewModel : BaseViewModel {
        
    var products: Observable<[InAppPurchase]> { get }
    
    func productDidTap(index: Int)
    
    func nextDidTap(completion: @escaping (Bool) -> Void)
    
}

class AddFundsViewModelImpl: AddFundsViewModel {

    private let walletUseCase: WalletUseCase

    var isLoading: Observable<Bool> = Observable(true)
    var errorMessage: Observable<String?> = Observable(nil)
    var products: Observable<[InAppPurchase]> = Observable([])
    
    private var selectedProduct: InAppPurchase?
    
    init() {
        walletUseCase = WalletUseCaseImpl()
        
        IAPManager.shared.getProducts(completion: { result in
            DispatchQueue.main.async {
                if result {
                    self.products.value.append(InAppPurchase(id: 0, price: 99))
                    self.products.value.append(InAppPurchase(id: 1, price: 449))
                } else {
                    self.errorMessage.value = NSLocalizedString("defaultError", comment: "")
                }

                self.isLoading.value = false
            }
        })
    }
    
    func productDidTap(index: Int) {
        if products.value.indices.contains(index) {
            selectedProduct = products.value[index]
        }
    }
    
    func nextDidTap(completion: @escaping (Bool) -> Void) {
        guard let index = selectedProduct?.id else {
            completion(false)
            return
        }
        
        if ProductsDB.shared.items.indices.contains(index) {
            IAPManager.shared.purchase(product: ProductsDB.shared.items[index], completion: { result in
                
                completion(result)
                
                if result {
                    self.addFunds()
                }
            })
        }
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
    


}

class IAPManager: NSObject {
    
    static let shared = IAPManager()
    
    private var completionPurchase: ((Bool) -> Void)?
    private var completionGetProducts: ((Bool) -> Void)?
        
    private override init() {
        super.init()
    }

    func getProducts(completion: ((Bool) -> Void)?) {
        self.completionGetProducts = completion
        
        let request = SKProductsRequest(productIdentifiers: Constant.IN_APP_PRODUCTS)
        request.delegate = self
        request.start()
    }

    func purchase(product: SKProduct, completion: ((Bool) -> Void)?) {
        self.completionPurchase = completion
        
        if IAPManager.shared.canMakePayments() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        } else {
            completion?(false)
        }
    }

    func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
}

extension IAPManager: SKProductsRequestDelegate, SKRequestDelegate {

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let badProducts = response.invalidProductIdentifiers
        let goodProducts = response.products

        if !goodProducts.isEmpty {
            ProductsDB.shared.items = response.products
            completionGetProducts?(true)
        } else if !badProducts.isEmpty {
            completionGetProducts?(false)
        } else {
            completionGetProducts?(false)
        }
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        completionGetProducts?(false)
    }
  
}

extension IAPManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
                
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                completionPurchase?(false)
                break
                
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                completionPurchase?(true)
                break
                
            default: break
                
            }
        }
    }
}

final class ProductsDB: Identifiable {
    static let shared = ProductsDB()
    var items: [SKProduct] = []
}

struct InAppPurchase {
    let id: Int
    let price: Int
}
