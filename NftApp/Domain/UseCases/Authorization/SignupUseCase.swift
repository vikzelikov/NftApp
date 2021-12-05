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
    
    private let repository: AuthRepository
    private let userStorage: UserStorage
    
    init(
        repository: AuthRepository = AuthRepositoryImpl(),
        userStorage: UserStorage = UserStorageImpl()
    ) {
        self.repository = repository
        self.userStorage = userStorage
    }
    
    func signup(request: SignupRequest, completion: @escaping (Result<Bool, Error>) -> Void) {
        repository.signup(request: request, completion: { result in
            switch result {
                case .success(let resp) : do {
                    if let userId = resp.userId {
                        Constant.USER_ID = userId
                        self.userStorage.saveUserId(userId: userId)
                        
                        if let data = InitialDataObject.data.value {
                            data.isEarlyAccess ? self.userStorage.saveEarlyAccess() : self.userStorage.saveInvitingState()
                        }
                        
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
        userStorage.removeInvitingState()
    }
    
}

struct SignupRequest {
    
    var login: String = ""
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    
}
