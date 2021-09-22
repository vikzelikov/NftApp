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
        
        items.value.append(NftCellViewModel(id: 0, price: 0.0, serialNumber: 0, isForCell: false, edition: EditionCellViewModel(id: 0, influencerId: 0, count: 9, name: "NFT #1", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, price: 500, dateExpiration: nil, mediaUrl: "https://sun9-64.userapi.com/impg/b6b8-4ek3-HAYctsvHRXcpPPMNOsmW_dGq418g/dZ2rmaBjGdM.jpg?size=1080x1080&quality=96&sign=cff5e3de07aff007fa4e9f091737da4d&type=album")))
        
        items.value.append(NftCellViewModel(id: 0, price: 0.0, serialNumber: 0, isForCell: false, edition: EditionCellViewModel(id: 0, influencerId: 0, count: 9, name: "NFT #2", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, price: 500, dateExpiration: nil, mediaUrl: "https://sun9-13.userapi.com/impg/RnIxGWvqxgaaigGE6qa8biwFt941LsmD48c7KQ/FJsXIqTSPag.jpg?size=1080x1080&quality=96&sign=df30af1f666f0db0cce43e5fd08b62ed&type=album")))
        
        items.value.append(NftCellViewModel(id: 0, price: 0.0, serialNumber: 0, isForCell: false, edition: EditionCellViewModel(id: 0, influencerId: 0, count: 9, name: "NFT #3", description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry", date: nil, price: 500, dateExpiration: nil, mediaUrl: "https://sun9-75.userapi.com/impg/WH1eWaouXisW-LsvaOBAQFqcxlhZqNll5caF7w/cAbqcwEVRXM.jpg?size=1080x1080&quality=96&sign=3a1d6db8a95833baed6530f1ecfcfa3a&type=album")))
        
//        let request = GetEditionsRequest()
        
//        dropShopUseCase.getEditions(request: request, completion: { result in
//            switch result {
//            case .success(let nfts):
//                self.appendEditions(nfts: nfts)
//
//            case .failure(let error):
//                if let error = error as? ErrorMessage, let code = error.code {
//                    switch code {
//                    case let c where c >= HttpCode.internalServerError:
//                        self.errorMessage.value = NSLocalizedString("defaultError", comment: "")
//                    case HttpCode.badRequest:
//                        let message = error.errorDTO?.message
//                        self.errorMessage.value = message
//                    default:
//                        self.errorMessage.value = NSLocalizedString("defaultError", comment: "")
//                    }
//                }
//            }
//
//            self.isLoading.value = false
//        })
    }
    
    private func appendEditions(nfts: [Nft]) {
//        currentPage = page.page
//        totalPageCount = page.totalPages
        
        let nftEditions = nfts.map(NftCellViewModel.init)
        
        items.value += nftEditions
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
