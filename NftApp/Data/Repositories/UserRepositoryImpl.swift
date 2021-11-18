//
//  UserRepositoryImpl.swift
//  NftApp
//
//  Created by Yegor on 20.08.2021.
//

import Foundation
import Alamofire

class UserRepositoryImpl: UserRepository {

    func getUser(userId: Int, completion: @escaping (Result<GetUserResponseDTO, Error>) -> Void) {
        let endpoint = UserEndpoints.getUserEndpoint(userId: userId)

        AF.request(endpoint.url, method: endpoint.method, parameters: endpoint.data, headers: endpoint.headers) { $0.timeoutInterval = NetworkHelper.TIMEOUT } .validate().responseString { response in
            
            NetworkHelper.validateResponse(response: response, completion: completion)
            
        }
    }
    
    func updateUser(request: User, completion: @escaping (Result<UpdateUserResponseDTO, Error>) -> Void) {
        let endpoint = UserEndpoints.updateUserEndpoint(request: request)

        AF.request(endpoint.url, method: endpoint.method, parameters: endpoint.data, headers: endpoint.headers).validate().responseString { response in
            
            NetworkHelper.validateResponse(response: response, completion: completion)
            
        }
    }
    
    func updateAvatar(request: UpdateAvatarRequest, completion: @escaping (Result<Bool, Error>) -> Void) {
        let endpoint = UserEndpoints.updateAvatarEndpoint()
        
        guard let imageData = request.image.jpegData(compressionQuality: 0.1) else { return }
        
        AF.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
        }, to: endpoint.url, method: endpoint.method, headers: endpoint.headers, interceptor: nil, fileManager: .default).responseString { response in

            NetworkHelper.validateBoolResponse(response: response, completion: completion)
            
        }
    }
    
    func getInfluencers(completion: @escaping (Result<GetInfluencersResponseDTO, Error>) -> Void) {
        let endpoint = UserEndpoints.getInfluencersEndpoint()

        AF.request(endpoint.url, method: endpoint.method, parameters: endpoint.data, headers: endpoint.headers).validate().responseString { response in
           
            NetworkHelper.validateResponse(response: response, completion: completion)
            
        }
    }
    
    func getInfluencer(influencerId: Int, completion: @escaping (Result<InfluencerDTO, Error>) -> Void) {
        let endpoint = UserEndpoints.getInfluencerEndpoint(influencerId: influencerId)

        AF.request(endpoint.url, method: endpoint.method, parameters: endpoint.data, headers: endpoint.headers).validate().responseString { response in
           
            NetworkHelper.validateResponse(response: response, completion: completion)
            
        }
    }
    
    func getNfts(request: GetNftsRequest, completion: @escaping (Result<GetNftsResponseDTO, Error>) -> Void) {
        let endpoint = UserEndpoints.getNftsEndpoint(request: request)
        
        AF.request(endpoint.url, method: endpoint.method, parameters: endpoint.data, headers: endpoint.headers).validate().responseString { response in
           
            NetworkHelper.validateResponse(response: response, completion: completion)
            
        }
    }
    
    func getFollowers(request: FollowsRequest, completion: @escaping (Result<GetUsersResponseDTO, Error>) -> Void) {
        let endpoint = FollowsEndpoints.getFollowersEndpoint(request: request)
        
        AF.request(endpoint.url, method: endpoint.method, parameters: endpoint.data, headers: endpoint.headers).validate().responseString { response in
           
            NetworkHelper.validateResponse(response: response, completion: completion)
            
        }
    }
    
    func getFollowing(request: FollowsRequest, completion: @escaping (Result<GetUsersResponseDTO, Error>) -> Void) {
        let endpoint = FollowsEndpoints.getFollowingEndpoint(request: request)

        AF.request(endpoint.url, method: endpoint.method, parameters: endpoint.data, headers: endpoint.headers).validate().responseString { response in
           
            NetworkHelper.validateResponse(response: response, completion: completion)
            
        }
    }
    
    func follow(userId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        let endpoint = FollowsEndpoints.followEndpoint(userId: userId)

        AF.request(endpoint.url, method: endpoint.method, parameters: endpoint.data, headers: endpoint.headers).validate().responseString { response in
           
            NetworkHelper.validateBoolResponse(response: response, completion: completion)

        }
    }
    
    func unfollow(userId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        let endpoint = FollowsEndpoints.unfollowEndpoint(userId: userId)
        
        AF.request(endpoint.url, method: endpoint.method, parameters: endpoint.data, headers: endpoint.headers).validate().responseString { response in
           
            NetworkHelper.validateBoolResponse(response: response, completion: completion)
            
        }
    }
    
    func checkFollow(userId: Int, completion: @escaping (Result<CheckFollowResponseDTO, Error>) -> Void) {
        let endpoint = FollowsEndpoints.checkFollowEndpoint(userId: userId)
        
        AF.request(endpoint.url, method: endpoint.method, parameters: endpoint.data, headers: endpoint.headers).validate().responseString { response in
           
            NetworkHelper.validateResponse(response: response, completion: completion)
            
        }
    }
    
}
