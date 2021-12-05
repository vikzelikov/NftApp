//
//  FollowsViewModel.swift
//  NftApp
//
//  Created by Yegor on 27.09.2021.
//

import Foundation

protocol FollowsViewModel: BaseViewModel {
    
    var typeFollows: TypeFollows { get set }
    var items: Observable<[User]> { get }
    var userViewModel: Observable<User?> { get }
    
    func viewDidLoad()
    
    func didSelectItem(at index: Int, completion: @escaping (User) -> Void)
    
}

enum TypeFollows {
    
    case followers
    case following
    case none
    
}

final class FollowsViewModelImpl: FollowsViewModel {
    
    private let followsUseCase: FollowsUseCase
    
    private var query: String = ""
    private var currentPage: Int = 1
    private var totalPageCount: Int = 1
    var typeFollows: TypeFollows = TypeFollows.followers
    var items: Observable<[User]> = Observable([])
    var userViewModel: Observable<User?> = Observable(nil)
    var isLoading: Observable<Bool> = Observable(false)
    var errorMessage: Observable<String?> = Observable(nil)
    
    init(followsUseCase: FollowsUseCase = FollowsUseCaseImpl()) {
        self.followsUseCase = followsUseCase
    }
    
    func viewDidLoad() {
        if typeFollows == .followers { getFollowers() }
        
        if typeFollows == .following { getFollowing() }
    }

    func getFollowers() {
        self.isLoading.value = true
        
        guard let userId = userViewModel.value?.id else { return }
        let request = FollowsRequest(userId: userId)
        
        followsUseCase.getFollowers(request: request, completion: { result in
            switch result {
            case .success(let users):
                self.appendFollows(users: users)

            case .failure(let error):
                let (_, errorStr) = ErrorHelper.validateError(error: error)
                self.errorMessage.value = errorStr
            }

            self.isLoading.value = false
        })
    }
    
    func getFollowing() {
        self.isLoading.value = true
        
        guard let userId = userViewModel.value?.id else { return }
        let request = FollowsRequest(userId: userId)
        
        followsUseCase.getFollowing(request: request, completion: { result in
            switch result {
            case .success(let users):
                self.appendFollows(users: users)

            case .failure(let error):
                let (_, errorStr) = ErrorHelper.validateError(error: error)
                self.errorMessage.value = errorStr
            }

            self.isLoading.value = false
        })
    }
    
    private func appendFollows(users: [User]) {
//        currentPage = page.page
//        totalPageCount = page.totalPages
        
        items.value += users
    }
    
    private func resetPages() {
        currentPage = 1
        totalPageCount = 1
        items.value.removeAll()
    }
    
    func didSelectItem(at index: Int, completion: @escaping (User) -> Void) {
        let viewModel = items.value[index]
        
        completion(viewModel)
    }
    
}
