//
//  WalletUseCase.swift
//  NftApp
//
//  Created by Yegor on 26.08.2021.
//

import Foundation

protocol WalletUseCase {
        
    func withdrawFunds(request: WithdrawFundsRequest, completion: @escaping (Result<Bool, Error>) -> Void)
    
    func getTransactions(request: GetTransactionsRequest, completion: @escaping (Result<[Transaction], Error>) -> Void)
        
}

final class WalletUseCaseImpl: WalletUseCase {
    
    private let repository: WalletRepository?
    
    init() {
        self.repository = WalletRepositoryImpl()
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
    
    func getTransactions(request: GetTransactionsRequest, completion: @escaping (Result<[Transaction], Error>) -> Void) {
        repository?.getTransactions(request: request, completion: { result in
            switch result {
                case .success(let resp) : do {
                    let transactions = resp.rows.map{Transaction(id: $0.id,
                                                                 fromUserId: $0.fromUserId,
                                                                 toUserId: $0.toUserId,
                                                                 type: $0.type,
                                                                 amount: $0.amount,
                                                                 destination: $0.destination,
                                                                 blockchainTransactionId: $0.blockchainTransactionId,
                                                                 nftId: $0.nftId,
                                                                 date: $0.createdAt)}
                    
                    completion(.success(transactions))
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
}

struct WithdrawFundsRequest {
    var amount: Double = 0
}

struct GetTransactionsRequest {
    var page: Int = 0
}
