//
//  DropShopUseCase.swift
//  DropShopUseCase
//
//  Created by Yegor on 25.08.2021.
//

import Foundation

protocol DropShopUseCase {
    
    func getEditions(request: GetEditionsRequest, completion: @escaping (Result<[Nft], Error>) -> Void)
    
    func buyNft(editionId: Int, completion: @escaping (Result<Bool, Error>) -> Void)
    
}

final class DropShopUseCaseImpl: DropShopUseCase {
    
    private let repository: DropShopRepository?
    
    init() {
        self.repository = DropShopRepositoryImpl()
    }
    
    func getEditions(request: GetEditionsRequest, completion: @escaping (Result<[Nft], Error>) -> Void) {

        repository?.getEditions(request: request, completion: { result in
            switch result {
                case .success(let resp) : do {
                    print("success \(resp)")
                    
                    let editions = resp.nfts.map {
                        Nft(id: $0.id,
                            price: $0.price,
                            serialNumber: $0.serialNumber,
                            isForCell: $0.isForCell,
                            edition: NftEdition(id: $0.edition.id,
                                                influencerId: $0.edition.influencerId,
                                                count: $0.edition.count,
                                                name: $0.edition.name,
                                                description: $0.edition.description,
                                                date: $0.edition.date,
                                                price: $0.edition.price,
                                                dateExpiration: $0.edition.dateExpiration,
                                                mediaUrl: $0.edition.mediaUrl)
                        )
                    }
                    
                    completion(.success(editions))
                }
                
                case .failure(let error) : do {
                    completion(.failure(error))
                }
            }
        })
    }
    
    func buyNft(editionId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {

        repository?.buyNft(editionId: editionId, completion: { result in
            switch result {
                case .success(let resp) : do {
                    print("success \(resp)")
                }
                
                case .failure(let error) : do {
                    completion(.failure(error))
                }
            }
        })
    }
    
}

struct GetEditionsRequest {
    var page: Int = 0
}
