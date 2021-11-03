//
//  ProfileViewModel.swift
//  NftApp
//
//  Created by Yegor on 19.07.2021.
//

import Foundation

protocol SettingsViewModel: BaseViewModel {
        
    func viewDidLoad()
    
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

    func logoutDidTap() {
        userUseCase.clearUserStorage()
    }
    
}
