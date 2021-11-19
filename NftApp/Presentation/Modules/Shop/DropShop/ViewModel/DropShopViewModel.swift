//
//  DropShopViewModel.swift
//  NftApp
//
//  Created by Yegor on 14.07.2021.
//

import Foundation

protocol DropShopViewModel : BaseViewModel {
    
    var items: Observable<[EditionViewModel]> { get }
    var influencers: Observable<[UserViewModel]> { get }
    
    func viewDidLoad()
    
    func didSelectItem(at index: Int, completion: @escaping (EditionViewModel) -> Void)
    
    func didSelectInfluencers(completion: @escaping ([UserViewModel]) -> Void)
    
    func didSelectInfluencer(at index: Int, completion: @escaping (UserViewModel) -> Void)
    
}

class DropShopViewModelImpl: DropShopViewModel {
    
    private let dropShopUseCase: DropShopUseCase
    private let userUseCase: UserUseCase
    
    private var query: String = ""
    private var currentPage: Int = 1
    private var totalPageCount: Int = 1
    var items: Observable<[EditionViewModel]> = Observable([])
    var influencers: Observable<[UserViewModel]> = Observable([])
    var reloadItems: (() -> Void)?
    var isLoading: Observable<Bool> = Observable(false)
    var errorMessage: Observable<String?> = Observable(nil)
    
    init() {
        dropShopUseCase = DropShopUseCaseImpl()
        userUseCase = UserUseCaseImpl()
        
        NftObject.isDropshopNeedRefresh.observe(on: self) { [weak self] isNeed in
            if isNeed { self?.viewDidLoad() }
        }
    }
    
    func viewDidLoad() {
        if !isLoading.value {
            
            isLoading.value = true
            
            getEditions()
            
            getInfluencers()
        }
    }

    private func getEditions() {
        let request = GetEditionsRequest()
        
        dropShopUseCase.getEditions(request: request, completion: { result in
            switch result {
            case .success(let editions):
                self.currentPage = 1
                self.totalPageCount = 1
                self.items.value.removeAll()
                
                self.appendEditions(editions: editions)
                
                NftObject.isDropshopNeedRefresh.value = false

            case .failure(let error):
                let (httpCode, errorStr) = ErrorHelper.validateError(error: error)
                if httpCode != HttpCode.notFound {
                    self.errorMessage.value = errorStr
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isLoading.value = false
            }
            
        })
    }
    
    private func getInfluencers() {
        userUseCase.getInfluencers { result in
            switch result {
            case .success(let influencers):
                self.influencers.value = influencers.map(UserViewModel.init)

            case .failure: break
            }
        }
    }
    
    private func appendEditions(editions: [Edition]) {
//        currentPage = page.page
//        totalPageCount = page.totalPages
        
        let editions = editions.map(EditionViewModel.init)
        
        items.value += editions
    }
    
    func didSelectItem(at index: Int, completion: @escaping (EditionViewModel) -> Void) {
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
    
    func didSelectInfluencers(completion: @escaping ([UserViewModel]) -> Void) {
        completion(influencers.value)
    }
    
}
