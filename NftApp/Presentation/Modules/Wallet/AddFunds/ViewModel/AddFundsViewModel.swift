//
//  AddFundsViewModel.swift
//  NftApp
//
//  Created by Yegor on 01.08.2021.
//

import Foundation
import StoreKit
import CommonCrypto

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
                    for (index, product) in ProductsDB.shared.items.enumerated() {
                        self.products.value.append(InAppPurchase(
                            id: index,
                            price: product.price,
                            priceLocale: product.priceLocale,
                            productIdentifier: product.productIdentifier,
                            isSelected: index == 0 ? true : false
                        ))
                    }
                    
                    self.selectedProduct = self.products.value.first
                    
                } else {
                    self.errorMessage.value = NSLocalizedString("defaultError", comment: "")
                }

                self.isLoading.value = false
            }
        })
    }
    
    func productDidTap(index: Int) {
        if products.value.indices.contains(index) {
            
            for (id, t) in products.value.enumerated() {
                if t.id == index {
                    products.value[index].isSelected = true
                } else {
                    products.value[id].isSelected = false
                }
            }
            
            selectedProduct = products.value[index]
        }
    }
    
    func nextDidTap(completion: @escaping (Bool) -> Void) {
        guard let index = selectedProduct?.id else {
            completion(false)
            return
        }
        
        if ProductsDB.shared.items.indices.contains(index) {
            IAPManager.shared.purchase(product: ProductsDB.shared.items[index], completion: { isSuccessPurchase, prodIdentifier in
                if let productIdentifier = prodIdentifier {
                    for product in self.products.value {
                        if product.productIdentifier == productIdentifier {
                            if isSuccessPurchase {
                                let orderId = "\(Date().millisecondsSince1970)"
                                let amount = "\(product.price)"
                                let locale = "\(product.priceLocale)"
                                let concatData = orderId + "\(Constant.USER_ID)" + productIdentifier + amount + locale + Constant.IAP_SECRET
                                let concatHash = self.sha256(concatData)
                                                                
                                let request = AddFundsRequest(orderId: orderId, productIdentifier: productIdentifier, amount: amount, locale: locale, concatHash: concatHash)
                                
                                self.addFunds(request: request) { isSuccessRequest in
                                    completion(isSuccessRequest)
                                }
                            } else {
                                completion(false)
                            }
                            
                            break
                        }
                    }
                } else {
                    completion(false)
                }
            })
        }
    }

    private func addFunds(request: AddFundsRequest, completion: @escaping (Bool) -> Void) {        
        walletUseCase.addFunds(request: request, completion: { result in
            switch result {
            case .success:
                completion(true)
                
            case .failure:
                self.errorMessage.value = NSLocalizedString("defaultError", comment: "")
                completion(false)
            }
        })
    }
    
    private func sha256(_ data: Data) -> Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
        }
        return Data(hash)
    }

    private func sha256(_ str: String) -> String {
        guard let data = str.data(using: .utf8) else { return "" }
        let shaData = sha256(data)
        let hashString = shaData.compactMap { String(format: "%02x", $0) }.joined()
        return hashString
    }

}

class IAPManager: NSObject {
    
    static let shared = IAPManager()
    
    private var completionPurchase: ((Bool, String?) -> Void)?
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

    func purchase(product: SKProduct, completion: ((Bool, String?) -> Void)?) {
        self.completionPurchase = completion
        
        if IAPManager.shared.canMakePayments() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        } else {
            completion?(false, nil)
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
                completionPurchase?(false, nil)
                break
                
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                completionPurchase?(true, transaction.payment.productIdentifier)
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
    let price: NSDecimalNumber
    let priceLocale: Locale
    let productIdentifier: String
    var isSelected: Bool
}
