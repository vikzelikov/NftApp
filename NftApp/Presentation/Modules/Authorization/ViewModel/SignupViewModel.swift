//
//  SignupViewModel.swift
//  NftApp
//
//  Created by Yegor on 16.08.2021.
//

import Foundation

protocol SignupViewModel : BaseViewModel {
    
    var isSuccess: Observable<Bool> { get }
    
    func signupDidTap(login: String, email: String, password: String, confirmPassword: String)
    
    func updatePersonalData(isMale: Bool?, birthDate: TimeInterval?)

}

class SignupViewModelImpl: SignupViewModel {
    
    private let signupUseCase: SignupUseCase
    private var isMale: Bool? = nil
    private var birthDate: TimeInterval? = 0

    var isLoading: Observable<Bool> = Observable(false)
    var isSuccess: Observable<Bool> = Observable(false)
    var errorMessage: Observable<String?> = Observable(nil)
    
    init(signupUseCase: SignupUseCase = SignupUseCaseImpl()) {
        self.signupUseCase = signupUseCase
    }
    
    func updatePersonalData(isMale: Bool?, birthDate: TimeInterval?) {
//        if let isMale = isMale {
//            signupRequest.isMale = isMale
//        }
//
//        if let birthDate = birthDate {
//            signupRequest.birthDate = birthDate
//        }
    }
    
    func signupDidTap(login: String, email: String, password: String, confirmPassword: String) {
        self.isLoading.value = true
        
        let isValid = validateCredentials(login: login, email: email, password: password, confirmPassword: confirmPassword)
        
        if !isValid {
            self.isLoading.value = false
            return
        }
        
        let signupRequest = SignupRequest(
            login: login,
            email: email,
            password: password,
            confirmPassword: confirmPassword
        )
        
        signupUseCase.signup(request: signupRequest, completion: { result in
            switch result {
            case .success:
                self.isSuccess.value = true

            case .failure(let error):
                self.isSuccess.value = false

                let (_, errorStr) = ErrorHelper.validateError(error: error)
                self.errorMessage.value = errorStr
            }
            
            self.isLoading.value = false

        })
    }
    
    private func validateCredentials(login: String, email: String, password: String, confirmPassword: String) -> Bool {
        if login.isEmpty || email.isEmpty  {
            errorMessage.value = NSLocalizedString("Please provide login and E-mail", comment: "")
            return false
        }
        
        if !isValidEmail(email: email) {
            errorMessage.value = NSLocalizedString("E-mail is not vaild", comment: "")
            return false
        }
    
        if password.isEmpty {
            errorMessage.value = NSLocalizedString("Password is empty", comment: "")
            return false
        }
        
        if password != confirmPassword  {
            errorMessage.value = NSLocalizedString("Passwords don't match", comment: "")
            return false
        }
        
        return true
    }
    
    private func isValidEmail(email: String) -> Bool {
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: email)
        return result
    }

}
