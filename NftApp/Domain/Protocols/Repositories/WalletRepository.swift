//
//  WalletRepository.swift
//  NftApp
//
//  Created by Yegor on 26.08.2021.
//

import Foundation

protocol WalletRepository {
        
    func withdrawFunds(request: WithdrawFundsRequest, completion: @escaping (Result<WithdrawFundsResponseDTO, Error>) -> Void)
    
    func getTransactions(request: GetTransactionsRequest, completion: @escaping (Result<GetTransactionsResponseDTO, Error>) -> Void)
            
}
