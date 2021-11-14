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
        let url = Constant.BASE_URL + "api/users/\(userId)"
        
        return Endpoint(url: url, method: .get, headers: headers, data: nil)
    }
    
    static func updateUserEndpoint(request: User) -> Endpoint {
        var requestDTO = UpdateUserRequestDTO().parameters
        
        if request.login != nil { requestDTO["login"] = request.login }
        if request.email != nil { requestDTO["email"] = request.email }
        if request.oldPassword != nil { requestDTO["oldPassword"] = request.oldPassword }
        if request.newPassword != nil { requestDTO["newPassword"] = request.newPassword }
        
        let headers: HTTPHeaders = NetworkHelper.getHeaders()
        let url = Constant.BASE_URL + "api/users/\(Constant.USER_ID)"
        
        return Endpoint(url: url, method: .put, headers: headers, data: requestDTO)
    }
    
    static func updateAvatarEndpoint() -> Endpoint {
        let headers: HTTPHeaders = NetworkHelper.getHeaders()
        let url = Constant.BASE_URL + "api/users/\(Constant.USER_ID)/avatar"
        
        return Endpoint(url: url, method: .put, headers: headers, data: nil)
    }
    
    static func getInfluencersEndpoint() -> Endpoint {
        let headers: HTTPHeaders = NetworkHelper.getHeaders()
        let url = Constant.BASE_URL + "api/influencers"
        
        return Endpoint(url: url, method: .get, headers: headers, data: nil)
    }
    
    static func getNftsEndpoint(request: GetNftsRequest) -> Endpoint {
        let requestDTO = GetNftsRequestDTO (
            page: request.page
        ).parameters
        
        let headers: HTTPHeaders = NetworkHelper.getHeaders()
        let url = Constant.BASE_URL + "api/users/\(request.userId)/nfts"
        
        return Endpoint(url: url, method: .get, headers: headers, data: requestDTO)
    }
    
}
