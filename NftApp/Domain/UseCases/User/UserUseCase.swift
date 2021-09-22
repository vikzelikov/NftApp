//
//  UserUseCase.swift
//  NftApp
//
//  Created by Yegor on 20.08.2021.
//

import Foundation

protocol UserUseCase {
    
    func getUser(completion: @escaping (Result<User, Error>) -> Void)
    
    func updateUser(request: User, completion: @escaping (Result<Bool, Error>) -> Void)
    
}

final class UserUseCaseImpl: UserUseCase {
    
    private let repository: UserRepository?
    private let userStorage: UserStorage?
    
    init() {
        self.repository = UserRepositoryImpl()
        self.userStorage = UserStorageImpl()
    }
    
    func getUser(completion: @escaping (Result<User, Error>) -> Void) {
        repository?.getUser(completion: { result in
            switch result {
                case .success(let resp) : do {
                    let user = User(
                        id: resp.id,
                        login: resp.login,
                        email: resp.email
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
    
}
