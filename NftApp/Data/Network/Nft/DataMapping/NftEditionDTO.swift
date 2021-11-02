//
//  NftDTO.swift
//  NftApp
//
//  Created by Yegor on 25.08.2021.
//

import Foundation

class EditionDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case influencerId
        case count
        case countNFTs
        case name
        case description
        case price
        case dateExpiration
        case mediaUrl
    }
    
    let id: Int
    let influencerId: Int
    let count: Int
    let countNFTs: String?
    let name: String
    let description: String
    let price: Double
    let dateExpiration: String
    let mediaUrl: String
}
