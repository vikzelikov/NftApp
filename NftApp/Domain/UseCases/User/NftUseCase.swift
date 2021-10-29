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
                    print("success!!!!!! \(resp)")
                }
                
                case .failure(let error) : do {
                    print("!!!!success ")
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
