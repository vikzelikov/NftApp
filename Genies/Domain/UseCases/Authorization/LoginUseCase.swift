//
//  LoginUseCase.swift
//  Genies
//
//  Created by Yegor on 16.08.2021.
//

import Foundation

protocol LoginUseCase {
    func execute(request: LoginRequestUseCase, completion: @escaping (Result<LoginResponseDTO, Error>) -> Void)
}

final class LoginUseCaseImpl: LoginUseCase {
    
    private let repository: AuthRepository?
    
    init() {
        self.repository = AuthRepositoryImpl()
    }
    
    func execute(request: LoginRequestUseCase, completion: @escaping (Result<LoginResponseDTO, Error>) -> Void) {

        repository?.login(request: request, completion: { result in
            
        })
    }
}

struct LoginRequestUseCase {
    let login: String
    let password: String
}
