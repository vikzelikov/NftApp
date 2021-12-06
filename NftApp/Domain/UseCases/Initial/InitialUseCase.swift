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
    
    private let repository: InitialRepository
    
    init(repository: InitialRepository = DIContainer.shared.resolve(type: InitialRepository.self)) {
        self.repository = repository
    }
    
    func getInitialData(completion: @escaping (Result<InitialData, Error>) -> Void) {
        
        repository.getInitialData(completion: { result in
            switch result {
            case .success(let initialDataDTO) : do {
                let initialData = InitialData.init(data: initialDataDTO)
                
                InitialDataObject.data.value = initialData
                
                completion(.success(initialData))
            }
                        
            case .failure(let error) : do {
                completion(.failure(error))
            }
            }
        })
    }
    
}
