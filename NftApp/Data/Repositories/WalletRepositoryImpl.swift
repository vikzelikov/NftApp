//
//  WalletRepositoryImpl.swift
//  NftApp
//
//  Created by Yegor on 26.08.2021.
//

import Foundation
import Alamofire

class WalletRepositoryImpl: WalletRepository {
    
    func addFunds(request: AddFundsRequest, completion: @escaping (Result<AddFundsResponseDTO, Error>) -> Void) {

        let endpoint = WalletEndpoints.addFundsEndpoint(request: request)
        
        guard let url = endpoint.url else {
            completion(.failure(ErrorMessage(errorType: .cancelled, errorDTO: nil)))
            return
        }
        
        AF.request(url, method: endpoint.method, parameters: endpoint.data, headers: endpoint.headers).validate().responseString { response in
            
            NetworkHelper.validateResponse(response: response, completion: completion)
            
        }
    }
    
    func withdrawFunds(request: WithdrawFundsRequest, completion: @escaping (Result<WithdrawFundsResponseDTO, Error>) -> Void) {

        let endpoint = WalletEndpoints.withdrawFundsEndpoint(request: request)
        
        guard let url = endpoint.url else {
            completion(.failure(ErrorMessage(errorType: .cancelled, errorDTO: nil)))
            return
        }
        
        AF.request(url, method: endpoint.method, parameters: endpoint.data, headers: endpoint.headers).validate().responseString { response in
            
            NetworkHelper.validateResponse(response: response, completion: completion)
            
        }
    }
    
}
