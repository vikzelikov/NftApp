//
//  WalletRepositoryImpl.swift
//  NftApp
//
//  Created by Yegor on 26.08.2021.
//

import Foundation
import Alamofire

class WalletRepositoryImpl: WalletRepository {
    
    func withdrawFunds(request: WithdrawFundsRequest, completion: @escaping (Result<WithdrawFundsResponseDTO, Error>) -> Void) {
        let endpoint = WalletEndpoints.withdrawFundsEndpoint(request: request)

        AF.request(endpoint.url, method: endpoint.method, parameters: endpoint.data, headers: endpoint.headers).validate().responseString { response in
            
            NetworkHelper.validateResponse(response: response, completion: completion)
            
        }
    }
    
    func getTransactions(request: GetTransactionsRequest, completion: @escaping (Result<GetTransactionsResponseDTO, Error>) -> Void) {
        let endpoint = WalletEndpoints.getTransactionsEndpoint(request: request)

        AF.request(endpoint.url, method: endpoint.method, parameters: endpoint.data, headers: endpoint.headers).validate().responseString { response in
            
            NetworkHelper.validateResponse(response: response, completion: completion)
            
        }
    }
    
}
