//
//  WalletUseCase.swift
//  NftApp
//
//  Created by Yegor on 26.08.2021.
//

import Foundation

protocol WalletUseCase {
    
    func addFunds(request: AddFundsRequest, completion: @escaping (Result<Bool, Error>) -> Void)
        
    func withdrawFunds(request: WithdrawFundsRequest, completion: @escaping (Result<Bool, Error>) -> Void)
    
    func getTransactions(request: GetTransactionsRequest, completion: @escaping (Result<[Transaction], Error>) -> Void)
        
}

final class WalletUseCaseImpl: WalletUseCase {
    
    private let repository: WalletRepository
    
    init(repository: WalletRepository = DIContainer.shared.resolve(type: WalletRepository.self)) {
        self.repository = repository
    }
    
    func addFunds(request: AddFundsRequest, completion: @escaping (Result<Bool, Error>) -> Void) {
        repository.addFunds(request: request) { result in
            switch result {
            case .success : do {
                completion(.success(true))
            }
            
            case .failure(let error) : do {
                completion(.failure(error))
            }
            }
        }
    }
    
    func withdrawFunds(request: WithdrawFundsRequest, completion: @escaping (Result<Bool, Error>) -> Void) {
        repository.withdrawFunds(request: request) { result in
            switch result {
            case .success(let resp) : do {
                print("success \(resp)")
            }
            
            case .failure(let error) : do {
                completion(.failure(error))
            }
            }
        }
    }
    
    func getTransactions(
        request: GetTransactionsRequest,
        completion: @escaping (Result<[Transaction], Error>) -> Void
    ) {
        repository.getTransactions(request: request) { result in
            switch result {
            case .success(let resp) : do {
                let transactions = resp.rows.map(Transaction.init)

                completion(.success(transactions))
            }
            
            case .failure(let error) : do {
                completion(.failure(error))
            }
            }
        }
    }
    
}

struct AddFundsRequest {
    
    var orderId: String
    var productIdentifier: String
    var amount: String
    var locale: String
    var concatHash: String
    
}

struct WithdrawFundsRequest {
    
    var amount: Double = 0
    
}

struct GetTransactionsRequest {
    
    var page: Int = 0
    
}
