//
//  NftDTO.swift
//  NftApp
//
//  Created by Yegor on 25.08.2021.
//

import Foundation

struct EditionDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case influencerId
        case count
        case name
        case description
        case date
        case price
        case dateExpiration
        case mediaUrl
    }
    
    let id: Int
    let influencerId: Int
    let count: Int
    let name: String
    let description: String
    let date: TimeInterval
    let price: Double
    let dateExpiration: TimeInterval
    let mediaUrl: String
}
