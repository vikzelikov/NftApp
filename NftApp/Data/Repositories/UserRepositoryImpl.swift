//
//  UserRepositoryImpl.swift
//  NftApp
//
//  Created by Yegor on 20.08.2021.
//

import Foundation
import Alamofire

class UserRepositoryImpl: UserRepository {
    
    func getUser(completion: @escaping (Result<GetUserResponseDTO, Error>) -> Void) {
        let endpoint = UserEndpoints.getUserEndpoint()
        
        guard let url = endpoint.url else {
            completion(.failure(ErrorMessage(errorType: .cancelled, errorDTO: nil)))
            return
        }
        
        AF.request(url, method: endpoint.method, parameters: endpoint.data, headers: endpoint.headers).validate().responseString { response in
            
            NetworkHelper.validateResponse(response: response, completion: completion)
            
        }
    }
    
    func updateUser(request: User, completion: @escaping (Result<UpdateUserResponseDTO, Error>) -> Void) {
        let endpoint = UserEndpoints.updateUserEndpoint(request: request)
        
        guard let url = endpoint.url else {
            completion(.failure(ErrorMessage(errorType: .cancelled, errorDTO: nil)))
            return
        }
        
        AF.request(url, method: endpoint.method, parameters: endpoint.data, headers: endpoint.headers).validate().responseString { response in
            
            NetworkHelper.validateResponse(response: response, completion: completion)
            
        }
    }
    
    func getNfts(request: GetNftsRequest, completion: @escaping (Result<GetNftsResponseDTO, Error>) -> Void) {
        let endpoint = UserEndpoints.getNftsEndpoint(request: request)
        
        guard let url = endpoint.url else {
            completion(.failure(ErrorMessage(errorType: .cancelled, errorDTO: nil)))
            return
        }
        
        AF.request(url, method: endpoint.method, parameters: endpoint.data, headers: endpoint.headers).validate().responseString { response in
           
            NetworkHelper.validateResponse(response: response, completion: completion)
            
        }
    }
    
}
