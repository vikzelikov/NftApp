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
                      
            if let responseDTO = try? JSONDecoder().decode(SignupResponseDTO.self, from: data) {
                completion(.success(responseDTO))
            } else {
                completion(.failure(ErrorMessage(errorType: .error, errorDTO: nil, code: resp.statusCode)))
            }
        }
    }
    
    func login(request: LoginRequest, completion: @escaping (Result<LoginResponseDTO, Error>) -> Void) {
        
        let endpoint = AuthEndpoints.getLoginEndpoint(request: request)
        
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
                        
            if let responseDTO = try? JSONDecoder().decode(LoginResponseDTO.self, from: data) {
                completion(.success(responseDTO))
            } else {
                completion(.failure(ErrorMessage(errorType: .error, errorDTO: nil, code: resp.statusCode)))
            }
        }
    }
}
    


