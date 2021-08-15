//
//  AuthRepository.swift
//  Genies
//
//  Created by Yegor on 16.08.2021.
//

import Foundation
import Alamofire

class AuthRepositoryImpl: AuthRepository {
    
    func signup(request: SignupRequestUseCase, completion: @escaping (Result<SignupResponseDTO, Error>) -> Void) {
        
        let endpoint = AuthEndpoints.getSignupEndpoint()
        
        guard let url = endpoint.url else {
            completion(.failure(NetworkError.cancelled))
            return
        }
        
        let requestDTO = SignupRequestDTO (
            login: request.login,
            email: request.email,
            password: request.password,
            sex: request.sex,
            birthDate: request.birthDate
        ).parameters
        
        let headers: HTTPHeaders = NetworkHelper.getHeaders()

        AF.request(url, method: endpoint.method, parameters: requestDTO, headers: endpoint.headers).responseString { response in
            guard let data = response.data else {
                completion(.failure(NetworkError.errorData))
                return
            }
            
            guard let response = response.response else {
                completion(.failure(NetworkError.errorData))
                return
            }
            
            if response.statusCode != 200 {
                completion(.failure(NetworkError.errorCode(statusCode: response.statusCode)))
                return
            }
            
            if let responseDTO = try? JSONDecoder().decode(SignupResponseDTO.self, from: data) {
                completion(.success(responseDTO))
            } else {
                completion(.failure(NetworkError.errorData))
            }
        }
    }
    
    
    func login(request: LoginRequestUseCase, completion: @escaping (Result<LoginResponseDTO, Error>) -> Void) {
        
        let endpoint = AuthEndpoints.getLoginEndpoint()
        
        guard let url = endpoint.url else {
            completion(.failure(NetworkError.cancelled))
            return
        }
        
        let requestDTO = LoginRequestDTO (
            login: request.login,
            password: request.password
        ).parameters
        
        AF.request(url, method: endpoint.method, parameters: requestDTO, headers: endpoint.headers).responseString { response in
            guard let data = response.data else {
                completion(.failure(NetworkError.errorData))
                return
            }
            
            guard let response = response.response else {
                completion(.failure(NetworkError.errorData))
                return
            }
            
            if response.statusCode != 200 {
                completion(.failure(NetworkError.errorCode(statusCode: response.statusCode)))
                return
            }
            
            if let responseDTO = try? JSONDecoder().decode(LoginResponseDTO.self, from: data) {
                completion(.success(responseDTO))
            } else {
                completion(.failure(NetworkError.errorData))
            }
        }
    }
        
}
    


