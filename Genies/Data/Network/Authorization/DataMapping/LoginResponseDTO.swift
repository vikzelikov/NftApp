//
//  LoginResponseDTO.swift
//  Genies
//
//  Created by Yegor on 16.08.2021.
//

import Foundation

struct LoginResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case login
        case email
        case password
        case sex
        case birthDate = "birth_date"
        case balance
    }
    
    let login: String
    let email: String
    let password: String
    let sex: String
    let birthDate: String
    let balance: String
}
