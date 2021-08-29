//
//  InitialViewModel.swift
//  NftApp
//
//  Created by Yegor on 26.08.2021.
//

import Foundation

protocol InitialViewModel: BaseViewModel {
    
    var isShowHome: Observable<Bool?> { get }
    
    func initial()
    
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
    
    func initial() {
        if Constant.USER_ID == 0 || Constant.AUTH_TOKEN == "" {
            self.isShowHome.value = false
            return
        }
        
        getUser()
        
    }
    
    private func getUser() {
        userUseCase.getUser(completion: { result in
            switch result {
            case .success:
                self.getInitialData()
            case .failure(let error):
                if let error = error as? ErrorMessage, let code = error.code {
                    switch code {
                    case let c where c >= HttpCode.internalServerError:
                        self.errorMessage.value = NSLocalizedString("defaultError", comment: "")
                    case HttpCode.badRequest:
                        self.isShowHome.value = false
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
            case .success:
                self.isShowHome.value = true
            case .failure:
                self.errorMessage.value = NSLocalizedString("defaultError", comment: "")
            }
        })
    }
    
}
