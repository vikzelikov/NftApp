//
//  GetNftsResponseDTO.swift
//  NftApp
//
//  Created by Yegor on 25.08.2021.
//

import Foundation

struct GetEditionsResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case count
        case rows
    }
    
    let count: Int
    let rows: [EditionDTO]

}
