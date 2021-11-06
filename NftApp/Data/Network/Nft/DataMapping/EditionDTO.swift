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
        case influencer
    }
    
    let id: Int?
    let influencerId: Int?
    let count: Int
    let countNFTs: String?
    let name: String
    let description: String
    let price: Double?
    let dateExpiration: String
    let mediaUrl: String
    let influencer: EditionInfluencerDTO
}

class EditionInfluencerDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case user
        
    }
    
    let id: Int
    let user: EditionUserDTO
}

class EditionUserDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarUrl
        
    }
    
    let id: Int
    let login: String
    let avatarUrl: String?
}
