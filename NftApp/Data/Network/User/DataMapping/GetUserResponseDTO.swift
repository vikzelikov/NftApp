//
//  GetUserResponseDTO.swift
//  NftApp
//
//  Created by Yegor on 20.08.2021.
//

import Foundation

class GetUserResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case login
        case email
        case avatarUrl
        case flowAddress
        case balance
    }
    
    let id: Int
    let login: String
    let email: String
    let avatarUrl: String?
    let flowAddress: String?
    let balance: String?
}
