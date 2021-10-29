//
//  FollowsViewModel.swift
//  NftApp
//
//  Created by Yegor on 27.09.2021.
//

import Foundation

protocol FollowsViewModel: BaseViewModel {
    
    var typeFollows: TypeFollows { set get }
    var items: Observable<[UserViewModel]> { get }
    var userViewModel: Observable<UserViewModel?> { get }
    
    func viewDidLoad()
    
    func didSelectItem(at index: Int, completion: @escaping (UserViewModel) -> Void)
    
}

enum TypeFollows {
    case followers
    case following
    case none
}

class FollowsViewModelImpl: FollowsViewModel {
    
    private let followsUseCase: FollowsUseCase
    
    private var query: String = ""
    private var currentPage: Int = 1
    private var totalPageCount: Int = 1
    var typeFollows: TypeFollows = TypeFollows.followers
    var items: Observable<[UserViewModel]> = Observable([])
    var userViewModel: Observable<UserViewModel?> = Observable(nil)
    var isLoading: Observable<Bool> = Observable(false)
    var errorMessage: Observable<String?> = Observable(nil)
    
    init() {
        followsUseCase = FollowsUseCaseImpl()
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
        
        let followUsers = users.map(UserViewModel.init)
        
        items.value += followUsers
        
        if items.value.isEmpty {
//            self.errorMessage.value = NSLocalizedString("Drop Shop is empty", comment: "")
        }
    }
    
    private func resetPages() {
        currentPage = 1
        totalPageCount = 1
        items.value.removeAll()
    }
    
    func didSelectItem(at index: Int, completion: @escaping (UserViewModel) -> Void) {
        let viewModel = items.value[index]
        
        completion(viewModel)
    }
    
}
