//
//  InitialViewModel.swift
//  NftApp
//
//  Created by Yegor on 26.08.2021.
//

import Foundation

protocol InitialViewModel: BaseViewModel {
    
    var isShowHome: Observable<Bool?> { get }
    
    func initial(isDelay: Bool)
    
}

class InitialViewModelImpl: InitialViewModel {
    
    private let initialUseCase: InitialUseCase
    private let userUseCase: UserUseCase

    var isLoading: Observable<Bool> = Observable(true)
    var isShowHome: Observable<Bool?> = Observable(nil)
    var errorMessage: Observable<String?> = Observable(nil)
    
    init() {
        initialUseCase = InitialUseCaseImpl()
        userUseCase = UserUseCaseImpl()
    }
    
    func initial(isDelay: Bool) {
        var seconds = 0.0
        if isDelay { seconds = 0.5 }
        
        isLoading.value = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            if Constant.USER_ID == 0 || Constant.AUTH_TOKEN == "" {
                self.isShowHome.value = false
                return
            }

            self.getUser()
        }
    }
    
    private func getUser() {        
        userUseCase.getUser(userId: Constant.USER_ID, completion: { result in
            switch result {
            case .success(let user):
                // save static
                UserObject.user.value = UserViewModel.init(user: user)
                
                self.getInitialData()
                break
                
            case .failure(let error):
                if let error = error as? ErrorMessage, let code = error.code {
                    switch code {
                    case let c where c >= HttpCode.internalServerError:
                        self.errorMessage.value = NSLocalizedString("defaultError", comment: "")
                        break
                    case let c where c >= HttpCode.badRequest:
                        self.isShowHome.value = false
                        break
                    default:
                        self.errorMessage.value = NSLocalizedString("defaultError", comment: "")
                    }
                } else {
                    self.errorMessage.value = NSLocalizedString("defaultError", comment: "")
                }
            }
        })
    }
    
    private func getInitialData() {
        initialUseCase.getInitialData(completion: { result in
            switch result {
            case .success(let data):
                InitialDataObject.data.value = data
                
                self.isShowHome.value = true
                break
            case .failure:
                self.errorMessage.value = NSLocalizedString("defaultError", comment: "")
                break
            }
        })
    }
    
}
