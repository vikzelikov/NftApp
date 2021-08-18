//
//  SignupUseCase.swift
//  Genies
//
//  Created by Yegor on 15.08.2021.
//

import Foundation

protocol SignupUseCase {
    
    func signup(request: SignupRequest, completion: @escaping (Result<User, Error>) -> Void)
    
}

final class SignupUseCaseImpl: SignupUseCase {
    
    private let repository: AuthRepository?
    private let userStorage: UserStorage?
    
    init() {
        self.repository = AuthRepositoryImpl()
        self.userStorage = UserStorageImpl()
    }
    
    func signup(request: SignupRequest, completion: @escaping (Result<User, Error>) -> Void) {

        repository?.signup(request: request, completion: { result in
            switch result {
                case .success(let resp) : do {
                    let user = User(
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
                                            
                    self.userStorage?.saveAuthToken(token: user.authToken!)
                    self.userStorage?.saveUserId(userId: user.id!)
                    
                    completion(.success(user))
                }
                
                case .failure(let error) : do {
                    completion(.failure(error))
                }
            }
        })
    }
}

struct SignupRequest {
    var login: String = ""
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var isMale: Bool = true
    var birthDate: TimeInterval = 0
}