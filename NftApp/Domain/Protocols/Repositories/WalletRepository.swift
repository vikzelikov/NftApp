//
//  WalletRepository.swift
//  NftApp
//
//  Created by Yegor on 26.08.2021.
//

import Foundation

protocol WalletRepository {
    
    func addFunds(request: AddFundsRequest, completion: @escaping (Result<AddFundsResponseDTO, Error>) -> Void)
    
    func withdrawFunds(request: WithdrawFundsRequest, completion: @escaping (Result<WithdrawFundsResponseDTO, Error>) -> Void)
            
}
