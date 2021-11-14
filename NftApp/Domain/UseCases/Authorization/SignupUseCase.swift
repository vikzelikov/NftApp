//
//  SignupUseCase.swift
//  NftApp
//
//  Created by Yegor on 15.08.2021.
//

import Foundation

protocol SignupUseCase {
    
    func signup(request: SignupRequest, completion: @escaping (Result<Bool, Error>) -> Void)
    
    func removeInvitingState()
    
}

final class SignupUseCaseImpl: SignupUseCase {
    
    private let repository: AuthRepository?
    private let userStorage: UserStorage?
    
    init() {
        self.repository = AuthRepositoryImpl()
        self.userStorage = UserStorageImpl()
    }
    
    func signup(request: SignupRequest, completion: @escaping (Result<Bool, Error>) -> Void) {
        repository?.signup(request: request, completion: { result in
            switch result {
                case .success(let resp) : do {
                    let authToken = resp.token

                    if let userId = JWT.decode(jwtToken: authToken)["id"] as? Int {
                        Constant.AUTH_TOKEN = authToken
                        Constant.USER_ID = userId
                        self.userStorage?.saveAuthToken(token: authToken)
                        self.userStorage?.saveUserId(userId: userId)
                        self.userStorage?.saveInvitingState()
                        
                        completion(.success(true))
                    } else {
                        completion(.failure(ErrorMessage(errorType: .cancelled, errorDTO: nil, code: nil)))
                    }
                }
                
                case .failure(let error) : do {
                    completion(.failure(error))
                }
            }
        })
    }
    
    func removeInvitingState() {
        userStorage?.removeInvitingState()
    }
    
}

struct SignupRequest {
    var login: String = ""
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
}
