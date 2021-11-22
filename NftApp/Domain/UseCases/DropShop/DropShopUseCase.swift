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
                    let editions = resp.rows.map { self.mapEdition(edition: $0) }
                    
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
                    let editions = self.mapEdition(edition: resp)
                    
                    completion(.success(editions))
                }
                
                case .failure(let error) : do {
                    completion(.failure(error))
                }
            }
        })
    }
    
    private func mapEdition(edition: EditionDTO) -> Edition {
        var influencer: EditionInfluencer?
        if let infl = edition.influencer {
            influencer = EditionInfluencer(
               id: infl.id,
               user: EditionUser(
                   id: infl.user.id,
                   login: infl.user.login,
                   avatarUrl: infl.user.avatarUrl
               )
            )
        }
        
        return Edition(
            id: edition.id,
            influencerId: edition.influencerId,
            count: edition.count ?? 0,
            name: edition.name,
            description: edition.description,
            price: edition.price,
            dateExpiration: edition.dateExpiration ?? "0" ,
            mediaUrl: edition.mediaUrl,
            countNFTs: edition.countNFTs ?? 0,
            influencer: influencer
        )
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
