//
//  WalletRepositoryImpl.swift
//  NftApp
//
//  Created by Yegor on 26.08.2021.
//

import Foundation
import Alamofire
import SwiftyJSON

class WalletRepositoryImpl: WalletRepository {
    
    func addFunds(request: AddFundsRequest, completion: @escaping (Result<AddFundsResponseDTO, Error>) -> Void) {

        
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
