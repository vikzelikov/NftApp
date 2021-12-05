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
    
    func updateAvatar(request: UploadMediaRequest, completion: @escaping (Result<Bool, Error>) -> Void)
    
    func getInfluencers(completion: @escaping (Result<[User], Error>) -> Void)
    
    func clearUserStorage()
    
}

final class UserUseCaseImpl: UserUseCase {
    
    private let repository: UserRepository
    private let userStorage: UserStorage
    
    init(repository: UserRepository = UserRepositoryImpl(), userStorage: UserStorage = UserStorageImpl()) {
        self.repository = repository
        self.userStorage = userStorage
    }
    
    func getUser(userId: Int, completion: @escaping (Result<User, Error>) -> Void) {
        repository.getUser(userId: userId) { result in
            switch result {
            case .success(let userDTO) : do {
                let user = User.init(user: userDTO)

                completion(.success(user))
            }
            
            case .failure(let error) : do {
                completion(.failure(error))
            }
            }
        }
    }
    
    func updateUser(request: User, completion: @escaping (Result<Bool, Error>) -> Void) {
        repository.updateUser(request: request) { result in
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
    
    func updateAvatar(request: UploadMediaRequest, completion: @escaping (Result<Bool, Error>) -> Void) {
        repository.updateAvatar(request: request) { result in
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
    
    func getInfluencers(completion: @escaping (Result<[User], Error>) -> Void) {
        repository.getInfluencers { result in
            switch result {
            case .success(let resp) : do {
                let users: [User] = resp.rows.map {
                    var user = User.init(user: $0.user)
                    user.influencerId = $0.id
                    return user
                }
                
                completion(.success(users))
            }
            
            case .failure(let error) : do {
                completion(.failure(error))
            }
            }
        }
    }
    
    func clearUserStorage() {
        userStorage.clearUserStorage()
    }
    
}
