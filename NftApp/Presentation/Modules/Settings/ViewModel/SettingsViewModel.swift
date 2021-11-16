//
//  ProfileViewModel.swift
//  NftApp
//
//  Created by Yegor on 19.07.2021.
//

import Foundation

protocol SettingsViewModel: BaseViewModel {
        
    func viewDidLoad()
    
    func passwordUpdateDidTap(oldPassword: String, newPassword: String, confirmPassword: String, completion: @escaping (Bool) -> Void)
    
    func personalUpdateDidTap(login: String, email: String, completion: @escaping (Bool) -> Void)
    
    func invitationsUpdateDidTap(inviteWord: String, completion: @escaping (Bool) -> Void)
    
    func logoutDidTap()
        
}

class SettingsViewModelImpl: SettingsViewModel {
    
    private let userUseCase: UserUseCase
    
    var isLoading: Observable<Bool> = Observable(false)
    var errorMessage: Observable<String?> = Observable(nil)
    
    init() {
        userUseCase = UserUseCaseImpl()
    }
    
    func viewDidLoad() {
        
    }
    
    func passwordUpdateDidTap(oldPassword: String, newPassword: String, confirmPassword: String, completion: @escaping (Bool) -> Void) {
        let old = oldPassword.trimmingCharacters(in: .whitespacesAndNewlines)
        let new = newPassword.trimmingCharacters(in: .whitespacesAndNewlines)
        let conf = confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if old.isEmpty || new.isEmpty || conf.isEmpty {
            self.errorMessage.value = NSLocalizedString("Password is empty", comment: "")
            completion(false)
            return
        }
        
        if new != conf {
            self.errorMessage.value = NSLocalizedString("Passwords don't match", comment: "")
            completion(false)
            return
        }
        
        let user = User(id: Constant.USER_ID, oldPassword: oldPassword, newPassword: newPassword)
        
        userUseCase.updateUser(request: user, completion: { result in
            switch result {
            case .success:
                completion(true)

            case .failure(let error):
                var (_, errorStr) = ErrorHelper.validateError(error: error)
                if errorStr == "old password is error" {
                    errorStr = "Old password is error"
                }
                self.errorMessage.value = errorStr
                
                completion(false)
            }

            self.isLoading.value = false
        })
    }
    
    func personalUpdateDidTap(login: String, email: String, completion: @escaping (Bool) -> Void) {
        var user = User(id: Constant.USER_ID, login: login, email: email)
                
        if let userViewModel = UserObject.user.value {
            if userViewModel.login == login { user.login = nil }
            if userViewModel.email == email || !isValidEmail(email: email) { user.email = nil }
        }
        
        userUseCase.updateUser(request: user, completion: { result in
            switch result {
            case .success:
                if user.login != nil { UserObject.user.value?.login = login }
                if user.email != nil { UserObject.user.value?.email = email }
                
                UserObject.isNeedRefresh.value = true
                
                completion(true)

            case .failure(let error):
                var (_, errorStr) = ErrorHelper.validateError(error: error)
                if errorStr == "email used" || errorStr == "you are using this email" {
                    errorStr = NSLocalizedString("E-mail is already in use", comment: "")
                }
                self.errorMessage.value = errorStr
                
                completion(false)
            }

            self.isLoading.value = false
        })
    }
    
    func invitationsUpdateDidTap(inviteWord: String, completion: @escaping (Bool) -> Void) {
        let user = User(id: Constant.USER_ID, inviteWord: inviteWord)
                
        userUseCase.updateUser(request: user, completion: { result in
            switch result {
            case .success:
                completion(true)

            case .failure(let error):
                var (_, errorStr) = ErrorHelper.validateError(error: error)
                if errorStr == "email used" {
                    errorStr = NSLocalizedString("E-mail is already in use", comment: "")
                }
                self.errorMessage.value = errorStr
                
                completion(false)
            }

            self.isLoading.value = false
        })
    }

    func logoutDidTap() {
        userUseCase.clearUserStorage()
    }
    
    private func isValidEmail(email: String) -> Bool {
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: email)
        return result
    }
    
}
