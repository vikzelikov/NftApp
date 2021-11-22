//
//  NftUseCase.swift
//  NftApp
//
//  Created by Yegor on 25.09.2021.
//

import Foundation

protocol NftUseCase {
            
    func getNfts(request: GetNftsRequest, completion: @escaping (Result<[Nft], Error>) -> Void)

    func getCreatedNfts(influencerId: Int, completion: @escaping (Result<[Edition], Error>) -> Void)
    
}

final class NftUseCaseImpl: NftUseCase {
    
    private let repository: UserRepository?
    private let userStorage: UserStorage?
    
    init() {
        self.repository = UserRepositoryImpl()
        self.userStorage = UserStorageImpl()
    }
    
    func getNfts(request: GetNftsRequest, completion: @escaping (Result<[Nft], Error>) -> Void) {
        repository?.getNfts(request: request, completion: { result in
            switch result {
                case .success(let resp) : do {
                    let nfts = self.mapNfts(response: resp)

                    completion(.success(nfts))
                }
                
                case .failure(let error) : do {
                    completion(.failure(error))
                }
            }
        })
    }
    
    func getCreatedNfts(influencerId: Int, completion: @escaping (Result<[Edition], Error>) -> Void) {
        repository?.getInfluencer(influencerId: influencerId, completion: { result in
            switch result {
                case .success(let resp) : do {
                    if let editionsDTO = resp.editions {
                        let editions = editionsDTO.map {
                            self.mapEdition(edition: $0)
                        }
                        
                        completion(.success(editions))
                    } else {
                        completion(.failure(ErrorMessage(errorType: .cancelled, errorDTO: nil, code: nil)))
                    }
                }
                
                case .failure(let error) : do {
                    completion(.failure(error))
                }
            }
        })
    }
    
    private func mapNfts(response: GetNftsResponseDTO) -> [Nft] {
        let nfts = response.rows.map {
            Nft(id: $0.id,
                lastPrice: $0.lastPrice,
                currentPrice: $0.currentPrice,
                serialNumber: $0.serialNumber,
                isForSell: $0.isForSell,
                edition: self.mapEdition(edition: $0.edition)
            )
        }
        
        return nfts
    }
    
    private func mapInfluencer(edition: EditionDTO) -> EditionInfluencer? {
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

        return influencer
    }
    
    private func mapEdition(edition: EditionDTO) -> Edition {
        let influencer = mapInfluencer(edition: edition)
        
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
    
}

struct GetNftsRequest {
    var userId: Int = 0
    var page: Int = 0
    var type: TypeListNfts = .collection
}
