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
    
    func checkFollow(userId: Int, completion: @escaping (Result<TypeFollows, Error>) -> Void)
        
}

final class FollowsUseCaseImpl: FollowsUseCase {
    
    private let repository: UserRepository?
    
    init() {
        self.repository = UserRepositoryImpl()
    }
    
    func getFollowers(request: FollowsRequest, completion: @escaping (Result<[User], Error>) -> Void) {
        repository?.getFollowers(request: request, completion: { result in
            switch result {
                case .success(let resp) : do {
                    let users = resp.rows.map{User(id: $0.id, login: $0.login, email: $0.email)}
                    
                    completion(.success(users))
                }
                
                case .failure(let error) : do {
                    completion(.failure(error))
                }
            }
        })
    }

    func getFollowing(request: FollowsRequest, completion: @escaping (Result<[User], Error>) -> Void) {
        repository?.getFollowing(request: request, completion: { result in
            switch result {
                case .success(let resp) : do {
                    let users = resp.rows.map{User(id: $0.id, login: $0.login, email: $0.email)}
                    
                    completion(.success(users))
                }
                
                case .failure(let error) : do {
                    completion(.failure(error))
                }
            }
        })
    }
    
    func follow(userId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        repository?.follow(userId: userId, completion: completion)
    }
    
    func unfollow(userId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        repository?.unfollow(userId: userId, completion: completion)
    }
    
    func checkFollow(userId: Int, completion: @escaping (Result<TypeFollows, Error>) -> Void) {
        repository?.checkFollow(userId: userId, completion: { result in
            switch result {
                case .success(let resp) : do {
                    switch resp.type {
                        case "follower" : 
                            completion(.success(.followers))
                            
                        case "following" :
                            completion(.success(.following))
                            
                        default :
                            completion(.success(.none))
                        
                    }
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
