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

struct InfluencerDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case userId
    }
    
    let userId: Int
}
