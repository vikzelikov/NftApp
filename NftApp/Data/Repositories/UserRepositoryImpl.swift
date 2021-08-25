//
//  UserRepositoryImpl.swift
//  NftApp
//
//  Created by Yegor on 20.08.2021.
//

import Foundation
import Alamofire

class UserRepositoryImpl: UserRepository {
    
    func getUser(userId: Int, completion: @escaping (Result<GetUserResponseDTO, Error>) -> Void) {
        let endpoint = UserEndpoints.getUserEndpoint(userId: userId)
        
        guard let url = endpoint.url else {
            completion(.failure(ErrorMessage(errorType: .cancelled, errorDTO: nil)))
            return
        }
        
        AF.request(url, method: endpoint.method, parameters: endpoint.data, headers: endpoint.headers).validate().responseString { response in
            
            NetworkHelper.validateResponse(response: response, completion: completion)
            
        }
    }
    
    func updateUser(userId: Int, request: User, completion: @escaping (Result<UpdateUserResponseDTO, Error>) -> Void) {
        let endpoint = UserEndpoints.updateUserEndpoint(userId: userId, request: request)
        
        guard let url = endpoint.url else {
            completion(.failure(ErrorMessage(errorType: .cancelled, errorDTO: nil)))
            return
        }
        
        AF.request(url, method: endpoint.method, parameters: endpoint.data, headers: endpoint.headers).validate().responseString { response in
            
            NetworkHelper.validateResponse(response: response, completion: completion)
            
        }
    }
    
    func getNfts(userId: Int, request: GetNftsRequest, completion: @escaping (Result<GetNftsResponseDTO, Error>) -> Void) {
        let endpoint = UserEndpoints.getNftsEndpoint(userId: userId, request: request)
        
        guard let url = endpoint.url else {
            completion(.failure(ErrorMessage(errorType: .cancelled, errorDTO: nil)))
            return
        }
        
        AF.request(url, method: endpoint.method, parameters: endpoint.data, headers: endpoint.headers).validate().responseString { response in
           
            NetworkHelper.validateResponse(response: response, completion: completion)
            
        }
    }
    
}
