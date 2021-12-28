//
//  NftDTO.swift
//  NftApp
//
//  Created by Yegor on 25.08.2021.
//

import Foundation

struct NftDTO: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case id
        case userId
        case lastPrice
        case currentPrice
        case serialNumber
        case isForSell
        case isHidden
        case edition
    }
    
    let id: Int
    let userId: Int?
    let lastPrice: Double
    let currentPrice: Double?
    let serialNumber: Int
    let isForSell: Bool
    let isHidden: Bool
    let edition: EditionDTO
    
    static var placeholder: Self {
        .init(
            id: 0,
            userId: 0,
            lastPrice: 100.0,
            currentPrice: 150.0,
            serialNumber: 12345,
            isForSell: false,
            isHidden: false,
            edition: .placeholder
        )
    }
    
}
