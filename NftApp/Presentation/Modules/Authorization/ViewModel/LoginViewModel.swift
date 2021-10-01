//
//  LoginViewModel.swift
//  NftApp
//
//  Created by Yegor on 19.08.2021.
//

import Foundation

protocol LoginViewModel : BaseViewModel {
    
    var isSuccess: Observable<Bool> { get }
    
    func updateCredentials(login: String, password: String)
        
    func inputCredentials()
        
}

class LoginViewModelImpl: LoginViewModel {
    
    private let loginUseCase: LoginUseCase
    private let userUseCase: UserUseCase

    private var loginRequest = LoginRequest() {
        didSet {
            login = loginRequest.login
            password = loginRequest.password
        }
    }
    
    private var login = ""
    private var password = ""

    var isLoading: Observable<Bool> = Observable(false)
    var isSuccess: Observable<Bool> = Observable(false)
    var errorMessage: Observable<String?> = Observable(nil)
    
    init() {
        loginUseCase = LoginUseCaseImpl()
        userUseCase = UserUseCaseImpl()
    }
    
    func updateCredentials(login: String, password: String) {
        loginRequest.login = login
        loginRequest.password = password
    }

    private func auth() {
        self.isLoading.value = true
        
        loginUseCase.login(request: loginRequest, completion: { result in
            switch result {
            case .success:
                self.getUser()
                
            case .failure(let error):
                self.isLoading.value = false
                self.isSuccess.value = false
                
                if let error = error as? ErrorMessage, let code = error.code {
                    switch code {
                    case let c where c >= HttpCode.internalServerError:
                        self.errorMessage.value = NSLocalizedString("defaultError", comment: "")
                        break
                    case let c where c >= HttpCode.badRequest:
                        self.errorMessage.value = NSLocalizedString("Error login or password", comment: "")
                        break
                    default:
                        self.errorMessage.value = NSLocalizedString("defaultError", comment: "")
                    }
                }
            }
        })
    }
    
    private func getUser() {
        userUseCase.getUser(userId: Constant.USER_ID, completion: { result in
            switch result {
            case .success:
                self.isSuccess.value = true
                
            case .failure(let error):
                self.isSuccess.value = false
                
                if let error = error as? ErrorMessage, let code = error.code {
                    switch code {
                    case let c where c >= HttpCode.internalServerError:
                        self.errorMessage.value = NSLocalizedString("defaultError", comment: "")
                    case HttpCode.badRequest:
                        let message = error.errorDTO?.message
                        self.errorMessage.value = message
                    default:
                        self.errorMessage.value = NSLocalizedString("defaultError", comment: "")
                    }
                } else {
                    self.errorMessage.value = NSLocalizedString("defaultError", comment: "")
                }
            }
            
            self.isLoading.value = false

        })
    }
    
    func inputCredentials() {
        if login.isEmpty  {
            errorMessage.value = "Please provide login"
            isSuccess.value = false
            return
        }
    
        if password.isEmpty {
            errorMessage.value = "Password is empty"
            isSuccess.value = false
            return
        }
        
        auth()
        
    }
    
}
