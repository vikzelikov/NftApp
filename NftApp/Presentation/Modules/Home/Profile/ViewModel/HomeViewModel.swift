//
//  HomeViewModel.swift
//  NftApp
//
//  Created by Yegor on 25.09.2021.
//

import Foundation

protocol HomeViewModel: BaseViewModel {
    
    var userViewModel: Observable<User?> { get }
    var followers: Observable<[User]> { get }
    var following: Observable<[User]> { get }
    var itemsNfts: Observable<[Nft]> { get }
    var typeFollows: Observable<(TypeFollows?, TypeFollows?)> { get }
    var typeListNfts: Observable<TypeListNfts> { get }
    func viewDidLoad(isRefresh: Bool)
            
    func didSelectItem(at index: Int, completion: @escaping (Nft) -> Void)
    
    func manageSubscribeDidTap(completion: @escaping (Bool) -> Void)
    
    func userImageDidTap(completion: @escaping (Bool) -> Void)
    
    func updateAvatar(request: UploadMediaRequest, completion: @escaping (Result<Bool, Error>) -> Void)
    
    func selectListDidTap(typeListNfts: TypeListNfts)
    
}

enum TypeListNfts {
    
    case collection
    case observables
    case created
    
}

final class HomeViewModelImpl: HomeViewModel {

    let userUseCase: UserUseCase
    let followsUseCase: FollowsUseCase
    let nftUserCase: NftUseCase

    var page = 1
    var currentPage: Int = 1
    var totalPageCount: Int = 1
    var userViewModel: Observable<User?> = Observable(nil)
    var followers: Observable<[User]> = Observable([])
    var following: Observable<[User]> = Observable([])
    var itemsNfts: Observable<[Nft]> = Observable([])
    var collectionNfts: [Nft] = []
    var observablesNfts: [Nft] = []
    var createdNfts: [Nft] = []
    var typeFollows: Observable<(TypeFollows?, TypeFollows?)> = Observable((nil, nil))
    var typeListNfts: Observable<TypeListNfts> = Observable(.collection)
    var isLoading: Observable<Bool> = Observable(false)
    var errorMessage: Observable<String?> = Observable(nil)
    
    init(
        userUseCase: UserUseCase = DIContainer.shared.resolve(type: UserUseCase.self),
        followsUseCase: FollowsUseCase = DIContainer.shared.resolve(type: FollowsUseCase.self),
        nftUserCase: NftUseCase = DIContainer.shared.resolve(type: NftUseCase.self)
    ) {
        self.userUseCase = userUseCase
        self.followsUseCase = followsUseCase
        self.nftUserCase = nftUserCase
        
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
                self.userViewModel.value = user
                
                self.getCreatedNfts()
                
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
                self.followers.value = users

            case .failure:
                self.followers.value.removeAll()
            }
        })
        
        followsUseCase.getFollowing(request: request, completion: { result in
            switch result {
            case .success(let users):
                self.following.value = users

            case .failure:
                self.following.value.removeAll()
            }
        })
    }
    
    func getCollectionNfts() {
        let userId = userViewModel.value?.id ?? Constant.USER_ID
        let request = GetNftsRequest(userId: userId, page: page, type: .collection)
        
        nftUserCase.getNfts(request: request) { result in
            switch result {
            case .success(let nfts):
                self.currentPage = 1
                self.totalPageCount = 1
                self.collectionNfts.removeAll()
                
                self.appendNfts(nfts: nfts, typeListNfts: .collection)
                
            case .failure(let error):
                let (httpCode, errorStr) = ErrorHelper.validateError(error: error)
                if httpCode != HTTPCode.notFound && httpCode != HTTPCode.badRequest {
                    self.errorMessage.value = errorStr
                }
            }
            
            var delay = 0.0
            if self.collectionNfts.isEmpty { delay = 1.0 }
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.isLoading.value = false
            }
        }
    }
    
    func getObservablesNfts() {
        let userId = userViewModel.value?.id ?? Constant.USER_ID
        let request = GetNftsRequest(userId: userId, page: page, type: .observables)

        nftUserCase.getNfts(request: request) { result in
            switch result {
            case .success(let nfts):
                self.currentPage = 1
                self.totalPageCount = 1
                self.observablesNfts.removeAll()

                self.appendNfts(nfts: nfts, typeListNfts: .observables)

            case .failure(let error):
                let (httpCode, errorStr) = ErrorHelper.validateError(error: error)
                if httpCode != HTTPCode.notFound && httpCode != HTTPCode.badRequest {
                    self.errorMessage.value = errorStr
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isLoading.value = false
            }
        }
    }
    
    func getCreatedNfts() {
        if let influencerId = userViewModel.value?.influencerId {
            nftUserCase.getCreatedNfts(influencerId: influencerId) { result in
                switch result {
                case .success(let editions):
                    self.createdNfts.removeAll()

                    guard let user = self.userViewModel.value else { return }
                    
                    let editions: [Edition] = editions.map { obj in
                       var obj = obj
                       obj.influencer = EditionInfluencer(
                        id: 0,
                        user: EditionUser(
                            id: user.id,
                            login: user.login ?? "",
                            avatarUrl: user.avatarUrl)
                       )
                       return obj
                    }
                    
                    self.createdNfts += editions.map {
                        let edition = $0
                        var nft = Nft(nft: .placeholder)
                        nft.edition = edition
                        return nft
                    }

                case .failure(let error):
                    let (httpCode, errorStr) = ErrorHelper.validateError(error: error)
                    if httpCode != HTTPCode.notFound && httpCode != HTTPCode.badRequest {
                        self.errorMessage.value = errorStr
                    }
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.isLoading.value = false
                }
            }
        }
    }
    
    private func appendNfts(nfts: [Nft], typeListNfts: TypeListNfts) {
//        currentPage = page.page
//        totalPageCount = page.totalPages
        
        switch typeListNfts {
        case .collection:
            collectionNfts += nfts
            
            // default select
            if self.typeListNfts.value == .collection {
                self.itemsNfts.value = collectionNfts
            }
            
        case .observables:
            observablesNfts += nfts
            
        case .created: break
            
        }
    }
    
    func didSelectItem(at index: Int, completion: @escaping (Nft) -> Void) {
        if itemsNfts.value.indices.contains(index) {
            let viewModel = itemsNfts.value[index]
            
            completion(viewModel)
        }
    }
    
    func updateAvatar(request: UploadMediaRequest, completion: @escaping (Result<Bool, Error>) -> Void) {
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
                    self.followers.value.append(User(id: 0))
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
                    if !self.followers.value.isEmpty {
                        self.followers.value.removeLast()
                    }
                    
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
