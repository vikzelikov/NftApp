//
//  DropShopViewModel.swift
//  NftApp
//
//  Created by Yegor on 14.07.2021.
//

import Foundation

protocol DropShopViewModel : BaseViewModel {
    
    var items: Observable<[NftViewModel]> { get }
    var influencers: Observable<[UserViewModel]> { get }
    
    func getEditions()

    func getInfluencers()
    
    func didSelectItem(at index: Int, completion: @escaping (NftViewModel) -> Void)
    
    func didSelectInfluencer(at index: Int, completion: @escaping (UserViewModel) -> Void)
    
}

class DropShopViewModelImpl: DropShopViewModel {
    
    private let dropShopUseCase: DropShopUseCase
    private let userUseCase: UserUseCase
    
    private var query: String = ""
    private var currentPage: Int = 1
    private var totalPageCount: Int = 1
    var items: Observable<[NftViewModel]> = Observable([])
    var influencers: Observable<[UserViewModel]> = Observable([])
    var isLoading: Observable<Bool> = Observable(false)
    var errorMessage: Observable<String?> = Observable(nil)
    
    init() {
        dropShopUseCase = DropShopUseCaseImpl()
        userUseCase = UserUseCaseImpl()
    }

    func getEditions() {
        self.isLoading.value = true
        
        let request = GetEditionsRequest()
        
        dropShopUseCase.getEditions(request: request, completion: { result in
            switch result {
            case .success(let nfts):
                self.appendEditions(nfts: nfts)

            case .failure(let error):
                let (_, errorStr) = ErrorHelper.validateError(error: error)
                self.errorMessage.value = errorStr
            }

            self.isLoading.value = false
        })
    }
    
    func getInfluencers() {
        self.isLoading.value = true
        
        userUseCase.getInfluencers { result in
            switch result {
            case .success(let influencers):
                self.influencers.value = influencers.map(UserViewModel.init)

            case .failure(let error):
                let (_, errorStr) = ErrorHelper.validateError(error: error)
                self.errorMessage.value = errorStr
            }

            self.isLoading.value = false
        }
    }
    
    private func appendEditions(nfts: [Nft]) {
//        currentPage = page.page
//        totalPageCount = page.totalPages
        
        let nftEditions = nfts.map(NftViewModel.init)
        
        items.value += nftEditions
        
        if items.value.isEmpty {
            self.errorMessage.value = NSLocalizedString("Drop Shop is empty", comment: "")
        }
    }
    
    private func resetPages() {
        currentPage = 1
        totalPageCount = 1
        items.value.removeAll()
    }
    
    func didSelectItem(at index: Int, completion: @escaping (NftViewModel) -> Void) {
        if items.value.indices.contains(index) {
            let viewModel = items.value[index]
            
            completion(viewModel)
        }
    }
    
    func didSelectInfluencer(at index: Int, completion: @escaping (UserViewModel) -> Void) {
        if influencers.value.indices.contains(index) {
            let viewModel = influencers.value[index]
            
            completion(viewModel)
        }
    }
    
}
