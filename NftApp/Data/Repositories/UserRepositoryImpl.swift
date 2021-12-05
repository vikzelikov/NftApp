//
//  UserRepositoryImpl.swift
//  NftApp
//
//  Created by Yegor on 20.08.2021.
//

import Foundation

class UserRepositoryImpl: UserRepository {

    func getUser(userId: Int, completion: @escaping (Result<UserDTO, Error>) -> Void) {
        let endpoint = UserEndpoints.getUserEndpoint(userId: userId)

        NetworkHelper.request(endpoint: endpoint, completion: completion)
    }
    
    func updateUser(request: User, completion: @escaping (Result<UpdateUserResponseDTO, Error>) -> Void) {
        let endpoint = UserEndpoints.updateUserEndpoint(request: request)

        NetworkHelper.request(endpoint: endpoint, completion: completion)
    }
    
    func updateAvatar(request: UploadMediaRequest, completion: @escaping (Result<CommonDTO, Error>) -> Void) {
        let endpoint = UserEndpoints.updateAvatarEndpoint()
        
        NetworkHelper.uploadMedia(endpoint: endpoint, request: request, completion: completion)
    }

    func getInfluencers(completion: @escaping (Result<GetInfluencersResponseDTO, Error>) -> Void) {
        let endpoint = UserEndpoints.getInfluencersEndpoint()

        NetworkHelper.request(endpoint: endpoint, completion: completion)
    }
    
    func getInfluencer(influencerId: Int, completion: @escaping (Result<InfluencerDTO, Error>) -> Void) {
        let endpoint = UserEndpoints.getInfluencerEndpoint(influencerId: influencerId)

        NetworkHelper.request(endpoint: endpoint, completion: completion)
    }
    
    func getNfts(request: GetNftsRequest, completion: @escaping (Result<GetNftsResponseDTO, Error>) -> Void) {
        let endpoint = UserEndpoints.getNftsEndpoint(request: request)
        
        NetworkHelper.request(endpoint: endpoint, completion: completion)
    }
    
    func getFollowers(request: FollowsRequest, completion: @escaping (Result<GetUsersResponseDTO, Error>) -> Void) {
        let endpoint = FollowsEndpoints.getFollowersEndpoint(request: request)
        
        NetworkHelper.request(endpoint: endpoint, completion: completion)
    }
    
    func getFollowing(request: FollowsRequest, completion: @escaping (Result<GetUsersResponseDTO, Error>) -> Void) {
        let endpoint = FollowsEndpoints.getFollowingEndpoint(request: request)

        NetworkHelper.request(endpoint: endpoint, completion: completion)
    }
    
    func follow(userId: Int, completion: @escaping (Result<CommonDTO, Error>) -> Void) {
        let endpoint = FollowsEndpoints.followEndpoint(userId: userId)

        NetworkHelper.request(endpoint: endpoint, completion: completion)
    }
    
    func unfollow(userId: Int, completion: @escaping (Result<CommonDTO, Error>) -> Void) {
        let endpoint = FollowsEndpoints.unfollowEndpoint(userId: userId)
        
        NetworkHelper.request(endpoint: endpoint, completion: completion)
    }
    
    func checkFollow(userId: Int, completion: @escaping (Result<CheckFollowResponseDTO, Error>) -> Void) {
        let endpoint = FollowsEndpoints.checkFollowEndpoint(userId: userId)
        
        NetworkHelper.request(endpoint: endpoint, completion: completion)
    }
    
}
