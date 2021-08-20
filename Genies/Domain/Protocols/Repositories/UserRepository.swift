//
//  UserRepositoryImpl.swift
//  Genies
//
//  Created by Yegor on 20.08.2021.
//

import Foundation

protocol UserRepository {
    
    func getUser(userId: Int, completion: @escaping (Result<GetUserResponseDTO, Error>) -> Void)
        
}
