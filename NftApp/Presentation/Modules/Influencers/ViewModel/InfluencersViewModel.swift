//
//  InfluencersViewModel.swift
//  NftApp
//
//  Created by Yegor on 31.10.2021.
//

import Foundation

protocol InfluencersViewModel: BaseViewModel {
    
    var items: Observable<[UserViewModel]> { get }
    
    func viewDidLoad()
    
    func didSelectItem(at index: Int, completion: @escaping (UserViewModel) -> Void)
    
}

class InfluencersViewModelImpl: InfluencersViewModel {
    
    private let userUseCase: UserUseCase
    
    private var query: String = ""
    private var currentPage: Int = 1
    private var totalPageCount: Int = 1
    var items: Observable<[UserViewModel]> = Observable([])
    var isLoading: Observable<Bool> = Observable(false)
    var errorMessage: Observable<String?> = Observable(nil)
    
    init(userUseCase: UserUseCase = UserUseCaseImpl()) {
        self.userUseCase = userUseCase
    }
    
    func viewDidLoad() {
        getInfluencers()
    }

    func getInfluencers() {
//        self.isLoading.value = true
//
//        guard let userId = userViewModel.value?.id else { return }
//        let request = FollowsRequest(userId: userId)
//
//        followsUseCase.getFollowers(request: request, completion: { result in
//            switch result {
//            case .success(let users):
//                self.appendFollows(users: users)
//
//            case .failure(let error):
//                let (_, errorStr) = ErrorHelper.validateError(error: error)
//                self.errorMessage.value = errorStr
//            }
//
//            self.isLoading.value = false
//        })
    }
    
    private func appendInfluencers(users: [User]) {
//        currentPage = page.page
//        totalPageCount = page.totalPages
        
        let followUsers = users.map(UserViewModel.init)
        
        items.value += followUsers
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
