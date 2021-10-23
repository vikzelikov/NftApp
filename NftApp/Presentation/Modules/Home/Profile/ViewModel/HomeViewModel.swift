//
//  HomeViewModel.swift
//  NftApp
//
//  Created by Yegor on 25.09.2021.
//

import Foundation

protocol HomeViewModel: BaseViewModel {
    
    var userViewModel: Observable<UserCellViewModel?> { get }
    var followers: Observable<[UserCellViewModel]> { get }
    var following: Observable<[UserCellViewModel]> { get }
    var collectionNfts: Observable<[NftCellViewModel]> { get }
    var isOtherUser: Bool { get set }
    
    func viewDidLoad()
            
    func didSelectItem(at index: Int, completion: @escaping (NftCellViewModel) -> Void)
    
    func manageSubscribeDidTap(isFollow: Bool, completion: @escaping (Bool) -> Void)
    
}

class HomeViewModelImpl: HomeViewModel {

    let userUseCase: UserUseCase
    let followsUseCase: FollowsUseCase
    let nftUserCase: NftUseCase

    var page = 1
    var currentPage: Int = 1
    var totalPageCount: Int = 1
    var isOtherUser: Bool = false
    var userViewModel: Observable<UserCellViewModel?> = Observable(nil)
    var followers: Observable<[UserCellViewModel]> = Observable([])
    var following: Observable<[UserCellViewModel]> = Observable([])
    var collectionNfts: Observable<[NftCellViewModel]> = Observable([])
    var isLoading: Observable<Bool> = Observable(true)
    var errorMessage: Observable<String?> = Observable(nil)
    
    init() {
        userUseCase = UserUseCaseImpl()
        followsUseCase = FollowsUseCaseImpl()
        nftUserCase = NftUseCaseImpl()
    }
    
    func viewDidLoad() {
        getUser()
        
        getFollows()
        
        getCollectionNfts()
    }
    
    private func getUser() {
        let userId = userViewModel.value?.id ?? Constant.USER_ID
        
        userUseCase.getUser(userId: userId, completion: { result in
            switch result {
            case .success(let user):
                self.userViewModel.value = UserCellViewModel.init(user: user)
                
            case .failure(let error):
                let (_, errorStr) = ErrorHelper.validateError(error: error)
                self.errorMessage.value = errorStr
            }
        })
    }
    
    func getFollows() {
        let userId = userViewModel.value?.id ?? Constant.USER_ID
        let request = FollowsRequest(userId: userId)
        
        followsUseCase.getFollowers(request: request, completion: { result in
            switch result {
            case .success(let users):
                self.followers.value = users.map(UserCellViewModel.init)

            case .failure(let error):
                let (_, errorStr) = ErrorHelper.validateError(error: error)
                self.errorMessage.value = errorStr
            }
        })
        
        followsUseCase.getFollowing(request: request, completion: { result in
            switch result {
            case .success(let users):
                self.following.value = users.map(UserCellViewModel.init)

            case .failure(let error):
                let (_, errorStr) = ErrorHelper.validateError(error: error)
                self.errorMessage.value = errorStr
            }
        })
    }
    
    func getCollectionNfts() {
        isLoading.value = true
        
        guard let userId = userViewModel.value?.id else { return }
        let request = GetNftsRequest(userId: userId, page: page)
        
        nftUserCase.getNfts(request: request) { result in
            switch result {
            case .success(let nfts):
                self.appendNfts(nfts: nfts)
                
            case .failure(let error):
                let (code, errorStr) = ErrorHelper.validateError(error: error)
                if code == 404 { self.errorMessage.value = NSLocalizedString("Collection is empty", comment: "") }
                else { self.errorMessage.value = errorStr }
            }
            
            self.isLoading.value = false
        }
    }
    
    private func appendNfts(nfts: [Nft]) {
//        currentPage = page.page
//        totalPageCount = page.totalPages
        
        let nfts = nfts.map(NftCellViewModel.init)
        
        collectionNfts.value += nfts
        
        if collectionNfts.value.isEmpty {
            self.errorMessage.value = NSLocalizedString("Collection is empty", comment: "")
        }
    }
    
    private func resetPages() {
        currentPage = 1
        totalPageCount = 1
        collectionNfts.value.removeAll()
    }
    
    func didSelectItem(at index: Int, completion: @escaping (NftCellViewModel) -> Void) {
        let viewModel = collectionNfts.value[index]
        
        completion(viewModel)
    }
    
    func manageSubscribeDidTap(isFollow: Bool, completion: @escaping (Bool) -> Void) {
        guard let userId = userViewModel.value?.id else { return }
        
        followsUseCase.follow(userId: 3, completion: { result in
            switch result {
            case .success:
                completion(true)

            case .failure:
                completion(false)
            }
        })
        
//        followsUseCase.unfollow(userId: 3, completion: { result in
//            switch result {
//            case .success:
//                print("ok")
//
//            case .failure:
//                completion(false)
//            }
//        })
    }
    
}
