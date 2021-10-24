//
//  BuyNftResponseDTO.swift
//  NftApp
//
//  Created by Yegor on 25.08.2021.
//

import Foundation

struct BuyNftResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case mintId
        case userId
        case editionId
        case serialNumber
        case currentPrice
        case lastPrice
        case isForSell
    }
    
    let id: Int
    let mintId: Int?
    let userId: Int
    let editionId: Int
    let serialNumber: Int
    let currentPrice: Double?
    let lastPrice: Int
    let isForSell: Bool
}
