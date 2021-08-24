//
//  SignupViewModel.swift
//  NftApp
//
//  Created by Yegor on 16.08.2021.
//

import Foundation

protocol SignupViewModel : BaseViewModel {
    
    var isSuccess: Observable<Bool> { get }
    
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
            case .success(let isSuccess):
                NSLog("OK Signup: \(isSuccess)")
                self.isSuccess.value = true
            case .failure(let error):
                self.isSuccess.value = false
                NSLog("ERROR: \(String(describing: SignupViewModel.self)) \(error)")
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
        if login.isEmpty || email.isEmpty  {
            errorMessage.value = "Please provide login and E-mail"
            isSuccess.value = false
            return
        }
        
        if !isValidEmail(email: email) {
            errorMessage.value = "E-mail is not vaild"
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
        
        
//        isSuccess.value = true
        signup()
        
    }
    
    func inputPersonalData() {
        // validate
        
        signup()
    }
    
    private func isValidEmail(email: String) -> Bool {
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: email)
        return result
    }
    
    private func validUserData() -> Bool {
        return !login.isEmpty && !email.isEmpty && !password.isEmpty && isMale != nil && birthDate != 0
    }
    
}
