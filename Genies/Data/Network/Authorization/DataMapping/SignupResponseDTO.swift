//
//  SignupResponseDTO.swift
//  Genies
//
//  Created by Yegor on 16.08.2021.
//

import Foundation

struct SignupResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case login
        case email
        case password
        case isMale = "is_male"
        case birthDate = "birth_date"
        case balance
    }
    
    let id: Int
    let login: String
    let email: String
    let password: String
    let isMale: Bool
    let birthDate: TimeInterval
    let balance: String
}
