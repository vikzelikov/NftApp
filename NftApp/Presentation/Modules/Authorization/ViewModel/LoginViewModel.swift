//
//  LoginViewModel.swift
//  NftApp
//
//  Created by Yegor on 19.08.2021.
//

import Foundation

protocol LoginViewModel : BaseViewModel {
    
    var isSuccess: Observable<Bool> { get }
    var isSetupInvite: Observable<Bool> { get }
    var isSetupEarlyAccess: Observable<Bool> { get }
    
    func viewDidload()
    
    func loginDidTap(login: String, password: String)
    
    func appleAuthDidTap(appleId: String)
        
}

final class LoginViewModelImpl: LoginViewModel {
    
    private let loginUseCase: LoginUseCase

    var isLoading: Observable<Bool> = Observable(false)
    var isSuccess: Observable<Bool> = Observable(false)
    var isSetupInvite: Observable<Bool> = Observable(false)
    var isSetupEarlyAccess: Observable<Bool> = Observable(false)
    var errorMessage: Observable<String?> = Observable(nil)
    
    init(loginUseCase: LoginUseCase = DIContainer.shared.resolve(type: LoginUseCase.self)) {
        self.loginUseCase = loginUseCase
    }
    
    func viewDidload() {
        let isInvitingState = loginUseCase.getInvitingState()
        let isEarlyAccessState = loginUseCase.getEarlyAccessState()
        
        if let data = InitialDataObject.data.value {
            if !data.isEarlyAccess {
                loginUseCase.removeEarlyAccessState()
            } else if isEarlyAccessState {
                isSetupEarlyAccess.value = true
                return
            }
        }
        
        isSetupInvite.value = isInvitingState
    }

    func loginDidTap(login: String, password: String) {
        self.isLoading.value = true
        
        if login.isEmpty {
            errorMessage.value = NSLocalizedString("Please provide login", comment: "")
            isLoading.value = false
            return
        }
    
        if password.isEmpty {
            errorMessage.value = NSLocalizedString("Password is empty", comment: "")
            isLoading.value = false
            return
        }
        
        let loginRequest = LoginRequest(login: login, password: password)
        
        loginUseCase.login(request: loginRequest, completion: { result in
            switch result {
            case .success:
                self.checkInviting()
                
            case .failure(let error):
                var (httpCode, errorStr) = ErrorHelper.validateError(error: error)
                if httpCode == HTTPCode.badRequest || httpCode == HTTPCode.unauthorized {
                    errorStr = NSLocalizedString("Error login or password", comment: "")
                }
                self.errorMessage.value = errorStr
            }
            
            self.isLoading.value = false

        })
    }
    
    func appleAuthDidTap(appleId: String) {
        loginUseCase.appleLogin(appleId: appleId, completion: { result in
            switch result {
            case .success:
                self.checkInviting()
                
            case .failure(let error):
                var (httpCode, errorStr) = ErrorHelper.validateError(error: error)
                if httpCode == HTTPCode.badRequest {
                    errorStr = NSLocalizedString("Error Apple authorization", comment: "")
                }
                
                self.errorMessage.value = errorStr
            }
        })
    }
    
    private func checkInviting() {
        let isInvitingState = self.loginUseCase.getInvitingState()
                    
        if isInvitingState {
            self.isSetupInvite.value = true
        } else {
            self.isSuccess.value = true
        }
    }
    
}
