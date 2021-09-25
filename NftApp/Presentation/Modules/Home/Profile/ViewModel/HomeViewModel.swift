//
//  HomeViewModel.swift
//  NftApp
//
//  Created by Yegor on 25.09.2021.
//

import Foundation

protocol HomeViewModel: BaseViewModel {
    
    var items: Observable<[NftCellViewModel]> { get }
    
    func getCollectionNfts()
    
    func didSelectItem(at index: Int, completion: @escaping (NftCellViewModel) -> Void)
    
}

class HomeViewModelImpl: HomeViewModel {
    
    private let userUseCase: UserUseCase
    private let nftUserCase: NftUseCase
    
    private var getNftsRequest = GetNftsRequest() {
        didSet {
            page = getNftsRequest.page
        }
    }

    private var page = 1
    private var currentPage: Int = 1
    private var totalPageCount: Int = 1
    var items: Observable<[NftCellViewModel]> = Observable([])
    var isLoading: Observable<Bool> = Observable(true)
    var errorMessage: Observable<String?> = Observable(nil)
    
    init() {
        userUseCase = UserUseCaseImpl()
        nftUserCase = NftUseCaseImpl()
    }
    
    func getCollectionNfts() {
        isLoading.value = true
        
        nftUserCase.getNfts(request: getNftsRequest) { result in
            switch result {
            case .success:
                print("ok")
            case .failure(let error):
                if let error = error as? ErrorMessage, let code = error.code {
                    switch code {
                    case let c where c >= HttpCode.internalServerError:
                        self.errorMessage.value = NSLocalizedString("defaultError", comment: "")
                        break
                    case let c where c >= HttpCode.badRequest:
                        let message = error.errorDTO?.message
                        self.errorMessage.value = message
                        break
                    default:
                        self.errorMessage.value = NSLocalizedString("defaultError", comment: "")
                    }
                } else {
                    self.errorMessage.value = NSLocalizedString("defaultError", comment: "")
                }
            }
            
            self.isLoading.value = false
            
        }
    }
    
    private func getUser() {
        userUseCase.getUser(completion: { result in
            switch result {
            case .success:
                print("ok")
            case .failure(let error):
                if let error = error as? ErrorMessage, let code = error.code {
                    switch code {
                    case let c where c >= HttpCode.internalServerError:
                        self.errorMessage.value = NSLocalizedString("defaultError", comment: "")
                        break
                    case let c where c >= HttpCode.badRequest:
                        let message = error.errorDTO?.message
                        self.errorMessage.value = message
                        break
                    default:
                        self.errorMessage.value = NSLocalizedString("defaultError", comment: "")
                    }
                } else {
                    self.errorMessage.value = NSLocalizedString("defaultError", comment: "")
                }
            }
        })
    }
    
    private func appendNfts(nfts: [Nft]) {
//        currentPage = page.page
//        totalPageCount = page.totalPages
        
        let nftEditions = nfts.map(NftCellViewModel.init)
        
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
    
    func didSelectItem(at index: Int, completion: @escaping (NftCellViewModel) -> Void) {
        let viewModel = items.value[index]
        
        completion(viewModel)
    }
    
}
