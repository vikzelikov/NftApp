//
//  LoginUseCase.swift
//  Genies
//
//  Created by Yegor on 16.08.2021.
//

import Foundation

protocol LoginUseCase {
    
    func login(request: LoginRequest, completion: @escaping (Result<User, Error>) -> Void)
    
}

final class LoginUseCaseImpl: LoginUseCase {
    
    private let repository: AuthRepository?
    private let userStorage: UserStorage?
    
    init() {
        self.repository = AuthRepositoryImpl()
        self.userStorage = UserStorageImpl()
    }
    
    func login(request: LoginRequest, completion: @escaping (Result<User, Error>) -> Void) {

        repository?.login(request: request, completion: { result in
            switch result {
                case .success(let resp) : do {
                    let user = User (
                        id: resp.id,
                        authToken: resp.authToken,
                        login: resp.login,
                        email: resp.email,
                        password: resp.password,
                        isMale: resp.isMale,
                        birthDate: resp.birthDate,
                        balance: resp.balance,
                        influencerId: resp.influencerId
                    )
                                            
                    self.userStorage?.saveAuthToken(token: "")
                    self.userStorage?.saveUserId(userId: 1)
                    
                    completion(.success(user))
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
