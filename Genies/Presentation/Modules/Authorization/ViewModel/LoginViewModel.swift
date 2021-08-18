//
//  LoginViewModel.swift
//  Genies
//
//  Created by Yegor on 19.08.2021.
//

import Foundation

protocol LoginViewModel : BaseViewModel {
    
    func updateCredentials(login: String, password: String)
        
    func inputCredentials()
        
}

class LoginViewModelImpl: LoginViewModel {
    private let loginUseCase: LoginUseCase
    
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
    }
    
    func updateCredentials(login: String, password: String) {
        loginRequest.login = login
        loginRequest.password = password
    }

    private func auth() {
        self.isLoading.value = true
        
        loginUseCase.login(request: loginRequest, completion: { result in
            switch result {
            case .success(let user):
                NSLog("OK: \(user)")
                self.isSuccess.value = true
            case .failure(let error):
                self.isSuccess.value = false
                NSLog("ERROR: \(String(describing: SignupViewModel.self)) \(error)")
                if let error = error as? ErrorMessage, let code = error.code {
                    switch code {
                    case let c where c >= HttpCode.internalServerError:
                        self.errorMessage.value = "Something went wrong"
                    case HttpCode.unauthorized:
                        self.errorMessage.value = "Do login"
                    case HttpCode.badRequest:
                        let message = error.errorDTO?.message
                        self.errorMessage.value = message
                    default:
                        self.errorMessage.value = "Something went wrong"
                    }
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
