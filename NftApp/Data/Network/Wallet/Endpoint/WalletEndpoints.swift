//
//  WalletEndpoints.swift
//  NftApp
//
//  Created by Yegor on 26.08.2021.
//

import Foundation

struct WalletEndpoints {
    
    static func addFundsEndpoint(request: AddFundsRequest) -> Endpoint {
        let requestDTO = AddFundsRequestDTO(
            userId: Constant.USER_ID,
            orderId: request.orderId,
            productIdentifier: request.productIdentifier,
            amount: request.amount,
            locale: request.locale,
            hash: request.concatHash
        )
        
        let url = Constant.BASE_URL + "api/wallet/addFunds"
        
        return Endpoint(url: url, method: .post, bodyParameters: requestDTO)
    }
    
    static func withdrawFundsEndpoint(request: WithdrawFundsRequest) -> Endpoint {
        let requestDTO = WithdrawFundsRequestDTO(
            amount: request.amount
        )
        
        let url = Constant.BASE_URL + "api/users/\(Constant.USER_ID)/withdraw"
        
        return Endpoint(url: url, method: .post, bodyParameters: requestDTO)
    }
    
    static func getTransactionsEndpoint(request: GetTransactionsRequest) -> Endpoint {
//        let requestDTO = GetTransactionsRequestDTO (
//            page: request.page
//        )
        
        let url = Constant.BASE_URL + "api/users/\(Constant.USER_ID)/transactions"
        
        return Endpoint(url: url, method: .get)
    }
    
}
