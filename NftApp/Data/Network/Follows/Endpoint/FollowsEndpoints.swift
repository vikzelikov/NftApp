//
//  FollowsEndpoints.swift
//  NftApp
//
//  Created by Yegor on 25.09.2021.
//

import Foundation

struct FollowsEndpoints {
    
    static func getFollowersEndpoint(request: FollowsRequest) -> Endpoint {
        let requestDTO = GetFollowsRequestDTO(
            page: request.page
        ).parameters
        
        let url = Constant.BASE_URL + "api/users/\(request.userId)/followers"
        
        return Endpoint(url: url, method: .get, urlParameters: requestDTO)
    }
    
    static func getFollowingEndpoint(request: FollowsRequest) -> Endpoint {
        let requestDTO = GetFollowsRequestDTO(
            page: request.page
        ).parameters
        
        let url = Constant.BASE_URL + "api/users/\(request.userId)/following"

        return Endpoint(url: url, method: .get, urlParameters: requestDTO)
    }
    
    static func followEndpoint(userId: Int) -> Endpoint {
        let url = Constant.BASE_URL + "api/users/\(userId)/follow"
        
        return Endpoint(url: url, method: .post)
    }
    
    static func unfollowEndpoint(userId: Int) -> Endpoint {
        let url = Constant.BASE_URL + "api/users/\(userId)/unfollow"
        
        return Endpoint(url: url, method: .delete)
    }
    
    static func checkFollowEndpoint(userId: Int) -> Endpoint {
        let url = Constant.BASE_URL + "api/users/\(userId)/checkFollow"
        
        return Endpoint(url: url, method: .get)
    }
    
}
