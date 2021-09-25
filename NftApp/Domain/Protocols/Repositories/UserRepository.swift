//
//  UserRepositoryImpl.swift
//  NftApp
//
//  Created by Yegor on 20.08.2021.
//

import Foundation

protocol UserRepository {
    
    func getUser(completion: @escaping (Result<GetUserResponseDTO, Error>) -> Void)
    
    func updateUser(request: User, completion: @escaping (Result<UpdateUserResponseDTO, Error>) -> Void)
    
    func getNfts(request: GetNftsRequest, completion: @escaping (Result<GetNftsResponseDTO, Error>) -> Void)
    
    func getFollowers(request: FollowsRequest, completion: @escaping (Result<GetFollowsResponseDTO, Error>) -> Void)
    
    func getFollowings(request: FollowsRequest, completion: @escaping (Result<GetFollowsResponseDTO, Error>) -> Void)
    
    func follow(userId: Int, completion: @escaping (Result<Bool, Error>) -> Void)
    
    func unfollow(userId: Int, completion: @escaping (Result<Bool, Error>) -> Void)
            
}
