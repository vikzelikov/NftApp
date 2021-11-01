//
//  GetInfluencersResponseDTO.swift
//  NftApp
//
//  Created by Yegor on 29.10.2021.
//

import Foundation

class GetInfluencersResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case rows
    }
    
    let rows: [InfluencerDTO]
}

class InfluencerDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case user
    }
    
    let user: GetUserResponseDTO
}
