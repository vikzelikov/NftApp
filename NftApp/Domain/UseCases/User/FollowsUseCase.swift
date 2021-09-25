//
//  FollowsUseCase.swift
//  NftApp
//
//  Created by Yegor on 25.09.2021.
//

import Foundation

protocol FollowsUseCase {
    
    func getFollowers(request: FollowsRequest, completion: @escaping (Result<[User], Error>) -> Void)
    
    func getFollowings(request: FollowsRequest, completion: @escaping (Result<[User], Error>) -> Void)
    
    func follow(userId: Int, completion: @escaping (Result<Bool, Error>) -> Void)
    
    func unfollow(userId: Int, completion: @escaping (Result<Bool, Error>) -> Void)
        
}

final class FollowsUseCaseImpl: FollowsUseCase {
    
    private let repository: UserRepository?
    private let userStorage: UserStorage?
    
    init() {
        self.repository = UserRepositoryImpl()
        self.userStorage = UserStorageImpl()
    }
    
    func getFollowers(request: FollowsRequest, completion: @escaping (Result<[User], Error>) -> Void) {
        repository?.getFollowers(request: request, completion: { result in
            switch result {
                case .success(let resp) : do {
                    print("success \(resp)")
                }
                
                case .failure(let error) : do {
                    completion(.failure(error))
                }
            }
        })
    }

    func getFollowings(request: FollowsRequest, completion: @escaping (Result<[User], Error>) -> Void) {
        repository?.getFollowings(request: request, completion: { result in
            switch result {
                case .success(let resp) : do {
                    print("success \(resp)")
                }
                
                case .failure(let error) : do {
                    completion(.failure(error))
                }
            }
        })
    }
    
    func follow(userId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        repository?.follow(userId: userId, completion: { result in
            switch result {
                case .success(let resp) : do {
                    print("success \(resp)")
                }
                
                case .failure(let error) : do {
                    completion(.failure(error))
                }
            }
        })
    }
    
    func unfollow(userId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        repository?.unfollow(userId: userId, completion: { result in
            switch result {
                case .success(let resp) : do {
                    print("success \(resp)")
                }
                
                case .failure(let error) : do {
                    completion(.failure(error))
                }
            }
        })
    }
    
}

struct FollowsRequest {
    var page: Int = 0
}
