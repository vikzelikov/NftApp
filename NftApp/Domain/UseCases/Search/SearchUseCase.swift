//
//  SearchUseCase.swift
//  NftApp
//
//  Created by Yegor on 05.11.2021.
//

import Foundation

protocol SearchUseCase {
    
    func searchUsers(keyWord: String, completion: @escaping (Result<[SearchCellViewModel], Error>) -> Void)
    
    func searchEditions(keyWord: String, completion: @escaping (Result<[SearchCellViewModel], Error>) -> Void)
    
    func searchNfts(keyWord: String, completion: @escaping (Result<[SearchCellViewModel], Error>) -> Void)
    
}

final class SearchUseCaseImpl: SearchUseCase {
    
    private let repository: SearchRepository
    
    init(repository: SearchRepository = DIContainer.shared.resolve(type: SearchRepository.self)) {
        self.repository = repository
    }
    
    func searchUsers(keyWord: String, completion: @escaping (Result<[SearchCellViewModel], Error>) -> Void) {
        repository.searchUsers(keyWord: keyWord, completion: { result in
            switch result {
            case .success(let resp) : do {
                let results = resp.rows.map {
                    SearchCellViewModel(
                        id: $0.id,
                        title: $0.login,
                        subtitle: nil,
                        mediaUrl: $0.avatarUrl,
                        type: .users
                    )
                }
                
                completion(.success(results))
            }
            
            case .failure(let error) : do {
                completion(.failure(error))
            }
            }
        })
    }
    
    func searchEditions(keyWord: String, completion: @escaping (Result<[SearchCellViewModel], Error>) -> Void) {
        repository.searchEditions(keyWord: keyWord, completion: { result in
            switch result {
            case .success(let resp) : do {
                let results = resp.rows.map {
                    SearchCellViewModel(
                        id: $0.id,
                        title: $0.name,
                        subtitle: $0.description,
                        mediaUrl: $0.mediaUrl,
                        type: .editions
                    )
                }
                
                completion(.success(results))
            }
            
            case .failure(let error) : do {
                completion(.failure(error))
            }
            }
        })
    }
    
    func searchNfts(keyWord: String, completion: @escaping (Result<[SearchCellViewModel], Error>) -> Void) {
        repository.searchNfts(keyWord: keyWord, completion: { result in
            switch result {
            case .success(let resp) : do {
                let results = resp.rows.map {
                    SearchCellViewModel(
                        id: $0.id,
                        title: $0.edition.name,
                        subtitle: nil,
                        mediaUrl: $0.edition.mediaUrl,
                        type: .nfts
                    )
                }
                
                completion(.success(results))
            }
            
            case .failure(let error) : do {
                completion(.failure(error))
            }
            }
        })
    }
    
}
