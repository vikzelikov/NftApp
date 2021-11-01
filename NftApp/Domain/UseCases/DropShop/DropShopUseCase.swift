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
                    let editions = resp.rows.map {
                        Nft(id: 1,
                            lastPrice: 1.0,
                            currentPrice: 1.0,
                            serialNumber: 1,
                            isForSell: false,
                            edition: NftEdition(id: $0.id,
                                                influencerId: $0.influencerId,
                                                count: $0.count,
                                                name: $0.name,
                                                description: $0.description,
                                                date: 0,
                                                price: $0.price,
                                                dateExpiration: Double($0.dateExpiration) ?? 0.0,
                                                mediaUrl: $0.mediaUrl)
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
