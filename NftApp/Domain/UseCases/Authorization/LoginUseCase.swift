//
//  LoginUseCase.swift
//  NftApp
//
//  Created by Yegor on 16.08.2021.
//

import Foundation

protocol LoginUseCase {
    
    func login(request: LoginRequest, completion: @escaping (Result<Bool, Error>) -> Void)
    
    func appleLogin(appleId: String, completion: @escaping (Result<Bool, Error>) -> Void)
    
    func checkInvite(inviteWord: String, completion: @escaping (Result<Bool, Error>) -> Void)
    
    func saveInvitingState()
    
    func getInvitingState() -> Bool

    func removeInvitingState()
    
    func getEarlyAccessState() -> Bool
    
    func removeEarlyAccessState()

}

final class LoginUseCaseImpl: LoginUseCase {
    
    private let repository: AuthRepository
    private let userStorage: UserStorage
    
    init(
        repository: AuthRepository = AuthRepositoryImpl(),
        userStorage: UserStorage = UserStorageImpl()
    ) {
        self.repository = repository
        self.userStorage = userStorage
    }
    
    func login(request: LoginRequest, completion: @escaping (Result<Bool, Error>) -> Void) {
        repository.login(request: request, completion: { result in
            self.loginProcess(result: result, completion: completion)
        })
    }
    
    func appleLogin(appleId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        repository.appleLogin(appleId: appleId, completion: { result in
            self.loginProcess(result: result, completion: completion)
        })
    }
    
    func checkInvite(inviteWord: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        repository.checkInvite(inviteWord: inviteWord, completion: { result in
            switch result {
            case .success(let resp) : do {
                if let authToken = resp.token {
                    if let userId = JWT.decode(jwtToken: authToken)["id"] as? Int {
                        Constant.AUTH_TOKEN = authToken
                        Constant.USER_ID = userId
                        self.userStorage.saveAuthToken(token: authToken)
                        self.userStorage.saveUserId(userId: userId)
                        self.removeInvitingState()
                        
                        completion(.success(true))
                    } else {
                        completion(.failure(ErrorMessage(errorType: .cancelled, errorDTO: nil, code: nil)))
                    }
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
    
    private func loginProcess(
        result: Result<AuthResponseDTO, Error>,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        switch result {
        case .success(let resp) : do {
            if let authToken = resp.token {
                // already invited
                if let userId = JWT.decode(jwtToken: authToken)["id"] as? Int {
                    Constant.AUTH_TOKEN = authToken
                    Constant.USER_ID = userId
                    self.userStorage.saveAuthToken(token: authToken)
                    self.userStorage.saveUserId(userId: userId)
                    
                    completion(.success(true))
                } else {
                    completion(.failure(ErrorMessage(errorType: .cancelled, errorDTO: nil, code: nil)))
                }
            } else if let userId = resp.userId {
                // check invite
                Constant.USER_ID = userId
                self.userStorage.saveUserId(userId: userId)
                self.saveInvitingState()

                completion(.success(true))
            } else {
                completion(.failure(ErrorMessage(errorType: .cancelled, errorDTO: nil, code: nil)))
            }
        }
            
        case .failure(let error) : do {
            completion(.failure(error))
        }
        }
    }
    
    func saveInvitingState() {
        userStorage.saveInvitingState()
    }
    
    func getInvitingState() -> Bool {
        return userStorage.getInvitingState()
    }
    
    func removeInvitingState() {
        userStorage.removeInvitingState()
    }
    
    func getEarlyAccessState() -> Bool {
        return userStorage.getEarlyAccess()
    }
    
    func removeEarlyAccessState() {
        userStorage.removeEarlyAccess()
    }
    
}

struct LoginRequest {
    
    var login: String = ""
    var password: String = ""
    
}
