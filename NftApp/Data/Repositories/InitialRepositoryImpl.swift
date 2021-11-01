//
//  InitialRepositoryImpl.swift
//  NftApp
//
//  Created by Yegor on 26.08.2021.
//

import Foundation
import Alamofire

class InitialRepositoryImpl: InitialRepository {
    
    func getInitialData(completion: @escaping (Result<InitialResponseDTO, Error>) -> Void) {
        let endpoint = InitialEndpoints.getInitialEndpoint()

        AF.request(endpoint.url, method: endpoint.method, parameters: endpoint.data, headers: endpoint.headers).validate().responseString { response in
            
            NetworkHelper.validateResponse(response: response, completion: completion)
            
        }
    }
    
}
