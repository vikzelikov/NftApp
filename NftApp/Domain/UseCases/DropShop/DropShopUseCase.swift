//
//  DropShopUseCase.swift
//  DropShopUseCase
//
//  Created by Yegor on 25.08.2021.
//

import Foundation

protocol DropShopUseCase {
    
    func getNfts(request: GetNftsRequest, completion: @escaping (Result<Bool, Error>) -> Void)
    
    func buyNft(request: BuyNftRequest, completion: @escaping (Result<Bool, Error>) -> Void)
    
}

final class DropShopUseCaseImpl: DropShopUseCase {
    
    private let repository: DropShopRepository?
    
    init() {
        self.repository = DropShopRepositoryImpl()
    }
    
    func getNfts(request: GetNftsRequest, completion: @escaping (Result<Bool, Error>) -> Void) {

        repository?.getNfts(request: request, completion: { result in
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
    
    func buyNft(request: BuyNftRequest, completion: @escaping (Result<Bool, Error>) -> Void) {

        repository?.buyNft(request: request, completion: { result in
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

struct GetNftsRequest {
    var page: Int = 0
}

struct BuyNftRequest {
    var userId: Int = 0
    var editionId: Int = 0
}
