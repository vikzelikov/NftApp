//
//  GetNftsUseCase.swift
//  NftApp
//
//  Created by Yegor on 25.08.2021.
//

import Foundation

protocol GetNftsUseCase {
    
    func getNfts(request: GetNftsRequest, completion: @escaping (Result<[NFT], Error>) -> Void)
        
}

final class GetNftsUseCaseImpl: GetNftsUseCase {
    
    private let repository: UserRepository?
    private let userStorage: UserStorage?
    
    init() {
        self.repository = UserRepositoryImpl()
        self.userStorage = UserStorageImpl()
    }
    
    func getNfts(request: GetNftsRequest, completion: @escaping (Result<[NFT], Error>) -> Void) {
        if let userId = userStorage?.getUserId() {
            repository?.getNfts(userId: userId, request: request, completion: { result in
                switch result {
                    case .success(let resp) : do {
                        print("success \(resp)")
                    }
                    
                    case .failure(let error) : do {
                        completion(.failure(error))
                    }
                }
            })
        } else {
            completion(.failure(ErrorMessage(errorType: .cancelled, errorDTO: nil, code: nil)))
        }
    }
}

struct GetNftsRequest {
    var page: Int = 0
}