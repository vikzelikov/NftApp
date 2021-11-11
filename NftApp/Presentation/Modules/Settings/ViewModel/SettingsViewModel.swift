//
//  ProfileViewModel.swift
//  NftApp
//
//  Created by Yegor on 19.07.2021.
//

import Foundation

protocol SettingsViewModel: BaseViewModel {
        
    func viewDidLoad()
    
    func passwordUpdateDidTap()
    
    func personalUpdateDidTap(login: String, email: String, completion: @escaping (Bool) -> Void)
    
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
    
    func passwordUpdateDidTap() {
        self.errorMessage.value = NSLocalizedString("defaultError", comment: "")
    }
    
    func personalUpdateDidTap(login: String, email: String, completion: @escaping (Bool) -> Void) {
        var user = User(id: Constant.USER_ID, login: login, email: email)
        
        if !isValidEmail(email: email) { user.email = nil }
        
        userUseCase.updateUser(request: user, completion: { result in
            switch result {
            case .success:
                completion(true)

            case .failure(let error):
                let (_, errorStr) = ErrorHelper.validateError(error: error)
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
