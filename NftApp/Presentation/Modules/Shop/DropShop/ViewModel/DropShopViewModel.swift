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
    
    func didSelectInfluencers(at index: Int, completion: @escaping ([UserViewModel]) -> Void)
    
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
    var isLoading: Observable<Bool> = Observable(false)
    var errorMessage: Observable<String?> = Observable(nil)
    
    init() {
        dropShopUseCase = DropShopUseCaseImpl()
        userUseCase = UserUseCaseImpl()
    }
    
    func viewDidLoad() {
        resetViewModel()
        
        getEditions()
        
        getInfluencers()
    }

    private func getEditions() {
        self.isLoading.value = true
        
        let request = GetEditionsRequest()
        
        dropShopUseCase.getEditions(request: request, completion: { result in
            switch result {
            case .success(let editions):
                self.appendEditions(editions: editions)

            case .failure(let error):
                let (_, errorStr) = ErrorHelper.validateError(error: error)
                self.errorMessage.value = errorStr
            }

            self.isLoading.value = false
        })
    }
    
    private func getInfluencers() {
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
    
    private func appendEditions(editions: [Edition]) {
//        currentPage = page.page
//        totalPageCount = page.totalPages
        
        let editions = editions.map(EditionViewModel.init)
        
        items.value += editions
        
        if items.value.isEmpty {
            self.errorMessage.value = NSLocalizedString("Drop Shop is empty", comment: "")
        }
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
    
    func didSelectInfluencers(at index: Int, completion: @escaping ([UserViewModel]) -> Void) {
        completion(influencers.value)
    }
    
    private func resetViewModel() {
        currentPage = 1
        totalPageCount = 1
        items.value.removeAll()
        influencers.value.removeAll()
    }
    
}
