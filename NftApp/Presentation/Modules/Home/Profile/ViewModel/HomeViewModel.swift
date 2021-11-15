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
    var itemsNfts: Observable<[NftViewModel]> { get }
    var typeFollows: Observable<(TypeFollows?, TypeFollows?)> { get }
    var typeListNfts: Observable<TypeListNfts> { get }
    func viewDidLoad(isRefresh: Bool)
            
    func didSelectItem(at index: Int, completion: @escaping (NftViewModel) -> Void)
    
    func manageSubscribeDidTap(completion: @escaping (Bool) -> Void)
    
    func userImageDidTap(completion: @escaping (Bool) -> Void)
    
    func updateAvatar(request: UpdateAvatarRequest, completion: @escaping (Result<Bool, Error>) -> Void)
    
    func selectListDidTap(typeListNfts: TypeListNfts)
    
}

enum TypeListNfts {
    case collection
    case observables
    case created
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
    var itemsNfts: Observable<[NftViewModel]> = Observable([])
    var collectionNfts: [NftViewModel] = []
    var observablesNfts: [NftViewModel] = []
    var createdNfts: [NftViewModel] = []
    var typeFollows: Observable<(TypeFollows?, TypeFollows?)> = Observable((nil, nil))
    var typeListNfts: Observable<TypeListNfts> = Observable(.collection)
    var isLoading: Observable<Bool> = Observable(false)
    var errorMessage: Observable<String?> = Observable(nil)
    
    init() {
        userUseCase = UserUseCaseImpl()
        followsUseCase = FollowsUseCaseImpl()
        nftUserCase = NftUseCaseImpl()
        
        // set main user by default
        userViewModel.value = UserObject.user.value
        
        UserObject.isNeedRefresh.observe(on: self) { [weak self] isNeed in
            if isNeed && self?.userViewModel.value?.id == Constant.USER_ID {
                self?.viewDidLoad(isRefresh: true)
            }
        }
    }
    
    func viewDidLoad(isRefresh: Bool) {
        if !isLoading.value {
            
            isLoading.value = true
            
            if isInvalidUser() || isRefresh { getUser() }

            getFollows()
            
            getCollectionNfts()
            
            getObservablesNfts()
            
            getCreatedNfts()
            
            if userViewModel.value?.id != Constant.USER_ID { checkFollow() }
            
        }
    }
    
    private func getUser() {
        let userId = userViewModel.value?.id ?? Constant.USER_ID

        userUseCase.getUser(userId: userId, completion: { result in
            switch result {
            case .success(let user):
                self.userViewModel.value = UserViewModel.init(user: user)
                
                if self.userViewModel.value?.id == Constant.USER_ID {
                    UserObject.user.value = self.userViewModel.value
                    UserObject.isNeedRefresh.value = false
                }
                
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

            case .failure:
                self.followers.value.removeAll()
            }
        })
        
        followsUseCase.getFollowing(request: request, completion: { result in
            switch result {
            case .success(let users):
                self.following.value = users.map(UserViewModel.init)

            case .failure:
                self.following.value.removeAll()
            }
        })
    }
    
    func getCollectionNfts() {
        let userId = userViewModel.value?.id ?? Constant.USER_ID
        let request = GetNftsRequest(userId: userId, page: page)
        
        nftUserCase.getCollectionNfts(request: request) { result in
            switch result {
            case .success(let nfts):
                self.currentPage = 1
                self.totalPageCount = 1
                self.collectionNfts.removeAll()
                
                self.appendNfts(nfts: nfts, typeListNfts: .collection)
                
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
    
    func getObservablesNfts() {
        let userId = 2
        let request = GetNftsRequest(userId: userId, page: page)
        
        nftUserCase.getObservablesNfts(request: request) { result in
            switch result {
            case .success(let nfts):
                self.currentPage = 1
                self.totalPageCount = 1
                self.observablesNfts.removeAll()
                
                self.appendNfts(nfts: nfts, typeListNfts: .observables)
                
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
    
    func getCreatedNfts() {
        let userId = userViewModel.value?.id ?? Constant.USER_ID
        let request = GetNftsRequest(userId: userId, page: page)

        nftUserCase.getCreatedNfts(request: request) { result in
            switch result {
            case .success(let nfts):
                self.currentPage = 1
                self.totalPageCount = 1
                self.createdNfts.removeAll()

                self.appendNfts(nfts: nfts, typeListNfts: .created)

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
    
    private func appendNfts(nfts: [Nft], typeListNfts: TypeListNfts) {
//        currentPage = page.page
//        totalPageCount = page.totalPages
        
        switch typeListNfts {
        case .collection:
            let nfts = nfts.map(NftViewModel.init)
            collectionNfts += nfts
            
            // default select
            if self.typeListNfts.value == .collection {
                self.itemsNfts.value = collectionNfts
            }
            
        case .observables:
            let nfts = nfts.map(NftViewModel.init)
            observablesNfts += nfts
            
        case .created:
            let nfts = nfts.map(NftViewModel.init)
            createdNfts += nfts
        }
    }
    
    func didSelectItem(at index: Int, completion: @escaping (NftViewModel) -> Void) {
        if collectionNfts.indices.contains(index) {
            let viewModel = collectionNfts[index]
            
            completion(viewModel)
        }
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
                    UserObject.isNeedRefresh.value = true
                    self.followers.value.append(UserViewModel(id: 0))
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
                    UserObject.isNeedRefresh.value = true
                    self.followers.value.removeLast()
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
    
    func selectListDidTap(typeListNfts: TypeListNfts) {
        self.typeListNfts.value = typeListNfts
        
        switch typeListNfts {
        case .collection:
            itemsNfts.value = collectionNfts
        case .observables:
            itemsNfts.value = observablesNfts
        case .created:
            itemsNfts.value = createdNfts
        }
    }
    
    private func isInvalidUser() -> Bool {
        return userViewModel.value == nil ||
        userViewModel.value?.id == nil ||
        userViewModel.value?.login == nil ||
        userViewModel.value?.login == ""
    }
    
}
