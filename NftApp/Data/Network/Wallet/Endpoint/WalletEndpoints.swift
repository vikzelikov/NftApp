//
//  WalletEndpoints.swift
//  NftApp
//
//  Created by Yegor on 26.08.2021.
//

import Foundation
import Alamofire

struct WalletEndpoints {
    
    static func withdrawFundsEndpoint(request: WithdrawFundsRequest) -> Endpoint {
        let requestDTO = WithdrawFundsRequestDTO (
            amount: request.amount
        ).parameters
        
        let headers: HTTPHeaders = NetworkHelper.getHeaders()
        let url = Constant.BASE_URL + "api"
        
        return Endpoint(url: url, method: .post, headers: headers, data: requestDTO)
    }
    
    static func getTransactionsEndpoint(request: GetTransactionsRequest) -> Endpoint {
        let requestDTO = GetTransactionsRequestDTO (
            page: request.page
        ).parameters
        
        let headers: HTTPHeaders = NetworkHelper.getHeaders()
        let url = Constant.BASE_URL + "api/users/\(Constant.USER_ID)/transactions"
        
        return Endpoint(url: url, method: .get, headers: headers, data: requestDTO)
    }
    
}
