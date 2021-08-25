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
        case metadata
    }
    
    let id: Int
    let metadata: NftMetadataDTO
}
