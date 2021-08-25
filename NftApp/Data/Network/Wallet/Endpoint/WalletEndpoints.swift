//
//  WalletEndpoints.swift
//  NftApp
//
//  Created by Yegor on 26.08.2021.
//

import Foundation
import Alamofire

struct WalletEndpoints {
    
    static func addFundsEndpoint(request: AddFundsRequest) -> Endpoint {
        let requestDTO = AddFundsRequestDTO (
            amount: request.amount
        ).parameters
        
        let headers: HTTPHeaders = NetworkHelper.getHeaders()
        let url = URL(string: Constant.BASE_URL + "/api")
        
        return Endpoint(url: url, method: .post, headers: headers, data: requestDTO)
    }
    
    static func withdrawFundsEndpoint(request: WithdrawFundsRequest) -> Endpoint {
        let requestDTO = WithdrawFundsRequestDTO (
            amount: request.amount
        ).parameters
        
        let headers: HTTPHeaders = NetworkHelper.getHeaders()
        let url = URL(string: Constant.BASE_URL + "/api")
        
        return Endpoint(url: url, method: .post, headers: headers, data: requestDTO)
    }
    
}
