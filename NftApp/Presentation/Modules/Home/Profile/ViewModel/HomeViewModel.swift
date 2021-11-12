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
    var typeFollows: Observable<(TypeFollows?, TypeFollows?)> { get }
    
    func viewDidLoad(isRefresh: Bool)
            
    func didSelectItem(at index: Int, completion: @escaping (NftViewModel) -> Void)
    
    func manageSubscribeDidTap(completion: @escaping (Bool) -> Void)
    
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
    var typeFollows: Observable<(TypeFollows?, TypeFollows?)> = Observable((nil, nil))
    var isLoading: Observable<Bool> = Observable(false)
    var errorMessage: Observable<String?> = Observable(nil)
    
    init() {
        userUseCase = UserUseCaseImpl()
        followsUseCase = FollowsUseCaseImpl()
        nftUserCase = NftUseCaseImpl()
        
        // set main user by default 
        UserObject.user.bind {
            self.userViewModel.value = $0
        }
    }
    
    func viewDidLoad(isRefresh: Bool) {
        if !isLoading.value {
            
            isLoading.value = true
            
            if isInvalidUser() || isRefresh { getUser() }

            getFollows()
            
            getCollectionNfts()
            
            if userViewModel.value?.id != Constant.USER_ID { checkFollow() }
            
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

            case .failure: break
            }
        })
        
        followsUseCase.getFollowing(request: request, completion: { result in
            switch result {
            case .success(let users):
                self.following.value = users.map(UserViewModel.init)

            case .failure: break
            }
        })
    }
    
    func getCollectionNfts() {
        let userId = userViewModel.value?.id ?? Constant.USER_ID
        let request = GetNftsRequest(userId: userId, page: page)
        
        nftUserCase.getNfts(request: request) { result in
            switch result {
            case .success(let nfts):
                self.currentPage = 1
                self.totalPageCount = 1
                self.collectionNfts.value.removeAll()
                
                self.appendNfts(nfts: nfts)
                
            case .failure(let error):
                let (httpCode, errorStr) = ErrorHelper.validateError(error: error)
                if httpCode != HttpCode.notFound {
                    self.errorMessage.value = errorStr
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isLoading.value = false
            }
            
        }
    }
    
    private func appendNfts(nfts: [Nft]) {
//        currentPage = page.page
//        totalPageCount = page.totalPages
        
        let nfts = nfts.map(NftViewModel.init)

        collectionNfts.value += nfts
    }
    
    func didSelectItem(at index: Int, completion: @escaping (NftViewModel) -> Void) {
        let viewModel = collectionNfts.value[index]
        
        completion(viewModel)
    }
    
    func updateAvatar(request: UpdateAvatarRequest, completion: @escaping (Result<Bool, Error>) -> Void) {
        userUseCase.updateAvatar(request: request, completion: completion)
    }
    
    func manageSubscribeDidTap(completion: @escaping (Bool) -> Void) {
        guard let userId = userViewModel.value?.id else {
            completion(false)
            return
        }

        let (me, user) = typeFollows.value

        if me == TypeFollows.none {
            followsUseCase.follow(userId: userId, completion: { result in
                switch result {
                case .success:
                    self.typeFollows.value = (TypeFollows.followers, user)
                    completion(true)

                case .failure:
                    completion(false)
                }
            })
        }
        
        if me == TypeFollows.followers {
            followsUseCase.unfollow(userId: userId, completion: { result in
                switch result {
                case .success:
                    self.typeFollows.value = (TypeFollows.none, user)
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
    
    private func isInvalidUser() -> Bool {
        return userViewModel.value == nil ||
        userViewModel.value?.id == nil ||
        userViewModel.value?.login == nil ||
        userViewModel.value?.login == ""
    }
    
}
