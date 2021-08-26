//
//  GetMarketNftsResponseDTO.swift
//  NftApp
//
//  Created by Yegor on 26.08.2021.
//

import Foundation

struct GetMarketNftsResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case editions
    }
    
    let editions: [EditionDTO]

    struct EditionDTO: Decodable {
        private enum CodingKeys: String, CodingKey {
            case id
            case metadata = "nft_metadata"
            case count
            case name
            case description
            case date
            case price
            case dateExpiration
        }
        
        let id: Int
        let metadata: NftMetadataDTO
        let count: Int
        let name: String
        let description: String
        let date: TimeInterval
        let price: Double
        let dateExpiration: TimeInterval
    }
}
