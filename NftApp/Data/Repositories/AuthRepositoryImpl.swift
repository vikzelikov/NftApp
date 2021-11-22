//
//  AuthRepository.swift
//  NftApp
//
//  Created by Yegor on 16.08.2021.
//

import Foundation
import Alamofire

class AuthRepositoryImpl: AuthRepository {
    
    func signup(request: SignupRequest, completion: @escaping (Result<AuthResponseDTO, Error>) -> Void) {
        let endpoint = AuthEndpoints.signupEndpoint(request: request)
        
        AF.request(endpoint.url, method: endpoint.method, parameters: endpoint.data, headers: endpoint.headers).validate().responseString { response in
            
            NetworkHelper.validateResponse(response: response, completion: completion)
            
        }
    }
    
    func login(request: LoginRequest, completion: @escaping (Result<AuthResponseDTO, Error>) -> Void) {
        let endpoint = AuthEndpoints.getLoginEndpoint(request: request)

        AF.request(endpoint.url, method: endpoint.method, parameters: endpoint.data, headers: endpoint.headers).validate().responseString { response in
            
            NetworkHelper.validateResponse(response: response, completion: completion)
            
        }
    }
    
    func appleLogin(appleId: String, completion: @escaping (Result<AuthResponseDTO, Error>) -> Void) {
        let endpoint = AuthEndpoints.appleLoginEndpoint(appleId: appleId)

        AF.request(endpoint.url, method: endpoint.method, parameters: endpoint.data, headers: endpoint.headers).validate().responseString { response in
            
            NetworkHelper.validateResponse(response: response, completion: completion)
            
        }
    }
    
    func checkInvite(inviteWord: String, completion: @escaping (Result<AuthResponseDTO, Error>) -> Void) {
        let endpoint = AuthEndpoints.checkInviteEndpoint(inviteWord: inviteWord)
        AF.request(endpoint.url, method: endpoint.method, parameters: endpoint.data, headers: endpoint.headers).validate().responseString { response in
            
            NetworkHelper.validateResponse(response: response, completion: completion)
            
        }
    }
    
}
    


