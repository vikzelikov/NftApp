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
        let url = URL(string: Constant.BASE_URL + "api/users/\(userId)")
        
        return Endpoint(url: url, method: .get, headers: headers, data: nil)
    }
    
    static func updateUserEndpoint(request: User) -> Endpoint {
        let requestDTO = UpdateUserRequestDTO (
            email: request.email
        ).parameters
        
        let headers: HTTPHeaders = NetworkHelper.getHeaders()
        let url = URL(string: Constant.BASE_URL + "api/users/\(Constant.USER_ID)")
        
        return Endpoint(url: url, method: .put, headers: headers, data: requestDTO)
    }
    
    static func getNftsEndpoint(request: GetNftsRequest) -> Endpoint {
        let requestDTO = GetNftsRequestDTO (
            page: request.page
        ).parameters
        
        let headers: HTTPHeaders = NetworkHelper.getHeaders()
        let url = URL(string: Constant.BASE_URL + "api/users/\(Constant.USER_ID)/nfts")
        
        return Endpoint(url: url, method: .get, headers: headers, data: requestDTO)
    }
    
}
