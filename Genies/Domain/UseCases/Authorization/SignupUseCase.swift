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
    
    init() {
        self.repository = AuthRepositoryImpl()
    }
    
    func signup(request: SignupRequest, completion: @escaping (Result<User, Error>) -> Void) {

            repository?.signup(request: request, completion: { result in
                switch result {
                    case .success(let resp) : do {
                        let user = User(
                            id: resp.id,
                            login: resp.login,
                            email: resp.email,
                            password: resp.email,
                            isMale: resp.isMale,
                            birthDate: resp.birthDate,
                            balance: resp.balance,
                            influencerId: resp.balance
                        )
                        
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
