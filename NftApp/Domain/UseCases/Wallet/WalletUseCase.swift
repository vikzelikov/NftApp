//
//  WalletUseCase.swift
//  NftApp
//
//  Created by Yegor on 26.08.2021.
//

import Foundation
import PassKit

protocol WalletUseCase {
    
    func addFunds(request: AddFundsRequest, completion: @escaping (Result<Bool, Error>) -> Void)
    
    func withdrawFunds(request: WithdrawFundsRequest, completion: @escaping (Result<Bool, Error>) -> Void)
        
}

final class WalletUseCaseImpl: WalletUseCase {
    
    private let repository: WalletRepository?
    
    init() {
        self.repository = WalletRepositoryImpl()
    }
    
    func addFunds(request: AddFundsRequest, completion: @escaping (Result<Bool, Error>) -> Void) {

        repository?.addFunds(request: request, completion: { result in
            switch result {
                case .success(let resp) : do {
                    print("success \(resp)")
                }
                
                case .failure(let error) : do {
                    completion(.failure(error))
                }
            }
        })
    }
    
    func withdrawFunds(request: WithdrawFundsRequest, completion: @escaping (Result<Bool, Error>) -> Void) {

        repository?.withdrawFunds(request: request, completion: { result in
            switch result {
                case .success(let resp) : do {
                    print("success \(resp)")
                }
                
                case .failure(let error) : do {
                    completion(.failure(error))
                }
            }
        })
    }
    
}

struct AddFundsRequest {
    var amount: Double = 0.0
    var paymentData: PKPayment = PKPayment()
}

struct WithdrawFundsRequest {
    var amount: Double = 0
}
