//
//  HomeViewModel.swift
//  NftApp
//
//  Created by Yegor on 25.09.2021.
//

import Foundation

protocol HomeViewModel: BaseViewModel {
    
    var userViewModel: Observable<UserViewModel?> { get }
    var followers: Observable<[UserViewModel]> { get }
    var following: Observable<[UserViewModel]> { get }
    var collectionNfts: Observable<[NftViewModel]> { get }
    var typeFollows: Observable<TypeFollows?> { get }
    
    func viewDidLoad()
            
    func didSelectItem(at index: Int, completion: @escaping (NftViewModel) -> Void)
    
    func manageSubscribeDidTap(isFollow: Bool, completion: @escaping (Bool) -> Void)
    
    func userImageDidTap(completion: @escaping (Bool) -> Void)
    
    func updateAvatar(request: UpdateAvatarRequest, completion: @escaping (Result<Bool, Error>) -> Void)
    
}

class HomeViewModelImpl: HomeViewModel {

    let userUseCase: UserUseCase
    let followsUseCase: FollowsUseCase
    let nftUserCase: NftUseCase

    var page = 1
    var currentPage: Int = 1
    var totalPageCount: Int = 1
    var userViewModel: Observable<UserViewModel?> = Observable(nil)
    var followers: Observable<[UserViewModel]> = Observable([])
    var following: Observable<[UserViewModel]> = Observable([])
    var collectionNfts: Observable<[NftViewModel]> = Observable([])
    var typeFollows: Observable<TypeFollows?> = Observable(nil)
    var isLoading: Observable<Bool> = Observable(true)
    var errorMessage: Observable<String?> = Observable(nil)
    
    init() {
        userUseCase = UserUseCaseImpl()
        followsUseCase = FollowsUseCaseImpl()
        nftUserCase = NftUseCaseImpl()
        
        // set main user by default 
        if let user = UserObject.user {
            userViewModel.value = UserViewModel(id: user.id, login: user.login, email: user.email, flowAddress: user.flowAddress, avatarUrl: user.avatarUrl)
        }
    }
    
    func viewDidLoad() {
        resetViewModel()
        
        if isValidUser() { getUser() }

        getFollows()
        
        getCollectionNfts()
        
        if typeFollows.value == nil && userViewModel.value?.id != Constant.USER_ID {
            checkFollow()
        }
    }
    
    private func getUser() {
        let userId = userViewModel.value?.id ?? Constant.USER_ID
        
        userUseCase.getUser(userId: userId, completion: { result in
            switch result {
            case .success(let user):
                self.userViewModel.value = UserViewModel.init(user: user)
                
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
                self.followers.value = users.map(UserViewModel.init)

            case .failure(let error):
                let (_, errorStr) = ErrorHelper.validateError(error: error)
                self.errorMessage.value = errorStr
            }
        })
        
        followsUseCase.getFollowing(request: request, completion: { result in
            switch result {
            case .success(let users):
                self.following.value = users.map(UserViewModel.init)

            case .failure(let error):
                let (_, errorStr) = ErrorHelper.validateError(error: error)
                self.errorMessage.value = errorStr
            }
        })
    }
    
    func getCollectionNfts() {
        isLoading.value = true

        let userId = userViewModel.value?.id ?? Constant.USER_ID
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
        
        let nfts = nfts.map(NftViewModel.init)
        
        collectionNfts.value += nfts
        
        if collectionNfts.value.isEmpty {
            self.errorMessage.value = NSLocalizedString("Collection is empty", comment: "")
        }
    }
    
    func didSelectItem(at index: Int, completion: @escaping (NftViewModel) -> Void) {
        let viewModel = collectionNfts.value[index]
        
        completion(viewModel)
    }
    
    func updateAvatar(request: UpdateAvatarRequest, completion: @escaping (Result<Bool, Error>) -> Void) {
        userUseCase.updateAvatar(request: request, completion: completion)
    }
    
    func manageSubscribeDidTap(isFollow: Bool, completion: @escaping (Bool) -> Void) {
        guard let userId = userViewModel.value?.id else { return }

        if typeFollows.value == TypeFollows.none || typeFollows.value == TypeFollows.followers {
            followsUseCase.follow(userId: userId, completion: { result in
                switch result {
                case .success:
                    self.typeFollows.value = .following
                    completion(true)

                case .failure:
                    completion(false)
                }
            })
        }
        
        if typeFollows.value == TypeFollows.following {
            followsUseCase.unfollow(userId: userId, completion: { result in
                switch result {
                case .success:
                    self.typeFollows.value = TypeFollows.none
                    completion(true)

                case .failure:
                    completion(false)
                }
            })
        }
    }
    
    func checkFollow() {
        guard let userId = userViewModel.value?.id else { return }
        
        followsUseCase.checkFollow(userId: userId, completion: { result in
            switch result {
            case .success(let typeFollows):
                self.typeFollows.value = typeFollows
                
            case .failure(let error):
                let (_, errorStr) = ErrorHelper.validateError(error: error)
                self.errorMessage.value = errorStr
            }
        })
    }
    
    func userImageDidTap(completion: @escaping (Bool) -> Void) {
        completion(userViewModel.value?.id == Constant.USER_ID)
    }
    
    private func isValidUser() -> Bool {
        return userViewModel.value == nil ||
        userViewModel.value?.id == nil ||
        userViewModel.value?.login == nil ||
        userViewModel.value?.login == ""
    }
    
    private func resetViewModel() {
        currentPage = 1
        totalPageCount = 1
        collectionNfts.value.removeAll()
        followers.value.removeAll()
        following.value.removeAll()
    }
    
}
