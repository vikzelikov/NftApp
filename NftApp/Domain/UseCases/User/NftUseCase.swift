//
//  NftUseCase.swift
//  NftApp
//
//  Created by Yegor on 25.09.2021.
//

import Foundation

protocol NftUseCase {
    
    func getNfts(request: GetNftsRequest, completion: @escaping (Result<[Nft], Error>) -> Void)
        
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
                    let nfts = resp.rows.map {
                        Nft(id: $0.id,
                            lastPrice: $0.lastPrice,
                            currentPrice: $0.currentPrice,
                            serialNumber: $0.serialNumber,
                            isForSell: $0.isForSell,
                            edition: Edition(
                                id: $0.id,
                                influencerId: $0.edition.influencerId,
                                count: $0.edition.count,
                                name: $0.edition.name,
                                description: $0.edition.description,
                                price: $0.edition.price,
                                dateExpiration: $0.edition.dateExpiration,
                                mediaUrl: $0.edition.mediaUrl,
                                countNFTs: Int($0.edition.countNFTs ?? "0") ?? 0,
                                influencer: EditionInfluencer(
                                    id: $0.edition.influencer.id,
                                    user: EditionUser(
                                        id: $0.edition.influencer.user.id,
                                        login: $0.edition.influencer.user.login,
                                        avatarUrl: $0.edition.influencer.user.avatarUrl
                                    )
                                )
                            )
                        )
                    }

                    completion(.success(nfts))
                }
                
                case .failure(let error) : do {
                    completion(.failure(error))
                }
            }
        })
    }
    
}

struct GetNftsRequest {
    var userId: Int = 0
    var page: Int = 0
}
