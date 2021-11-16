//
//  AuthRepository.swift
//  NftApp
//
//  Created by Yegor on 15.08.2021.
//

import Foundation

protocol AuthRepository {
    
    func signup(request: SignupRequest, completion: @escaping (Result<AuthResponseDTO, Error>) -> Void)
    
    func login(request: LoginRequest, completion: @escaping (Result<AuthResponseDTO, Error>) -> Void)
    
    func appleLogin(appleId: String, completion: @escaping (Result<AuthResponseDTO, Error>) -> Void)
    
    func checkInvite(inviteWord: String, completion: @escaping (Result<AuthResponseDTO, Error>) -> Void)
    
}
