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
    
    private let repository: UserRepository
    private let userStorage: UserStorage
    
    init(repository: UserRepository = UserRepositoryImpl(), userStorage: UserStorage = UserStorageImpl()) {
        self.repository = repository
        self.userStorage = userStorage
    }
    
    func getNfts(request: GetNftsRequest, completion: @escaping (Result<[Nft], Error>) -> Void) {
        repository.getNfts(request: request, completion: { result in
            switch result {
            case .success(let resp) : do {
                let nfts = resp.rows.map { Nft.init(nft: $0) }

                completion(.success(nfts))
            }
            
            case .failure(let error) : do {
                completion(.failure(error))
            }
            }
        })
    }
    
    func getCreatedNfts(influencerId: Int, completion: @escaping (Result<[Edition], Error>) -> Void) {
        repository.getInfluencer(influencerId: influencerId, completion: { result in
            switch result {
            case .success(let resp) : do {
                if let editionsDTO = resp.editions {
                    let editions = editionsDTO.map { Edition.init(edition: $0) }

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
    
}

struct GetNftsRequest {
    
    var userId: Int = 0
    var page: Int = 0
    var type: TypeListNfts = .collection
    
}
