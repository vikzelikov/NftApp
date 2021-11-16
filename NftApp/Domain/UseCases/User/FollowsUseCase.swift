//
//  FollowsUseCase.swift
//  NftApp
//
//  Created by Yegor on 25.09.2021.
//

import Foundation

protocol FollowsUseCase {
    
    func getFollowers(request: FollowsRequest, completion: @escaping (Result<[User], Error>) -> Void)
    
    func getFollowing(request: FollowsRequest, completion: @escaping (Result<[User], Error>) -> Void)
    
    func follow(userId: Int, completion: @escaping (Result<Bool, Error>) -> Void)
    
    func unfollow(userId: Int, completion: @escaping (Result<Bool, Error>) -> Void)
    
    func checkFollow(userId: Int, completion: @escaping (Result<(TypeFollows, TypeFollows), Error>) -> Void)
        
}

final class FollowsUseCaseImpl: FollowsUseCase {
    
    private let repository: UserRepository?
    
    init() {
        self.repository = UserRepositoryImpl()
    }
    
    func getFollowers(request: FollowsRequest, completion: @escaping (Result<[User], Error>) -> Void) {
        repository?.getFollowers(request: request, completion: { result in
            self.processGetFollows(result: result, completion: completion)
        })
    }

    func getFollowing(request: FollowsRequest, completion: @escaping (Result<[User], Error>) -> Void) {
        repository?.getFollowing(request: request, completion: { result in
            self.processGetFollows(result: result, completion: completion)
        })
    }
    
    private func processGetFollows(result: Result<GetUsersResponseDTO, Error>, completion: @escaping (Result<[User], Error>) -> Void) {
        switch result {
            case .success(let resp) : do {
                let users = resp.rows.map{User(
                    id: $0.id,
                    influencerId: $0.influencerId,
                    login: $0.login,
                    email: $0.email,
                    flowAddress: $0.flowAddress,
                    avatarUrl: $0.avatarUrl,
                    totalCost: Double($0.totalCost ?? "0.0"),
                    countNFTs: Int($0.countNFTs ?? "0")
                )}
                
                completion(.success(users))
            }
            
            case .failure(let error) : do {
                completion(.failure(error))
            }
        }
    }
    
    func follow(userId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        repository?.follow(userId: userId, completion: completion)
    }
    
    func unfollow(userId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        repository?.unfollow(userId: userId, completion: completion)
    }
    
    func checkFollow(userId: Int, completion: @escaping (Result<(TypeFollows, TypeFollows), Error>) -> Void) {
        repository?.checkFollow(userId: userId, completion: { result in
            switch result {
                case .success(let resp) : do {
                    var requester: TypeFollows = .none
                    var user: TypeFollows = .none
                    
                    if resp.requester == "follower" {
                        requester = .followers
                    }
                    
                    if resp.user == "follower" {
                        user = .followers
                    }
                    
                    completion(.success((requester, user)))
                }
                
                case .failure(let error) : do {
                    completion(.failure(error))
                }
            }
        })
    }
    
}

struct FollowsRequest {
    var userId: Int = 0
    var page: Int = 0
}
