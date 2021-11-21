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
        case influencerId
        case login
        case email
        case avatarUrl
        case flowAddress
        case balance
        case totalCost
        case countNFTs
        case inviteWord
        case publicKey
    }
    
    let id: Int
    let influencerId: Int?
    let login: String
    let email: String?
    let avatarUrl: String?
    let flowAddress: String?
    let balance: String?
    let totalCost: String?
    let countNFTs: String?
    let inviteWord: String?
    let publicKey: String?
}
