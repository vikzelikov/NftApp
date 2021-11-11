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
    
    func appleAuthDidTap(appleId: String)
        
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
            case .success:
                self.isSuccess.value = true
                
            case .failure(let error):
                self.isSuccess.value = false
                
                var (httpCode, errorStr) = ErrorHelper.validateError(error: error)
                if httpCode >= HttpCode.badRequest {
                    errorStr = NSLocalizedString("Error login or password", comment: "")
                }
                self.errorMessage.value = errorStr
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
    
    func appleAuthDidTap(appleId: String) {
        loginUseCase.appleLogin(appleId: appleId, completion: { result in
            switch result {
            case .success:
                self.isSuccess.value = true
                
            case .failure(let error):
                self.isSuccess.value = true
                
                if let error = error as? ErrorMessage, let code = error.code {
                    switch code {
                    case let c where c >= HttpCode.internalServerError:
                        self.errorMessage.value = NSLocalizedString("defaultError", comment: "")
                        break
                    case let c where c >= HttpCode.badRequest:
                        self.errorMessage.value = NSLocalizedString("Error apple auth", comment: "")
                        break
                    default:
                        self.errorMessage.value = NSLocalizedString("defaultError", comment: "")
                    }
                }
            }
        })
    }
    
}
