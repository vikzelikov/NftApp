//
//  UserEndpoints.swift
//  NftApp
//
//  Created by Yegor on 20.08.2021.
//

import Foundation

struct UserEndpoints {
    
    static func getUserEndpoint(userId: Int) -> Endpoint {
        let url = Constant.BASE_URL + "api/users/\(userId)"
        
        return Endpoint(url: url, method: .get)
    }
    
    static func updateUserEndpoint(request: User) -> Endpoint {
        var requestDTO = UpdateUserRequestDTO()
        
        if request.login != nil { requestDTO.login = request.login }
        if request.email != nil { requestDTO.email = request.email }
        if request.oldPassword != nil { requestDTO.oldPassword = request.oldPassword }
        if request.newPassword != nil { requestDTO.newPassword = request.newPassword }
        if request.inviteWord != nil { requestDTO.inviteWord = request.inviteWord }

        let url = Constant.BASE_URL + "api/users/\(Constant.USER_ID)"
        
        return Endpoint(url: url, method: .put, bodyParameters: requestDTO)
    }
    
    static func updateAvatarEndpoint() -> Endpoint {
        let url = Constant.BASE_URL + "api/users/\(Constant.USER_ID)/avatar"
        
        return Endpoint(url: url, method: .put)
    }
    
    static func getInfluencersEndpoint() -> Endpoint {
        let url = Constant.BASE_URL + "api/influencers"
        
        return Endpoint(url: url, method: .get)
    }
    
    static func getInfluencerEndpoint(influencerId: Int) -> Endpoint {
        let url = Constant.BASE_URL + "api/influencers/\(influencerId)"
        
        return Endpoint(url: url, method: .get)
    }
    
    static func getNftsEndpoint(request: GetNftsRequest) -> Endpoint {
        let requestDTO = GetNftsRequestDTO(
            page: request.page,
            type: request.type == .collection ? "unhidden" : "observables"
        ).parameters
        
        let url = Constant.BASE_URL + "api/users/\(request.userId)/nfts"
        
        return Endpoint(url: url, method: .get, urlParameters: requestDTO)
    }
    
}
