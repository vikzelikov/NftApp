//
//  DropShopUseCase.swift
//  DropShopUseCase
//
//  Created by Yegor on 25.08.2021.
//

import Foundation

protocol DropShopUseCase {
    
    func getEditions(request: GetEditionsRequest, completion: @escaping (Result<[Edition], Error>) -> Void)
    
    func buyNft(editionId: Int, completion: @escaping (Result<Bool, Error>) -> Void)
    
}

final class DropShopUseCaseImpl: DropShopUseCase {
    
    private let repository: DropShopRepository?
    
    init() {
        self.repository = DropShopRepositoryImpl()
    }
    
    func getEditions(request: GetEditionsRequest, completion: @escaping (Result<[Edition], Error>) -> Void) {

        repository?.getEditions(request: request, completion: { result in
            switch result {
                case .success(let resp) : do {                    
                    let editions = resp.rows.map {
                        Edition(id: $0.id,
                                influencerId: $0.influencerId,
                                count: $0.count,
                                name: $0.name,
                                description: $0.description,
                                price: $0.price,
                                dateExpiration: $0.dateExpiration,
                                mediaUrl: $0.mediaUrl)
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
