//
//  DetailNftViewModel.swift
//  NftApp
//
//  Created by Yegor on 22.09.2021.
//

import Foundation

protocol DetailNftViewModel : BaseViewModel {
    
    var typeDetailNFT: TypeDetailNFT { set get }
    
    var nftViewModel: Observable<NftViewModel?> { get }
    
    func buyNftDidTap()
    
}

enum TypeDetailNFT {
    case detail
    case dropShop
    case market
}

class DetailNftViewModelImpl: DetailNftViewModel {
    
    private let dropShopUseCase: DropShopUseCase
    private let marketUserCase: MarketUseCase
    
    var typeDetailNFT: TypeDetailNFT = TypeDetailNFT.detail
    var nftViewModel: Observable<NftViewModel?> = Observable(nil)
    var isLoading: Observable<Bool> = Observable(false)
    var errorMessage: Observable<String?> = Observable(nil)
    
    init() {
        dropShopUseCase = DropShopUseCaseImpl()
        marketUserCase = MarketUseCaseImpl()
    }
    
    func buyNftDidTap() {
        self.isLoading.value = true
        
        guard let editionId = nftViewModel.value?.edition.id else { return }
        
        self.dropShopUseCase.buyNft(editionId: editionId) { result in
            switch result {
            case .success:
                print("ok!")
                
            case .failure(let error):
                self.isLoading.value = false

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
                } else {
                    self.errorMessage.value = NSLocalizedString("defaultError", comment: "")
                }
            }
            
            self.isLoading.value = false
            
        }
    }
}
    
