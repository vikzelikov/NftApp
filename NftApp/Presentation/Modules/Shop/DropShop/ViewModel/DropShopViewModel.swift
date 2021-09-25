//
//  DropShopViewModel.swift
//  NftApp
//
//  Created by Yegor on 14.07.2021.
//

import Foundation

protocol DropShopViewModel : BaseViewModel {
    
    var items: Observable<[NftCellViewModel]> { get }
    
    func getEditions()
    
    func didSelectItem(at index: Int, completion: @escaping (NftCellViewModel) -> Void)
    
}

class DropShopViewModelImpl: DropShopViewModel {
    
    private let dropShopUseCase: DropShopUseCase
    
    private var query: String = ""
    private var currentPage: Int = 1
    private var totalPageCount: Int = 1
    var items: Observable<[NftCellViewModel]> = Observable([])
    var isLoading: Observable<Bool> = Observable(false)
    var errorMessage: Observable<String?> = Observable(nil)
    
    init() {
        dropShopUseCase = DropShopUseCaseImpl()
    }

    func getEditions() {
        self.isLoading.value = true
        
        let request = GetEditionsRequest()
        
        dropShopUseCase.getEditions(request: request, completion: { result in
            switch result {
            case .success(let nfts):
                self.appendEditions(nfts: nfts)

            case .failure(let error):
                if let error = error as? ErrorMessage, let code = error.code {
                    switch code {
                    case let c where c >= HttpCode.internalServerError:
                        self.errorMessage.value = NSLocalizedString("defaultError", comment: "")
                    case HttpCode.badRequest:
                        let message = error.errorDTO?.message
                        self.errorMessage.value = message
                    default:
                        self.errorMessage.value = NSLocalizedString("defaultError", comment: "")
                    }
                }
            }

            self.isLoading.value = false
        })
    }
    
    private func appendEditions(nfts: [Nft]) {
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
