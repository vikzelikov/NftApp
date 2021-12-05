//
//  WalletRepositoryImpl.swift
//  NftApp
//
//  Created by Yegor on 26.08.2021.
//

import Foundation

class WalletRepositoryImpl: WalletRepository {
    
    func addFunds(request: AddFundsRequest, completion: @escaping (Result<CommonDTO, Error>) -> Void) {
        let endpoint = WalletEndpoints.addFundsEndpoint(request: request)

        NetworkHelper.request(endpoint: endpoint, completion: completion)
    }
    
    func withdrawFunds(request: WithdrawFundsRequest, completion: @escaping (Result<WithdrawFundsResponseDTO, Error>) -> Void) {
        let endpoint = WalletEndpoints.withdrawFundsEndpoint(request: request)

        NetworkHelper.request(endpoint: endpoint, completion: completion)
    }
    
    func getTransactions(request: GetTransactionsRequest, completion: @escaping (Result<GetTransactionsResponseDTO, Error>) -> Void) {
        let endpoint = WalletEndpoints.getTransactionsEndpoint(request: request)

        NetworkHelper.request(endpoint: endpoint, completion: completion)
    }
    
}
