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
    var isSetupInvite: Observable<Bool> = Observable(false)
    var isSetupEarlyAccess: Observable<Bool> = Observable(false)
    var errorMessage: Observable<String?> = Observable(nil)
    
    init() {
        loginUseCase = LoginUseCaseImpl()
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
    
    func updateCredentials(login: String, password: String) {
        loginRequest.login = login
        loginRequest.password = password
    }

    private func auth() {
        self.isLoading.value = true
        
        loginUseCase.login(request: loginRequest, completion: { result in
            switch result {
            case .success:
                print("!!!!!!")
                self.checkInviting()
                
            case .failure(let error):
                self.isSuccess.value = false
                
                var (httpCode, errorStr) = ErrorHelper.validateError(error: error)
                if httpCode == HttpCode.badRequest || httpCode == HttpCode.unauthorized {
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
                self.isSuccess.value = false
                
                var (httpCode, errorStr) = ErrorHelper.validateError(error: error)
                if httpCode == HttpCode.badRequest {
                    errorStr = NSLocalizedString("Error Apple authorization", comment: "")
                }
                
                self.errorMessage.value = errorStr
            }
        })
    }
    
    func inputCredentials() {
        if login.isEmpty  {
            errorMessage.value = NSLocalizedString("Please provide login", comment: "")
            isSuccess.value = false
            return
        }
    
        if password.isEmpty {
            errorMessage.value = NSLocalizedString("Password is empty", comment: "")
            isSuccess.value = false
            return
        }
        
        auth()
        
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
