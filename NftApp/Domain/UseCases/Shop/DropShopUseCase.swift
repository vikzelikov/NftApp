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
    
    private let repository: DropShopRepository
    
    init(repository: DropShopRepository = DropShopRepositoryImpl()) {
        self.repository = repository
    }
    
    func getEditions(request: GetEditionsRequest, completion: @escaping (Result<[Edition], Error>) -> Void) {
        repository.getEditions(request: request) { result in
            switch result {
                case .success(let resp) : do {                    
                    let editions = resp.rows.map { Edition.init(edition: $0) }
                    
                    completion(.success(editions))
                }
                
                case .failure(let error) : do {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func getEdition(editionId: Int, completion: @escaping (Result<Edition, Error>) -> Void) {
        repository.getEdition(editionId: editionId) { result in
            switch result {
                case .success(let editionDTO) : do {
                    let edition = Edition.init(edition: editionDTO)
                    
                    completion(.success(edition))
                }
                
                case .failure(let error) : do {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func buyNft(editionId: Int, completion: @escaping (Result<Bool, Error>) -> Void) {
        repository.buyNft(editionId: editionId) { result in
            switch result {
                case .success: do {
                    completion(.success(true))
                }
                
                case .failure(let error) : do {
                    completion(.failure(error))
                }
            }
        }
    }
    
}

struct GetEditionsRequest {
    
    var page: Int = 0
    
}
