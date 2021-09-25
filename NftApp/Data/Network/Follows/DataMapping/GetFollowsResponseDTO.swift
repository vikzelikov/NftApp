//
//  GetFollowsResponseDTO.swift
//  NftApp
//
//  Created by Yegor on 25.09.2021.
//

import Foundation

class GetFollowsResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case users
    }
    
    let users: [GetUserResponseDTO]
    
}
