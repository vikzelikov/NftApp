//
//  UserUseCase.swift
//  Genies
//
//  Created by Yegor on 20.08.2021.
//

import Foundation

protocol UserUseCase {
    
    func getUser(completion: @escaping (Result<User, Error>) -> Void)
    
}

final class UserUseCaseImpl: UserUseCase {
    
    private let repository: UserRepository?
    private let userStorage: UserStorage?
    
    init() {
        self.repository = UserRepositoryImpl()
        self.userStorage = UserStorageImpl()
    }
    
    func getUser(completion: @escaping (Result<User, Error>) -> Void) {
        if let userId = userStorage?.getUserId() {
            repository?.getUser(userId: userId, completion: { result in
                switch result {
                    case .success(let resp) : do {
                        let user = User(
                            id: resp.id,
                            login: resp.login,
                            email: resp.email
                        )
                    }
                    
                    case .failure(let error) : do {
                        completion(.failure(error))
                    }
                }
            })
        } else {
            completion(.failure(ErrorMessage(errorType: .cancelled, errorDTO: nil, code: nil)))
        }
    }
}
