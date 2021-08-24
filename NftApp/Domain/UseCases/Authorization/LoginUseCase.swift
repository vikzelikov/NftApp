//
//  LoginUseCase.swift
//  NftApp
//
//  Created by Yegor on 16.08.2021.
//

import Foundation

protocol LoginUseCase {
    
    func login(request: LoginRequest, completion: @escaping (Result<Bool, Error>) -> Void)
    
}

final class LoginUseCaseImpl: LoginUseCase {
    
    private let repository: AuthRepository?
    private let userStorage: UserStorage?
    
    init() {
        self.repository = AuthRepositoryImpl()
        self.userStorage = UserStorageImpl()
    }
    
    func login(request: LoginRequest, completion: @escaping (Result<Bool, Error>) -> Void) {

        repository?.login(request: request, completion: { result in
            switch result {
                case .success(let resp) : do {
                    let authToken = resp.token
                                            
                    self.userStorage?.saveAuthToken(token: authToken)
//                    self.userStorage?.saveUserId(userId: 1)
                    
                    completion(.success(true))
                }
                
                case .failure(let error) : do {
                    completion(.failure(error))
                }
            }
        })
    }
}

struct LoginRequest {
    var login: String = ""
    var password: String = ""
}
