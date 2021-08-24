//
//  UserRepositoryImpl.swift
//  NftApp
//
//  Created by Yegor on 20.08.2021.
//

import Foundation
import Alamofire
import SwiftyJSON

class UserRepositoryImpl: UserRepository {
    
    func getUser(userId: Int, completion: @escaping (Result<GetUserResponseDTO, Error>) -> Void) {
        let endpoint = UserEndpoints.getUserEndpoint(userId: userId)
        
        guard let url = endpoint.url else {
            completion(.failure(ErrorMessage(errorType: .cancelled, errorDTO: nil)))
            return
        }
        
        AF.request(url, method: endpoint.method, parameters: endpoint.data, headers: endpoint.headers).validate().responseString { response in
            guard let resp = response.response else {
                completion(.failure(ErrorMessage(errorType: .error, errorDTO: nil, code: nil)))
                return
            }
            
            guard let data = response.data else {
                completion(.failure(ErrorMessage(errorType: .error, errorDTO: nil, code: resp.statusCode)))
                return
            }
            
            if response.error != nil {
                if let errorDTO = try? JSONDecoder().decode(ErrorDTO.self, from: data) {
                    let error = ErrorMessage(errorType: .error, errorDTO: errorDTO, code: resp.statusCode)
                    completion(.failure(error))
                    return
                } else {
                    completion(.failure(ErrorMessage(errorType: .error, errorDTO: nil, code: resp.statusCode)))
                    return
                }
            }
                      
            print(JSON(data))
            
            if let responseDTO = try? JSONDecoder().decode(GetUserResponseDTO.self, from: data) {
                completion(.success(responseDTO))
            } else {
                completion(.failure(ErrorMessage(errorType: .error, errorDTO: nil, code: resp.statusCode)))
            }
        }
    }
    
}
