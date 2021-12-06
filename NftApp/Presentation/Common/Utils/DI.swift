//
//  DI.swift
//  NftApp
//
//  Created by Yegor on 27.11.2021.
//

import Foundation

protocol DIContainerProtocol {
    
    func register<Component>(type: Component.Type, component: Any)
    
    func resolve<Component>(type: Component.Type) -> Component
    
    func remove<Component>(type: Component.Type)
    
}

final class DIContainer: DIContainerProtocol {
    
    static let shared = DIContainer()

    private init() {}

    var components: [String: Any] = [:]

    func register<Component>(type: Component.Type, component: Any) {
        components["\(type)"] = component
    }

    func resolve<Component>(type: Component.Type) -> Component {
        guard let component = components["\(type)"] as? Component else {
            fatalError("DI error cast from: \(Component.self)")
        }
        
        return component
    }
    
    func remove<Component>(type: Component.Type) {
        components.removeValue(forKey: "\(type)")
    }
    
}

final class AppDIContainer {
    
    static let shared = AppDIContainer()

    private init() {}
    
    // MARK: - Initial
    func makeInitialScene() {
        let container = DIContainer.shared
        container.register(type: InitialRepository.self, component: InitialRepositoryImpl())
        container.register(type: UserRepository.self, component: UserRepositoryImpl())
        container.register(type: UserStorage.self, component: UserStorageImpl())
        
        container.register(type: UserUseCase.self, component: UserUseCaseImpl())
        container.register(type: InitialUseCase.self, component: InitialUseCaseImpl())
        
        container.register(type: InitialViewModel.self, component: InitialViewModelImpl())
    }

    // MARK: - Authorization
    func makeAuthorizationScene() {
        let container = DIContainer.shared
        container.register(type: AuthRepository.self, component: AuthRepositoryImpl())
        
        container.register(type: LoginUseCase.self, component: LoginUseCaseImpl())
        container.register(type: SignupUseCase.self, component: SignupUseCaseImpl())

        container.register(type: LoginViewModel.self, component: LoginViewModelImpl())
        container.register(type: SignupViewModel.self, component: SignupViewModelImpl())
    }
    
    // MARK: - Home
    func makeHomeScene() {
        let container = DIContainer.shared
        container.register(type: FollowsUseCase.self, component: FollowsUseCaseImpl())
        container.register(type: NftUseCase.self, component: NftUseCaseImpl())
        
        container.register(type: FollowsViewModel.self, component: FollowsViewModelImpl())
        container.register(type: HomeViewModel.self, component: HomeViewModelImpl())
    }

    // MARK: - DropShop
    func makeDropShopScene() {
        let container = DIContainer.shared
        container.register(type: DropShopRepository.self, component: DropShopRepositoryImpl())
        
        container.register(type: DropShopUseCase.self, component: DropShopUseCaseImpl())
        
        container.register(type: DropShopViewModel.self, component: DropShopViewModelImpl())
    }
    
    // MARK: - DropShop
    func makeSettingsScene() {
        let container = DIContainer.shared
        container.register(type: SettingsViewModel.self, component: SettingsViewModelImpl())
    }
    
    // MARK: - Wallet
    func makeWalletScene() {
        let container = DIContainer.shared
        container.register(type: WalletRepository.self, component: WalletRepositoryImpl())
        
        container.register(type: WalletUseCase.self, component: WalletUseCaseImpl())
        
        container.register(type: HistoryTransactionsViewModel.self, component: HistoryTransactionsViewModelImpl())
        container.register(type: DetailTransactionViewModel.self, component: DetailTransactionViewModelImpl())
        container.register(type: AddFundsViewModel.self, component: AddFundsViewModelImpl())
    }
    
    // MARK: - Search
    func makeSearchScene() {
        let container = DIContainer.shared
        container.register(type: SearchRepository.self, component: SearchRepositoryImpl())
        
        container.register(type: SearchUseCase.self, component: SearchUseCaseImpl())
        
        container.register(type: SearchViewModel.self, component: SearchViewModelImpl())
    }
    
    // MARK: - Influencers
    func makeInfluencersScene() {
        
    }
    
}
