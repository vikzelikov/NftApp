//
//  FollowsEndpoints.swift
//  NftApp
//
//  Created by Yegor on 25.09.2021.
//

import Foundation
import Alamofire

struct FollowsEndpoints {
    
    static func getFollowersEndpoint(request: FollowsRequest) -> Endpoint {
        let requestDTO = GetFollowsRequestDTO (
            page: request.page
        ).parameters
        
        let headers: HTTPHeaders = NetworkHelper.getHeaders()
        let url = URL(string: Constant.BASE_URL + "api/users/\(request.userId)/followers")
        
        return Endpoint(url: url, method: .get, headers: headers, data: requestDTO)
    }
    
    static func getFollowingsEndpoint(request: FollowsRequest) -> Endpoint {
        let requestDTO = GetFollowsRequestDTO (
            page: request.page
        ).parameters
        
        let headers: HTTPHeaders = NetworkHelper.getHeaders()
        let url = URL(string: Constant.BASE_URL + "api/users/\(request.userId)/following")

        return Endpoint(url: url, method: .get, headers: headers, data: requestDTO)
    }
    
    static func followEndpoint(userId: Int) -> Endpoint {
        let headers: HTTPHeaders = NetworkHelper.getHeaders()
        let url = URL(string: Constant.BASE_URL + "api/users/\(userId)/follow")
        
        return Endpoint(url: url, method: .post, headers: headers, data: nil)
    }
    
    static func unfollowEndpoint(userId: Int) -> Endpoint {
        let headers: HTTPHeaders = NetworkHelper.getHeaders()
        let url = URL(string: Constant.BASE_URL + "api/users/\(userId)/unfollow")
        
        return Endpoint(url: url, method: .delete, headers: headers, data: nil)
    }
    
}
