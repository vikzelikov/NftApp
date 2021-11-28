//
//  InviteViewModel.swift
//  NftApp
//
//  Created by Yegor on 13.11.2021.
//

import Foundation

protocol InviteViewModel : BaseViewModel {
    
    var isSuccess: Observable<Bool> { get }
    
    func nextDidTap(inviteWord: String)

}

class InviteViewModelImpl: InviteViewModel {
    
    private let loginUseCase: LoginUseCase

    var isLoading: Observable<Bool> = Observable(false)
    var isSuccess: Observable<Bool> = Observable(false)
    var errorMessage: Observable<String?> = Observable(nil)
    
    init(loginUseCase: LoginUseCase = LoginUseCaseImpl()) {
        self.loginUseCase = loginUseCase
    }
    
    func nextDidTap(inviteWord: String) {
        self.isLoading.value = true
        
        loginUseCase.checkInvite(inviteWord: inviteWord, completion: { result in
            switch result {
            case .success:
                self.isSuccess.value = true
                
            case .failure(let error):
                self.isSuccess.value = false
                
                var (httpCode, errorStr) = ErrorHelper.validateError(error: error)
                if errorStr == "invite word is invalid" {
                    errorStr = NSLocalizedString("Invitation has expired", comment: "")
                }
                
                if httpCode == HttpCode.notFound {
                    errorStr = NSLocalizedString("Invitation not found", comment: "")
                }
                self.errorMessage.value = errorStr
            }
            
            self.isLoading.value = false

        })
    }
    
}
