//
//  CheckFollowResponseDTO.swift
//  NftApp
//
//  Created by Yegor on 28.10.2021.
//

import Foundation

class CheckFollowResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case type
    }
    
    let type: String
}
