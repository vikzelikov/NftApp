//
//  AuthRepository.swift
//  NftApp
//
//  Created by Yegor on 15.08.2021.
//

import Foundation

protocol AuthRepository {
    
    func signup(request: SignupRequest, completion: @escaping (Result<SignupResponseDTO, Error>) -> Void)
    
    func login(request: LoginRequest, completion: @escaping (Result<LoginResponseDTO, Error>) -> Void)
    
}
