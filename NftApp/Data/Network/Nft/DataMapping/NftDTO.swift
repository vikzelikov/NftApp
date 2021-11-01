//
//  NftDTO.swift
//  NftApp
//
//  Created by Yegor on 25.08.2021.
//

import Foundation

class NftDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case userId
        case lastPrice
        case currentPrice
        case serialNumber
        case isForSell
        case edition
    }
    
    let id: Int
    let userId: Int
    let lastPrice: Double
    let currentPrice: Double?
    let serialNumber: Int
    let isForSell: Bool
    let edition: EditionDTO
}
