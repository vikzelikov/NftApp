//
//  BuyNftResponseDTO.swift
//  NftApp
//
//  Created by Yegor on 25.08.2021.
//

import Foundation

struct BuyNftResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case nftId
    }
    
    let nftId: Int
}
