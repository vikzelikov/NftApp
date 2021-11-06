//
//  DropShopUseCase.swift
//  DropShopUseCase
//
//  Created by Yegor on 25.08.2021.
//

import Foundation

protocol DropShopUseCase {
    
    func getEditions(request: GetEditionsRequest, completion: @escaping (Result<[Edition], Error>) -> Void)
    
    func getEdition(editionId: Int, completion: @escaping (Result<Edition, Error>) -> Void)
    
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
                                mediaUrl: $0.mediaUrl,
                                countNFTs: Int($0.countNFTs ?? "0") ?? 0,
                                influencer: EditionInfluencer(
                                    id: $0.influencer.id,
                                    user: EditionUser(
                                        id: $0.influencer.user.id,
                                        login: $0.influencer.user.login,
                                        avatarUrl: $0.influencer.user.avatarUrl
                                    )
                                )
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
    
    func getEdition(editionId: Int, completion: @escaping (Result<Edition, Error>) -> Void) {
        repository?.getEdition(editionId: editionId, completion: { result in
            switch result {
                case .success(let resp) : do {
                    let editions = Edition(id: resp.id,
                                influencerId: resp.influencerId,
                                count: resp.count,
                                name: resp.name,
                                description: resp.description,
                                price: resp.price,
                                dateExpiration: resp.dateExpiration,
                                mediaUrl: resp.mediaUrl,
                                countNFTs: Int(resp.countNFTs ?? "0") ?? 0,
                                influencer: EditionInfluencer(
                                   id: resp.influencer.id,
                                   user: EditionUser(
                                       id: resp.influencer.user.id,
                                       login: resp.influencer.user.login,
                                       avatarUrl: resp.influencer.user.avatarUrl
                                   )
                                )
                    )
                    
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
                case .success: do {
                    completion(.success(true))
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
