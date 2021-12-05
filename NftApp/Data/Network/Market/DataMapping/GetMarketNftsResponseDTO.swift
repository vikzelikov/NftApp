//
//  GetMarketNftsResponseDTO.swift
//  NftApp
//
//  Created by Yegor on 26.08.2021.
//

import Foundation

struct GetMarketNftsResponseDTO: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case nfts
    }
    
    let nfts: [NftDTO]

}
