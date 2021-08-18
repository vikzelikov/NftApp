//
//  AuthRepository.swift
//  Genies
//
//  Created by Yegor on 15.08.2021.
//

import Foundation

protocol AuthRepository {
    
    func signup(request: SignupRequest, completion: @escaping (Result<SignupResponseDTO, Error>) -> Void)
    
    func login(request: LoginRequestUseCase, completion: @escaping (Result<LoginResponseDTO, Error>) -> Void)
    
}
