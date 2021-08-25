//
//  UserEndpoints.swift
//  NftApp
//
//  Created by Yegor on 20.08.2021.
//

import Foundation
import Alamofire

struct UserEndpoints {
    
    static func getUserEndpoint(userId: Int) -> Endpoint {
        let headers: HTTPHeaders = NetworkHelper.getHeaders()
        let url = URL(string: Constant.BASE_URL + "/users/\(userId)")
        
        return Endpoint(url: url, method: .get, headers: headers, data: nil)
    }
    
    static func updateUserEndpoint(userId: Int, request: User) -> Endpoint {
        let requestDTO = UpdateUserRequestDTO (
            email: request.email
        ).parameters
        
        let headers: HTTPHeaders = NetworkHelper.getHeaders()
        let url = URL(string: Constant.BASE_URL + "/users/\(userId)")
        
        return Endpoint(url: url, method: .put, headers: headers, data: requestDTO)
    }
    
    static func getNftsEndpoint(userId: Int, request: GetNftsRequest) -> Endpoint {
        let requestDTO = GetNftsRequestDTO (
            page: request.page
        ).parameters
        
        let headers: HTTPHeaders = NetworkHelper.getHeaders()
        let url = URL(string: Constant.BASE_URL + "/users/\(userId)/nfts")
        
        return Endpoint(url: url, method: .put, headers: headers, data: requestDTO)
    }
    
}