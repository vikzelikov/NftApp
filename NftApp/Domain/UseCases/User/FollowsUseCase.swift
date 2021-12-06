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
    
    private let repository: UserRepository
    
    init(repository: UserRepository = DIContainer.shared.resolve(type: UserRepository.self)) {
        self.repository = repository
    }
    
    func getFollowers(request: FollowsRequest, completion: @escaping (Result<[User], Error>) -> Void) {
        repository.getFollowers(request: request, completion: { result in
            self.processGetFollows(result: result, completion: completion)
        })
    }

    func getFollowing(request: FollowsRequest, completion: @escaping (Result<[User], Error>) -> Void) {
        repository.getFollowing(request: request, completion: { result in
            self.processGetFollows(result: result, completion: completion)
        })
    }
    
    private func processGetFollows(
        result: Result<GetUsersResponseDTO, Error>,
        completion: @escaping (Result<[User], Error>) -> Void
    ) {
        switch result {
        case .success(let resp) : do {
            let users = resp.rows.map(User.init)

            completion(.success(users))
        }
        
        case .failure(let error) : do {
            completion(.failure(error))
        }
        }
    }
    
    func follow(userId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        repository.follow(userId: userId) { result in
            switch result {
            case .success : do {
                completion(.success(true))
            }
            
            case .failure(let error) : do {
                completion(.failure(error))
            }
            }
        }
    }
    
    func unfollow(userId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        repository.unfollow(userId: userId) { result in
            switch result {
            case .success : do {
                completion(.success(true))
            }
            
            case .failure(let error) : do {
                completion(.failure(error))
            }
            }
        }
    }
    
    func checkFollow(userId: Int, completion: @escaping (Result<(TypeFollows, TypeFollows), Error>) -> Void) {
        repository.checkFollow(userId: userId, completion: { result in
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
