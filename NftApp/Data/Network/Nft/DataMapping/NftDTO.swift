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
        case price
        case serialNumber
        case isForCell
        case edition
    }
    
    let id: Int
    let price: Double
    let serialNumber: Int
    let isForCell: Bool
    let edition: EditionDTO
}
