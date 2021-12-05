//
//  UserRepositoryImpl.swift
//  NftApp
//
//  Created by Yegor on 20.08.2021.
//

import Foundation

protocol UserRepository {
    
    func getUser(userId: Int, completion: @escaping (Result<UserDTO, Error>) -> Void)
    
    func updateUser(request: User, completion: @escaping (Result<UpdateUserResponseDTO, Error>) -> Void)
    
    func updateAvatar(request: UploadMediaRequest, completion: @escaping (Result<CommonDTO, Error>) -> Void)
    
    func getInfluencers(completion: @escaping (Result<GetInfluencersResponseDTO, Error>) -> Void)
    
    func getInfluencer(influencerId: Int, completion: @escaping (Result<InfluencerDTO, Error>) -> Void)
    
    func getNfts(request: GetNftsRequest, completion: @escaping (Result<GetNftsResponseDTO, Error>) -> Void)
    
    func getFollowers(request: FollowsRequest, completion: @escaping (Result<GetUsersResponseDTO, Error>) -> Void)
    
    func getFollowing(request: FollowsRequest, completion: @escaping (Result<GetUsersResponseDTO, Error>) -> Void)
    
    func follow(userId: Int, completion: @escaping (Result<CommonDTO, Error>) -> Void)
    
    func unfollow(userId: Int, completion: @escaping (Result<CommonDTO, Error>) -> Void)
    
    func checkFollow(userId: Int, completion: @escaping (Result<CheckFollowResponseDTO, Error>) -> Void)
            
}
