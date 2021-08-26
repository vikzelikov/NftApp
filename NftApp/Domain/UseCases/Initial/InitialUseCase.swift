//
//  InitialUseCase.swift
//  NftApp
//
//  Created by Yegor on 26.08.2021.
//

import Foundation

protocol InitialUseCase {
    
    func getInitialData(completion: @escaping (Result<InitialData, Error>) -> Void)
    
}

final class InitialUseCaseImpl: InitialUseCase {
    
    private let repository: InitialRepository?
    
    init() {
        self.repository = InitialRepositoryImpl()
    }
    
    func getInitialData(completion: @escaping (Result<InitialData, Error>) -> Void) {

        repository?.getInitialData(completion: { result in
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
