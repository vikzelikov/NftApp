//
//  NftDTO.swift
//  NftApp
//
//  Created by Yegor on 25.08.2021.
//

import Foundation

struct NftMetadataDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case title
        case description
        case mediaUrl
    }
    
    let title: String?
    let description: String?
    let mediaUrl: String?
}
