//
//  AuthRepository.swift
//  NftApp
//
//  Created by Yegor on 16.08.2021.
//

import Foundation
import Alamofire

class AuthRepositoryImpl: AuthRepository {
    
    func signup(request: SignupRequest, completion: @escaping (Result<SignupResponseDTO, Error>) -> Void) {

        let endpoint = AuthEndpoints.getSignupEndpoint(request: request)
        
        guard let url = endpoint.url else {
            completion(.failure(ErrorMessage(errorType: .cancelled, errorDTO: nil)))
            return
        }
        
        AF.request(url, method: endpoint.method, parameters: endpoint.data, headers: endpoint.headers).validate().responseString { response in
            
            NetworkHelper.validateResponse(response: response, completion: completion)
            
        }
    }
    
    func login(request: LoginRequest, completion: @escaping (Result<LoginResponseDTO, Error>) -> Void) {
        
        let endpoint = AuthEndpoints.getLoginEndpoint(request: request)
        
        guard let url = endpoint.url else {
            completion(.failure(ErrorMessage(errorType: .cancelled, errorDTO: nil)))
            return
        }
        
        AF.request(url, method: endpoint.method, parameters: endpoint.data, headers: endpoint.headers).validate().responseString { response in
            
            NetworkHelper.validateResponse(response: response, completion: completion)
            
        }
    }
}
    


