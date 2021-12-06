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

final class InitialViewModelImpl: InitialViewModel {
    
    private let initialUseCase: InitialUseCase
    private let userUseCase: UserUseCase

    var isLoading: Observable<Bool> = Observable(true)
    var isShowHome: Observable<Bool?> = Observable(nil)
    var errorMessage: Observable<String?> = Observable(nil)
    
    init() {
        initialUseCase = DIContainer.shared.resolve(type: InitialUseCase.self)
        userUseCase = DIContainer.shared.resolve(type: UserUseCase.self)
    }
    
    func initial(isDelay: Bool) {
        isLoading.value = true

        var seconds = 0.0
        if isDelay { seconds = 0.5 }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.getInitialData { result in
                if result {
                    if let data = InitialDataObject.data.value {
                        if !data.isAppAvailable {
                            self.errorMessage.value = NSLocalizedString("YUP is temporarily unavailable", comment: "")
                            return
                        }
                        
                        self.checkUser()
                        
                    }
                }
            }
        }
    }
    
    private func checkUser() {
        if Constant.USER_ID == 0 || Constant.AUTH_TOKEN == "" {
            self.userUseCase.clearUserStorage()
            self.isShowHome.value = false
        } else {
            self.getUser()
        }
    }
    
    private func getUser() {
        userUseCase.getUser(userId: Constant.USER_ID, completion: { result in
            switch result {
            case .success(let user):
                if user.publicKey != nil {
                    // save static
                    UserObject.user.value = user
                    self.isShowHome.value = true
                } else {
                    self.userUseCase.clearUserStorage()
                    self.isShowHome.value = false
                }
                
            case .failure:
                self.userUseCase.clearUserStorage()
                self.isShowHome.value = false
            }
        })
    }
    
    private func getInitialData(completion: @escaping (Bool) -> Void) {
        initialUseCase.getInitialData(completion: { result in
            switch result {
            case .success:
                completion(true)
            case .failure:
                self.errorMessage.value = NSLocalizedString("defaultError", comment: "")
                completion(false)
            }
        })
    }
    
}
