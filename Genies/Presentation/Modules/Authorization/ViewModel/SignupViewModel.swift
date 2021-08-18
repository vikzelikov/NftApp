//
//  SignupViewModel.swift
//  Genies
//
//  Created by Yegor on 16.08.2021.
//

import Foundation

protocol SignupViewModel {
    var isLoading: Observable<Bool> { get }
    var isSuccess: Observable<Bool> { get }
    var errorMessage: Observable<String?> { get }
    
    func updateCredentials(login: String, email: String, password: String, confirmPassword: String)
    
    func updatePersonalData(isMale: Bool?, birthDate: TimeInterval?)
    
    func inputCredentials()
    
    func inputPersonalData()
    
}

class SignupViewModelImpl: SignupViewModel {
    private let signupUseCase: SignupUseCase
    
    private var signupRequest = SignupRequest() {
        didSet {
            login = signupRequest.login
            email = signupRequest.email
            password = signupRequest.password
            confirmPassword = signupRequest.confirmPassword
            isMale = signupRequest.isMale
            birthDate = signupRequest.birthDate
        }
    }
    
    private var login = ""
    private var email = ""
    private var password = ""
    private var confirmPassword = ""
    private var isMale: Bool? = nil
    private var birthDate: TimeInterval? = 0

    var isLoading: Observable<Bool> = Observable(false)
    var isSuccess: Observable<Bool> = Observable(false)
    var errorMessage: Observable<String?> = Observable(nil)
    
    init() {
        signupUseCase = SignupUseCaseImpl()
    }
    
    func updateCredentials(login: String, email: String, password: String, confirmPassword: String) {
        signupRequest.login = login
        signupRequest.email = email
        signupRequest.password = password
        signupRequest.confirmPassword = confirmPassword
    }
    
    func updatePersonalData(isMale: Bool?, birthDate: TimeInterval?) {
        if let isMale = isMale {
            signupRequest.isMale = isMale
        }
        
        if let birthDate = birthDate {
            signupRequest.birthDate = birthDate
        }
    }
    
    private func signup() {
        self.isLoading.value = true
        
        signupUseCase.signup(request: signupRequest, completion: { result in
            switch result {
            case .success(let user):
                NSLog("OK: \(user)")
                self.isSuccess.value = true
            case .failure(let error):
                self.isSuccess.value = false
                NSLog("ERROR: \(String(describing: SignupViewModel.self)) \(error)")
//                errorMessage.value = "Login already exists"
            }
            
            self.isLoading.value = false
        })
    }
    
    func inputCredentials() {
        if login.isEmpty || email.isEmpty  {
            errorMessage.value = "Please provide login and E-mail"
            isSuccess.value = false
            return
        }
    
        if password.isEmpty {
            errorMessage.value = "Password is empty"
            isSuccess.value = false
            return
        }
        
        if password != confirmPassword  {
            errorMessage.value = "Passwords don't match"
            isSuccess.value = false
            return
        }
        
        
        isSuccess.value = true
        signup()
        
    }
    
    func inputPersonalData() {
        // validate
        
        signup()
    }
    
    private func validUserData() -> Bool {
        return !login.isEmpty && !email.isEmpty && !password.isEmpty && isMale != nil && birthDate != 0
    }
    
}
