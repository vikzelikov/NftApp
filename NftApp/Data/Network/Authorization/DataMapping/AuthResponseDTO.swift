//
//  LoginResponseDTO.swift
//  NftApp
//
//  Created by Yegor on 16.08.2021.
//

import Foundation

struct AuthResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case userId
        case token
    }
    
    let userId: Int?
    let token: String?
}
