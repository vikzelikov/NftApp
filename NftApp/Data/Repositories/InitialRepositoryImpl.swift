//
//  InitialRepositoryImpl.swift
//  NftApp
//
//  Created by Yegor on 26.08.2021.
//

import Foundation

class InitialRepositoryImpl: InitialRepository {
    
    func getInitialData(completion: @escaping (Result<InitialResponseDTO, Error>) -> Void) {
        let endpoint = InitialEndpoints.getInitialEndpoint()

        NetworkHelper.request(endpoint: endpoint, completion: completion)
    }
    
}
