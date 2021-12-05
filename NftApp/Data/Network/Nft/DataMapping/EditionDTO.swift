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
        case countNFTs
        case name
        case description
        case price
        case dateExpiration
        case mediaUrl
        case influencer
    }
    
    let id: Int
    let influencerId: Int?
    let count: Int?
    let countNFTs: Int?
    let name: String
    let description: String
    let price: Double?
    let dateExpiration: String?
    let mediaUrl: String
    let influencer: EditionInfluencerDTO?
    
    static var defaultValue: EditionDTO {
        .init(
            id: 0,
            influencerId: 0,
            count: 1000,
            countNFTs: 30,
            name: "name",
            description: "description",
            price: 200.0,
            dateExpiration: "1640889297",
            mediaUrl: "",
            influencer: nil
        )
    }
    
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
