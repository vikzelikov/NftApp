//
//  UserUseCase.swift
//  NftApp
//
//  Created by Yegor on 20.08.2021.
//

import Foundation

protocol UserUseCase {
    
    func getUser(userId: Int, completion: @escaping (Result<User, Error>) -> Void)
    
    func updateUser(request: User, completion: @escaping (Result<Bool, Error>) -> Void)
    
    func updateAvatar(request: UpdateAvatarRequest, completion: @escaping (Result<Bool, Error>) -> Void)
    
    func getInfluencers(completion: @escaping (Result<[User], Error>) -> Void)
    
}

final class UserUseCaseImpl: UserUseCase {
    
    private let repository: UserRepository?
    private let userStorage: UserStorage?
    
    init() {
        self.repository = UserRepositoryImpl()
        self.userStorage = UserStorageImpl()
    }
    
    func getUser(userId: Int, completion: @escaping (Result<User, Error>) -> Void) {
        repository?.getUser(userId: userId, completion: { result in
            switch result {
                case .success(let resp) : do {
                    let user = User(
                        id: resp.id,
                        login: resp.login,
                        email: resp.email,
                        flowAddress: resp.flowAddress,
                        avatarUrl: resp.avatarUrl
                    )
                    
                    completion(.success(user))
                }
                
                case .failure(let error) : do {
                    completion(.failure(error))
                }
            }
        })
    }
    
    func updateUser(request: User, completion: @escaping (Result<Bool, Error>) -> Void) {
        repository?.updateUser(request: request, completion: { result in
            switch result {
                case .success(let resp) : do {
                    print(resp)
                }
                
                case .failure(let error) : do {
                    completion(.failure(error))
                }
            }
        })
    }
    
    func updateAvatar(request: UpdateAvatarRequest, completion: @escaping (Result<Bool, Error>) -> Void) {
        repository?.updateAvatar(request: request, completion: completion)
    }
    
    func getInfluencers(completion: @escaping (Result<[User], Error>) -> Void) {
        repository?.getInfluencers { result in
            switch result {
                case .success(let resp) : do {
                    let users = resp.rows.map{User(id: $0.user.id, login: $0.user.login, email: $0.user.email)}
                    
                    completion(.success(users))
                }
                
                case .failure(let error) : do {
                    completion(.failure(error))
                }
            }
        }
    }
    
}
