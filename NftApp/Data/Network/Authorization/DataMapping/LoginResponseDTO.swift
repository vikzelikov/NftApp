//
//  LoginResponseDTO.swift
//  NftApp
//
//  Created by Yegor on 16.08.2021.
//

import Foundation

struct LoginResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case token
    }
    
    let token: String
}
