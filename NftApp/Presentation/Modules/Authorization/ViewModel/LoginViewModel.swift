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
                // save user
                self.isSuccess.value = true
            case .failure(let error):
                self.isSuccess.value = false
                
                if let error = error as? ErrorMessage, let code = error.code {
                    switch code {
                    case let c where c >= HttpCode.internalServerError:
                        self.errorMessage.value = NSLocalizedString("defaultError", comment: "")
                        break
                    case let c where c >= HttpCode.badRequest:
                        self.errorMessage.value = NSLocalizedString("unauthorization", comment: "")
                        break
                    default:
                        self.errorMessage.value = NSLocalizedString("defaultError", comment: "")
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
