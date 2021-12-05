//
//  AuthRepository.swift
//  NftApp
//
//  Created by Yegor on 16.08.2021.
//

import Foundation

class AuthRepositoryImpl: AuthRepository {
    
    func signup(request: SignupRequest, completion: @escaping (Result<AuthResponseDTO, Error>) -> Void) {
        let endpoint = AuthEndpoints.signupEndpoint(request: request)

        NetworkHelper.request(endpoint: endpoint, completion: completion)
    }
    
    func login(request: LoginRequest, completion: @escaping (Result<AuthResponseDTO, Error>) -> Void) {
        let endpoint = AuthEndpoints.getLoginEndpoint(request: request)

        NetworkHelper.request(endpoint: endpoint, completion: completion)
    }
    
    func appleLogin(appleId: String, completion: @escaping (Result<AuthResponseDTO, Error>) -> Void) {
        let endpoint = AuthEndpoints.appleLoginEndpoint(appleId: appleId)

        NetworkHelper.request(endpoint: endpoint, completion: completion)
    }
    
    func checkInvite(inviteWord: String, completion: @escaping (Result<AuthResponseDTO, Error>) -> Void) {
        let endpoint = AuthEndpoints.checkInviteEndpoint(inviteWord: inviteWord)
        
        NetworkHelper.request(endpoint: endpoint, completion: completion)
    }
    
}
    
