//
//  DropShopUseCase.swift
//  DropShopUseCase
//
//  Created by Yegor on 25.08.2021.
//

import Foundation

protocol DropShopUseCase {
    
    func getEditions(request: GetEditionsRequest, completion: @escaping (Result<Bool, Error>) -> Void)
    
    func buyNft(editionId: Int, completion: @escaping (Result<Bool, Error>) -> Void)
    
}

final class DropShopUseCaseImpl: DropShopUseCase {
    
    private let repository: DropShopRepository?
    
    init() {
        self.repository = DropShopRepositoryImpl()
    }
    
    func getEditions(request: GetEditionsRequest, completion: @escaping (Result<Bool, Error>) -> Void) {

        repository?.getEditions(request: request, completion: { result in
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
